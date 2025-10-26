import java.io.*;
import java.net.*;
import java.util.Scanner;

public class CalcClient {

    public static void main(String[] args) {
        String host = "localhost";
        int port = 3000;

        try (Socket socket = new Socket(host, port)) {
            System.out.println("Connected to server!");

            PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            Scanner scanner = new Scanner(System.in);

            // Send X and Y
            System.out.print("Enter first number (X): ");
            writer.println(scanner.nextFloat());
            System.out.print("Enter second number (Y): ");
            writer.println(scanner.nextFloat());
            scanner.nextLine(); // clear buffer

            // ✅ Read and print the entire menu sent by server
            String menuLine;
            while (!(menuLine = reader.readLine()).startsWith("Choose") == false && menuLine.contains("1.") == false) {
                if (menuLine == null) break;
                System.out.println(menuLine);
            }
            System.out.println(menuLine); // print the "Choose..." line
            // Now print next lines (remaining options)
            for (int i = 0; i < 3; i++) {
                System.out.println(reader.readLine());
            }

            // Now take user choice after full menu is shown
            System.out.print("Enter your choice (1,2,3,4 or +,-,*,/): ");
            writer.println(scanner.nextLine());

            // ✅ Read and print result
            System.out.println(reader.readLine());

            scanner.close();

        } catch (IOException e) {
            System.out.println("Client exception: " + e.getMessage());
        }
    }
}
