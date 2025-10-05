public class TestFileRead {
    public static void main(String[] args) {
        ReadFile app = new ReadFile();
        app.openFile();
        app.readPrisms();
        app.closeFile();
    }
}
