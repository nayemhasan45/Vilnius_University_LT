import java.io.Serializable;

public class TriangularPrism implements Serializable {

    private static final long serialVersionUID = 300L;

    private double a, b, c, height;

    public TriangularPrism() {
        this(3, 4, 5, 6);
    }

    public TriangularPrism(double a, double b, double c, double h) {
        set_A(a);
        set_B(b);
        set_C(c);
        set_H(h);
    }

    public void set_A(double a) { this.a = (a > 0) ? a : 1; }
    public void set_B(double b) { this.b = (b > 0) ? b : 1; }
    public void set_C(double c) { this.c = (c > 0) ? c : 1; }
    public void set_H(double h) { this.height = (h > 0) ? h : 1; }

    public double get_A() { return a; }
    public double get_B() { return b; }
    public double get_C() { return c; }
    public double get_H() { return height; }

    public double area() {
        double s = (a + b + c) / 2;
        double base = Math.sqrt(s * (s - a) * (s - b) * (s - c));
        return 2 * base + (a + b + c) * height;
    }

    public double volume() {
        double s = (a + b + c) / 2;
        double base = Math.sqrt(s * (s - a) * (s - b) * (s - c));
        return base * height;
    }

    public void print() {
        System.out.println("Triangular prism with a=" + a + ", b=" + b + ", c=" + c +
                " and height H=" + height +
                ", has area P=" + area() + " and volume V=" + volume());
    }
}
