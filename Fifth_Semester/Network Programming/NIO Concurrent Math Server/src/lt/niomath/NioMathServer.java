package lt.niomath;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

public class NioMathServer {

    private final int tcpPort;
    private final int udpPort;
    private Selector selector;
    private ServerSocketChannel serverSocketChannel;
    private ExecutorService workerPool;
    private Thread udpThread;
    private final AtomicInteger activeClients = new AtomicInteger(0);
    private final AtomicInteger totalRequests = new AtomicInteger(0);
    private final RequestLogger logger = new RequestLogger();

    public NioMathServer(int tcpPort, int udpPort) {
        this.tcpPort = tcpPort;
        this.udpPort = udpPort;
    }

    public static void main(String[] args) {
        int tcpPort = 5000;
        int udpPort = 6000;
        try {
            NioMathServer server = new NioMathServer(tcpPort, udpPort);
            server.start();
        } catch (IOException e) {
            System.err.println("Server could not be started: " + e.getMessage());
        }
    }

    public void start() throws IOException {
        selector = Selector.open();
        serverSocketChannel = ServerSocketChannel.open();
        serverSocketChannel.configureBlocking(false);
        serverSocketChannel.socket().bind(new InetSocketAddress(tcpPort));
        serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);

        workerPool = Executors.newCachedThreadPool();

        UdpStatusServer udpServer = new UdpStatusServer(udpPort, tcpPort, activeClients, totalRequests);
        udpThread = new Thread(udpServer);
        udpThread.setDaemon(true);
        udpThread.start();

        System.out.println("TCP Math Server started on port " + tcpPort);

        Runtime.getRuntime().addShutdownHook(new Thread(this::shutdown));

        while (!Thread.currentThread().isInterrupted()) {
            selector.select();
            Iterator<SelectionKey> keys = selector.selectedKeys().iterator();
            while (keys.hasNext()) {
                SelectionKey key = keys.next();
                keys.remove();

                if (!key.isValid()) {
                    continue;
                }

                if (key.isAcceptable()) {
                    handleAccept(key);
                } else if (key.isReadable()) {
                    handleRead(key);
                } else if (key.isWritable()) {
                    handleWrite(key);
                }
            }
        }
    }

    private void handleAccept(SelectionKey key) throws IOException {
        ServerSocketChannel serverChannel = (ServerSocketChannel) key.channel();
        SocketChannel clientChannel = serverChannel.accept();
        clientChannel.configureBlocking(false);
        String clientId = clientChannel.getRemoteAddress().toString();
        ClientSession session = new ClientSession(clientId);
        clientChannel.register(selector, SelectionKey.OP_READ, session);
        activeClients.incrementAndGet();
        System.out.println("Accepted connection from: " + clientId);
    }

    private void handleRead(SelectionKey key) throws IOException {
        SocketChannel clientChannel = (SocketChannel) key.channel();
        ClientSession session = (ClientSession) key.attachment();
        ByteBuffer buffer = ByteBuffer.allocate(1024);

        int bytesRead;
        try {
            bytesRead = clientChannel.read(buffer);
        } catch (IOException e) {
            closeKey(key);
            return;
        }

        if (bytesRead == -1) {
            closeKey(key);
            return;
        }

        if (bytesRead > 0) {
            buffer.flip();
            String chunk = StandardCharsets.UTF_8.decode(buffer).toString();
            session.inputBuffer.append(chunk);

            workerPool.execute(() -> processClientInput(key, session));
        }
    }

    private void processClientInput(SelectionKey key, ClientSession session) {
        String input = session.inputBuffer.toString();
        int newlineIndex;
        while ((newlineIndex = input.indexOf('\n')) != -1) {
            String line = input.substring(0, newlineIndex).trim();
            input = input.substring(newlineIndex + 1);

            if (!line.isEmpty()) {
                totalRequests.incrementAndGet();
                String response;
                try {
                    response = MathProtocol.processLine(line);
                } catch (ProtocolException e) {
                    response = "ERROR " + e.getMessage();
                }

                String logMessage = String.format("REQ=%s RESP=%s CLIENT=%s", line, response, session.clientId);
                logger.log(logMessage);

                ByteBuffer responseBuffer = ByteBuffer.wrap((response + "\n").getBytes(StandardCharsets.UTF_8));
                session.pendingWrites.add(responseBuffer);
                key.interestOps(SelectionKey.OP_WRITE);
                selector.wakeup();
            }
        }
        session.inputBuffer = new StringBuilder(input);
    }

    private void handleWrite(SelectionKey key) throws IOException {
        SocketChannel clientChannel = (SocketChannel) key.channel();
        ClientSession session = (ClientSession) key.attachment();

        while (!session.pendingWrites.isEmpty()) {
            ByteBuffer buffer = session.pendingWrites.peek();
            clientChannel.write(buffer);
            if (buffer.hasRemaining()) {
                return; // Socket buffer is full
            }
            session.pendingWrites.poll();
        }

        key.interestOps(SelectionKey.OP_READ);
    }

    private void closeKey(SelectionKey key) throws IOException {
        key.cancel();
        SocketChannel clientChannel = (SocketChannel) key.channel();
        String clientId = ((ClientSession) key.attachment()).clientId;
        clientChannel.close();
        activeClients.decrementAndGet();
        System.out.println("Connection closed: " + clientId);
    }

    public void shutdown() {
        System.out.println("Shutting down server...");
        if (selector != null) {
            try {
                selector.close();
            } catch (IOException e) {
                // Ignore
            }
        }
        if (serverSocketChannel != null) {
            try {
                serverSocketChannel.close();
            } catch (IOException e) {
                // Ignore
            }
        }
        if (workerPool != null) {
            workerPool.shutdown();
        }
        if (udpThread != null) {
            udpThread.interrupt();
        }
        System.out.println("Server shutdown complete.");
    }
}
