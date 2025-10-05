import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.Scanner;

public class CreateFile {
    private ObjectOutputStream output;

    public void openFile() {
        try {
            output = new ObjectOutputStream(new FileOutputStream("prisms3.ser"));
        } catch (IOException ioe) {
            System.err.println("Error opening file.");
        }
    }

    public void add7Prisms() {
        Scanner sc = new Scanner(System.in);
        TriangularPrism t;
        double a, b, c, h;

        System.out.println("Enter seven triangular prisms (a b c h):");
        for (int i = 0; i < 7; i++) {
            System.out.print("Prism " + (i + 1) + ": ");
            a = sc.nextDouble();
            b = sc.nextDouble();
            c = sc.nextDouble();
            h = sc.nextDouble();

            try {
                t = new TriangularPrism(a, b, c, h);
                output.writeObject(t);
            } catch (IOException ioe) {
                System.err.println("Error writing to file.");
                return;
            }
        }
        sc.close();
    }

    public void closeFile() {
        try {
            if (output != null) output.close();
        } catch (IOException ioe) {
            System.err.println("Error closing file.");
            System.exit(1);
        }
    }
}
