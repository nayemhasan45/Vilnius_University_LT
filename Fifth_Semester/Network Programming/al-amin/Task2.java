import java.io.*;
import java.nio.*;
import java.nio.channels.*;

public class Task2 {

    public static void main(String[] args) {
        String inputFile = "input.txt";
        String fileA = "output_four_times.txt";
        String fileB = "final_with_name.txt";

        try {
           
            FileChannel inChannel = new FileInputStream(inputFile).getChannel();
            FileChannel outChannelA = new FileOutputStream(fileA).getChannel();

            for (int i = 0; i < 4; i++) {
                inChannel.transferTo(0, inChannel.size(), outChannelA);
            }

            inChannel.close();
            outChannelA.close();

          
            FileChannel sourceA = new FileInputStream(fileA).getChannel();
            FileChannel outB = new FileOutputStream(fileB).getChannel();

            sourceA.transferTo(0, sourceA.size(), outB);

        
            String personalData = "al amin hossain nayem bangladesh";
            ByteBuffer buf = ByteBuffer.wrap(personalData.getBytes());

            outB.position(200);
            outB.write(buf);

            sourceA.close();
            outB.close();

            System.out.println("Task 2 completed successfully!");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
