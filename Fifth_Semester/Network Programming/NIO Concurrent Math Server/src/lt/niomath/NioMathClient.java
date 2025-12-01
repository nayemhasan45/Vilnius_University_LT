package lt.niomath;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class NioMathClient {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java NioMathClient <host> <port>");
            return;
        }

        String host = args[0];
        int port = Integer.parseInt(args[1]);

        try (SocketChannel socketChannel = SocketChannel.open(new InetSocketAddress(host, port));
             Scanner scanner = new Scanner(System.in)) {

            System.out.println("Connected to the math server. Type 'QUIT' to exit.");
            ByteBuffer buffer = ByteBuffer.allocate(1024);

            while (true) {
                System.out.print("> ");
                String line = scanner.nextLine();

                if ("QUIT".equalsIgnoreCase(line)) {
                    break;
                }

                // Send message to server
                ByteBuffer writeBuffer = ByteBuffer.wrap((line + "\n").getBytes(StandardCharsets.UTF_8));
                while(writeBuffer.hasRemaining()) {
                    socketChannel.write(writeBuffer);
                }

                // Read response from server
                buffer.clear();
                int bytesRead = socketChannel.read(buffer);
                if (bytesRead > 0) {
                    buffer.flip();
                    String response = StandardCharsets.UTF_8.decode(buffer).toString().trim();
                    System.out.println("Server: " + response);
                }
            }
        } catch (IOException e) {
            System.err.println("Client error: " + e.getMessage());
        }
    }
}
