package lt.niomath;

import java.nio.ByteBuffer;
import java.util.Queue;
import java.util.LinkedList;

public class ClientSession {
    public StringBuilder inputBuffer;
    public Queue<ByteBuffer> pendingWrites;
    public String clientId;

    public ClientSession(String clientId) {
        this.inputBuffer = new StringBuilder();
        this.pendingWrites = new LinkedList<>();
        this.clientId = clientId;
    }
}
