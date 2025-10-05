import java.io.EOFException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;

public class ReadFile {
    private ObjectInputStream input;

    public void openFile() {
        try {
            input = new ObjectInputStream(new FileInputStream("prisms3.ser"));
        } catch (IOException ioe) {
            System.err.println("Error opening file.");
        }
    }

    public void readPrisms() {
        TriangularPrism t;
        int i = 1;
        try {
            while (true) {
                t = (TriangularPrism) input.readObject();
                System.out.print(i++ + " ");
                t.print();
            }
        } catch (EOFException eof) {
            return;
        } catch (ClassNotFoundException | IOException e) {
            e.printStackTrace();
        }
    }

    public void closeFile() {
        try {
            if (input != null) input.close();
        } catch (IOException ioe) {
            System.err.println("Error closing file.");
            System.exit(1);
        }
    }
}
