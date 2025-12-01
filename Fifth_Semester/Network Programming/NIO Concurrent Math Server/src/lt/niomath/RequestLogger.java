package lt.niomath;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RequestLogger {
    private static final String LOG_FILE = "logs/requests.log";
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

    public synchronized void log(String entry) {
        String timestamp = dateFormat.format(new Date());
        String logEntry = String.format("[%s] %s\n", timestamp, entry);

        try (FileChannel fileChannel = FileChannel.open(Paths.get(LOG_FILE),
                StandardOpenOption.WRITE, StandardOpenOption.CREATE, StandardOpenOption.APPEND)) {
            byte[] bytes = logEntry.getBytes("UTF-8");
            ByteBuffer buffer = ByteBuffer.wrap(bytes);
            while (buffer.hasRemaining()) {
                fileChannel.write(buffer);
            }
        } catch (IOException e) {
            System.err.println("Failed to write to log file: " + e.getMessage());
        }
    }
}
