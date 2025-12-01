# GEMINI.md - NIO Concurrent Math Server

## Project Overview

This project is a **Java-based NIO Concurrent Math Server**. It's designed to handle mathematical operations from multiple clients simultaneously using a non-blocking I/O model. The server is implemented in Java and consists of two main components:

1.  **TCP NIO Math Server**: Listens on a TCP port (default: 5000) for incoming client connections. It uses Java's NIO (New I/O) library, including `ServerSocketChannel`, `SocketChannel`, and `Selector`, to manage multiple clients concurrently without blocking. It processes simple math commands like `ADD 10 20`.
2.  **UDP Status/Heartbeat Server**: Runs on a separate thread and listens on a UDP port (default: 6000). This server provides a lightweight way to check the status of the math server by responding to a `STATUS` query with information like the number of active clients and total requests handled.

The project employs a multithreaded architecture, with a main thread for the NIO selector, a worker thread pool (`ExecutorService`) for processing the math operations and logging, and a separate thread for the UDP status server.

## Building and Running

The project does not include a build tool like Maven or Gradle. You can compile and run the Java source files directly from the command line.

### Directory Structure

The project follows a standard Java package structure:

```
src/
  lt/
    niomath/
      NioMathServer.java
      ClientSession.java
      MathProtocol.java
      UdpStatusServer.java
      RequestLogger.java
      ProtocolException.java
      NioMathClient.java
```

### Compilation

To compile all the Java source files, you can use the `javac` compiler. From the root of the project directory, run:

```sh
# Create a 'bin' directory for the compiled classes
mkdir bin

# Compile the source files
javac -d bin src/lt/niomath/*.java
```

### Running the Server

To run the main math server, execute the `NioMathServer` class:

```sh
java -cp bin lt.niomath.NioMathServer
```

The server will start and listen on TCP port 5000 and UDP port 6000 by default.

### Running the Client

To connect to the server, you can run the `NioMathClient` and provide the host and port as arguments:

```sh
java -cp bin lt.niomath.NioMathClient localhost 5000
```

## Development Conventions

The project adheres to several development conventions outlined in the `PRD (4).md` document:

*   **Modular Design**: The code is separated into distinct classes with clear responsibilities, such as `NioMathServer` for the core server logic, `ClientSession` for managing client state, and `MathProtocol` for the application-level protocol.
*   **Package Structure**: All classes are part of the `lt.niomath` package.
*   **Exception Handling**: The project uses a custom checked exception, `ProtocolException`, to handle errors related to the math protocol (e.g., invalid commands, division by zero).
*   **Logging**: All requests and responses are logged to a file at `logs/requests.log` using Java NIO's `FileChannel`.
*   **Multithreading**: The server follows a specific multithreading model to ensure non-blocking I/O and efficient processing:
    *   A **Selector Thread** for handling NIO events (`accept`, `read`, `write`).
    *   A **Worker Thread Pool** to offload CPU-intensive tasks like math calculations and logging.
    *   A **UDP Thread** for the status server.
*   **Java Version**: The project is intended to be compatible with **Java 11+**.
