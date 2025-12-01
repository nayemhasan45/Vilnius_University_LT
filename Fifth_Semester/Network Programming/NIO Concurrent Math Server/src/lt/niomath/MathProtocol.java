package lt.niomath;

public class MathProtocol {
    public static String processLine(String line) throws ProtocolException {
        line = line.trim();
        if (line.isEmpty()) {
            throw new ProtocolException("Empty command");
        }

        String[] parts = line.split("\\s+");
        if (parts.length != 3) {
            throw new ProtocolException("Expected 3 tokens");
        }

        double a, b;
        try {
            a = Double.parseDouble(parts[1]);
            b = Double.parseDouble(parts[2]);
        } catch (NumberFormatException e) {
            throw new ProtocolException("Invalid number format");
        }

        String op = parts[0].toUpperCase();
        double result;
        switch (op) {
            case "ADD":
                result = a + b;
                break;
            case "SUB":
                result = a - b;
                break;
            case "MUL":
                result = a * b;
                break;
            case "DIV":
                if (b == 0) {
                    throw new ProtocolException("Division by zero");
                }
                result = a / b;
                break;
            default:
                throw new ProtocolException("Unsupported operation: " + op);
        }

        return "OK " + result;
    }
}
