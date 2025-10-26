import java.io.*;
import java.net.*;

public class CalcServer {

    public static void main(String[] args) {
        int port = 3000;

        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Server is listening on port " + port);

            Socket socket = serverSocket.accept();
            System.out.println("Client connected!");

            BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);

            // Step 1: Receive X and Y
            float x = Float.parseFloat(reader.readLine());
            float y = Float.parseFloat(reader.readLine());

            String choice;
            writer.println("Choose an operation:\n1. Addition (+)\n2. Subtraction (-)\n3. Multiplication (*)\n4. Division (/)");
            
            // Step 2: Loop until valid choice
            while (true) {
                choice = reader.readLine();
                float result = 0;
                boolean valid = true;

                switch (choice) {
                    case "1":
                    case "+":
                        result = x + y;
                        break;
                    case "2":
                    case "-":
                        result = x - y;
                        break;
                    case "3":
                    case "*":
                        result = x * y;
                        break;
                    case "4":
                    case "/":
                        result = x / y;
                        break;
                    default:
                        valid = false;
                        writer.println("Wrong choice! Choose again");
                        continue;
                }

                if (valid) {
                    writer.println("RESULT: " + result);
                    break;
                }
            }

            socket.close();
            System.out.println("Client disconnected. Server finished.");

        } catch (IOException e) {
            System.out.println("Server exception: " + e.getMessage());
        }
    }
}
