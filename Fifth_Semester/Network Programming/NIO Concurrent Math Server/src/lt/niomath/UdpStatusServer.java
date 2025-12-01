package lt.niomath;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.util.concurrent.atomic.AtomicInteger;

public class UdpStatusServer implements Runnable {
    private final int port;
    private final AtomicInteger activeClients;
    private final AtomicInteger totalRequests;
    private final int tcpPort;

    public UdpStatusServer(int port, int tcpPort, AtomicInteger activeClients, AtomicInteger totalRequests) {
        this.port = port;
        this.tcpPort = tcpPort;
        this.activeClients = activeClients;
        this.totalRequests = totalRequests;
    }

    @Override
    public void run() {
        try (DatagramSocket socket = new DatagramSocket(port)) {
            System.out.println("UDP Status Server started on port " + port);
            byte[] receiveBuffer = new byte[1024];

            while (!Thread.currentThread().isInterrupted()) {
                DatagramPacket receivePacket = new DatagramPacket(receiveBuffer, receiveBuffer.length);
                socket.receive(receivePacket);

                String request = new String(receivePacket.getData(), 0, receivePacket.getLength()).trim();
                if ("STATUS".equalsIgnoreCase(request)) {
                    String response = String.format(
                            "MATH_SERVER_RUNNING TCP_PORT=%d ACTIVE_CLIENTS=%d TOTAL_REQUESTS=%d",
                            tcpPort, activeClients.get(), totalRequests.get());
                    byte[] sendBuffer = response.getBytes("UTF-8");

                    DatagramPacket sendPacket = new DatagramPacket(sendBuffer, sendBuffer.length,
                            receivePacket.getAddress(), receivePacket.getPort());
                    socket.send(sendPacket);
                }
            }
        } catch (SocketException e) {
            if (!Thread.currentThread().isInterrupted()) {
                System.err.println("UDP Server socket error: " + e.getMessage());
            }
        } catch (IOException e) {
            System.err.println("UDP Server I/O error: " + e.getMessage());
        } finally {
            System.out.println("UDP Status Server stopped.");
        }
    }
}
