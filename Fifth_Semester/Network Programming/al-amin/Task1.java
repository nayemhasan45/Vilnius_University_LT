import java.nio.DoubleBuffer;

public class Task1 {

    // Function f(x) = 6x^2 − 2x − 1
    private static double f(int x) {
        return 6 * x * x - 2 * x - 1;
    }

    public static void main(String[] args) {

        DoubleBuffer buf = DoubleBuffer.allocate(31);

        int index = 0;
        for (int x = -15; x <= 15; x++) {
            buf.put(index, f(x));
            index++;
        }

        int startX = 3;
        int endX = 10;

        int startIndex = startX + 15;   // convert x to buffer index
        int endIndex   = endX + 15 + 1; // limit is exclusive

        buf.position(startIndex);
        buf.limit(endIndex);

        DoubleBuffer slice = buf.slice();

        System.out.println("=== Sub-buffer values (x = 3 to 10) ===");
        for (int i = 0; i < slice.capacity(); i++) {
            int xVal = (startIndex + i) - 15;
            System.out.println(xVal + " " + slice.get(i));
        }


        System.out.println("\n=== All values in main buffer ===");
        buf.clear(); // reset: position=0, limit=capacity

        for (int i = 0; i < buf.capacity(); i++) {
            int xVal = i - 15;
            System.out.println(xVal + " " + buf.get(i));
        }
    }
}
