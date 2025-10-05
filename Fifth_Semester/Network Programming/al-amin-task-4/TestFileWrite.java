public class TestFileWrite {
    public static void main(String[] args) {
        CreateFile app = new CreateFile();
        app.openFile();
        app.add7Prisms();
        app.closeFile();
    }
}
