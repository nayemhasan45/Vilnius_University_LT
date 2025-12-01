# PRD – NIO Concurrent Math Server with UDP Status Service
### Version 1.0  
### Author: Al-Amin Hossain Nayem  
### Course: Network Programming  

---

# 1. Introduction

This document defines the **Product Requirements Specification (PRD)** for a combined:

1. **TCP NIO Concurrent Math Server**  
2. **UDP Status/Heartbeat Server**

This project is designed to demonstrate all major concepts taught in the course, including:

- Exceptions and error-handling (Lecture 3)  
- Basic Java networking: `InetAddress`, URI, URL (Lecture 4)  
- HTTP & URLConnection (Lecture 5 – concepts referenced, optional minor usage)  
- TCP sockets: `ServerSocket`, `Socket`, stream I/O (Lecture 6)  
- UDP sockets: `DatagramSocket`, `DatagramPacket` (Lecture 7)  
- Multithreading & ExecutorService (Lecture 8)  
- Concurrent servers (Lecture 9)  
- Java NIO: Buffers, Channels, Selectors, FileChannel (Lecture 10)  

The system uses **TCP** for the main computation service and **UDP** for lightweight server status queries, all running inside the **same Java application** as separate threads.

---

# 2. Project Goals

1. Build a **fully concurrent network server** using non-blocking Java NIO.  
2. Accept and process math operations from multiple clients concurrently.  
3. Provide a **UDP endpoint** clients can query for real-time status of the math server.  
4. Demonstrate correct usage of:  
   - TCP stream sockets  
   - UDP datagram sockets  
   - NIO channels and selectors  
   - Buffers (`ByteBuffer`, `flip()`, `clear()`, `wrap()`)  
   - Multithreading + ExecutorService  
   - Exception handling  
   - File logging with FileChannel  
5. Deliver a clear, structured text protocol suitable for academic evaluation.  
6. Ensure the system is robust, stable, and easy to test and demonstrate.

---

# 3. System Overview

The system consists of three main runtime components:

## 3.1 TCP NIO Math Server (Main Feature)

- Listens on a TCP port (default: **5000**).  
- Accepts concurrent clients using:
  - `ServerSocketChannel` (non-blocking)
  - `Selector`
  - `SocketChannel`
  - `ByteBuffer`
- Implements a **line-based text protocol** for math operations.

Clients send commands like:

```text
ADD 10 20
SUB 5 2
MUL 3.5 4
DIV 10 2
```

The server parses the line, computes the result, and responds with:

```text
OK <result>
```

In case of errors, it responds with:

```text
ERROR <reason>
```

---

## 3.2 UDP Status/Heartbeat Server

- Listens on a UDP port (default: **6000**) using:
  - `DatagramSocket`
  - `DatagramPacket`
- Supports a simple request:

```text
STATUS
```

- Responds with a single-line status message:

```text
MATH_SERVER_RUNNING TCP_PORT=5000 ACTIVE_CLIENTS=<n> TOTAL_REQUESTS=<m>
```

This demonstrates basic UDP request/response exactly as taught in the UDP lecture (send/receive datagrams).

---

## 3.3 Worker Thread Pool (Multithreading)

- Uses:

```java
ExecutorService executor = Executors.newCachedThreadPool();
```

- Offloads:
  - Math command processing
  - Logging
  - Possible future background tasks

The TCP selector thread focuses on **non-blocking I/O** only (accept, read, write), while the heavy work is done in worker threads. This design demonstrates lecture concepts on multithreading and concurrent servers.

---

# 4. Functional Requirements

## 4.1 FR-1: TCP Math Service

1. The server must listen on a configurable TCP port (default **5000**).  
2. The server must accept multiple clients concurrently using a single selector loop.  
3. Each new connection results in:
   - A non-blocking `SocketChannel`
   - A `SelectionKey` registered with `OP_READ`
   - A `ClientSession` object attached to the key  
4. The server must **not block** on individual clients.  
5. The server must handle partial TCP reads (commands may arrive split across multiple packets).  
6. Every full line must be processed into either a **successful result** or an **error response**.

---

## 4.2 FR-2: TCP Math Protocol

### 4.2.1 Request Format (Client → Server)

A single command line:

```text
<OP> <A> <B>

```

Where:

- `OP` ∈ {`ADD`, `SUB`, `MUL`, `DIV`}  
- `A`, `B` are floating point numbers (double)  

Example requests:

```text
ADD 10 20
SUB 15 5
MUL 3.5 4
DIV 10 2
```

The newline character `
` defines the end of the command.

---

### 4.2.2 Response Format (Server → Client)

- **Success:**

```text
OK <result>

```

For example:

```text
OK 30.0
OK 10.5
```

- **Error:**

```text
ERROR <reason>

```

Examples:

```text
ERROR Empty command
ERROR Expected 3 tokens
ERROR Invalid number format
ERROR Division by zero
ERROR Unsupported operation: POW
```

---

## 4.3 FR-3: UDP Status Server

- UDP server listens on port **6000** by default.  
- The client sends the ASCII text:

```text
STATUS
```

- The server responds with:

```text
MATH_SERVER_RUNNING TCP_PORT=5000 ACTIVE_CLIENTS=<n> TOTAL_REQUESTS=<m>
```

Where:

- `<n>` = number of active TCP clients currently connected  
- `<m>` = total number of processed TCP requests since server startup  

The UDP server:

- Uses `DatagramSocket` and `DatagramPacket`.  
- Must be implemented using standard blocking `receive()` as taught.  
- Runs in a **separate thread** inside the same JVM as the TCP server.

---

## 4.4 FR-4: Exception Handling

The project must demonstrate proper Java exception handling:

1. Wrap all I/O operations in try/catch blocks.  
2. Use a custom checked exception class `ProtocolException` for protocol-level errors:
   - Wrong number of tokens
   - Unsupported operations
   - Invalid numbers
   - Division by zero  
3. When `MathProtocol` throws `ProtocolException`, the server converts it into an `ERROR <message>` response.  
4. Unexpected internal exceptions must not crash the server; they must be caught, logged, and handled gracefully.

---

## 4.5 FR-5: Logging (NIO FileChannel)

- All processed commands must be logged.  
- Log file path (default):

```text
logs/requests.log
```

- For each request, log a single line with:

```text
[timestamp] REQ=<command> RESP=<response> CLIENT=<ip:port>
```

- Logging must use:
  - `FileChannel`
  - `ByteBuffer`
  - `StandardOpenOption.WRITE`, `StandardOpenOption.APPEND`, `StandardOpenOption.CREATE`

The logging code must demonstrate:

- Opening a FileChannel  
- Wrapping strings into ByteBuffer  
- Writing while `buffer.hasRemaining()`  

---

## 4.6 FR-6: Multithreading

The system must use multiple threads:

1. **Selector Thread (TCP server loop)**  
   - Runs the NIO event loop (accept, read, write).
2. **Worker Pool Threads** (ExecutorService)  
   - Execute math computations and logging jobs.
3. **UDP Status Thread**  
   - Blocks on `DatagramSocket.receive()` and replies to STATUS queries.

This satisfies the requirements for multithreading and concurrent servers from Lectures 8 and 9.

---

# 5. Non-Functional Requirements

## 5.1 NFR-1: Performance

- The TCP server must handle at least **20 simultaneous clients** on standard hardware.  
- The selector loop must avoid blocking on any single client.  
- All heavy work offloaded to worker pool threads.

## 5.2 NFR-2: Stability

- The server must not terminate due to malformed input or unexpected network errors.  
- If a client misbehaves or disconnects unexpectedly, only that client’s channel should be closed, not the entire server.

## 5.3 NFR-3: Maintainability

- Code must be modular and separated into logically cohesive classes:
  - `NioMathServer`
  - `ClientSession`
  - `MathProtocol`
  - `UdpStatusServer`
  - `RequestLogger`
  - `ProtocolException`
  - `NioMathClient`
- Methods must be short, single-responsibility, and clearly named.

## 5.4 NFR-4: Compatibility

- Must compile and run on **Java 11+**.  
- Must run on both Windows and Linux environments.

---

# 6. System Architecture

## 6.1 Package and Directory Structure

Recommended structure:

```text
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

logs/
  requests.log   (created at runtime)

PRD.md
```

Package declaration for all classes:

```java
package lt.niomath;
```

---

## 6.2 NioMathServer (TCP NIO Server)

**Responsibilities:**

- Initialize:
  - `Selector`
  - `ServerSocketChannel`
  - ExecutorService worker pool  
- Bind server socket to TCP port (default 5000) using `InetSocketAddress`.  
- Configure server channel as non-blocking and register it with the Selector for `OP_ACCEPT`.  
- In the main loop:
  - Call `selector.select()` to wait for events.
  - For each ready `SelectionKey`:
    - `isAcceptable()` → accept a new client.
    - `isReadable()` → read data into a shared ByteBuffer, decode, and append to the client’s `ClientSession` buffer.
    - `isWritable()` → flush queued responses from `ClientSession` to the socket.

**Key methods:**

- `start()` – sets up and runs the selector loop.  
- `handleAccept(SelectionKey key)` – handles new incoming TCP connections.  
- `handleRead(SelectionKey key)` – reads incoming data, detects full lines.  
- `handleWrite(SelectionKey key)` – sends pending responses.  
- `closeKey(SelectionKey key)` – closes channel and cancels key safely.

**NIO Buffer usage:**

```java
ByteBuffer readBuffer = ByteBuffer.allocate(1024);

int bytesRead = channel.read(readBuffer);
if (bytesRead == -1) {
    // client closed
    closeKey(key);
    return;
}

readBuffer.flip(); // prepare for reading
String chunk = UTF8.decode(readBuffer).toString();
readBuffer.clear(); // ready for next read
```

- Incoming bytes are decoded as UTF-8 strings and appended to the client’s `inputBuffer`.

---

## 6.3 ClientSession (Per-Client State)

Each connected client has its own `ClientSession`, attached to the SelectionKey.

Fields:

- `StringBuilder inputBuffer` – for accumulating partial request data.  
- `Queue<ByteBuffer> pendingWrites` – for storing outgoing responses.  
- `String clientId` – e.g., remote IP and port as string.

Responsibilities:

1. **Accumulate Input**  
   - Appends incoming chunks to `inputBuffer`.
2. **Extract Complete Lines**  
   - Searches for newline characters (`
` or ``).
   - For each complete line, returns it for processing and removes it from buffer.
3. **Queue Responses**  
   - Converts response strings to ByteBuffers with `ByteBuffer.wrap()` and enqueues them in `pendingWrites`.

This design handles the fact that TCP does **not** preserve message boundaries; a single write on client side may correspond to multiple reads or vice versa.

---

## 6.4 MathProtocol (Protocol Logic)

`MathProtocol` is a stateless utility class with one main method:

```java
public static String processLine(String line) throws ProtocolException
```

Algorithm:

1. Trim whitespace.  
2. If the line is empty → throw `ProtocolException("Empty command")`.  
3. Split by whitespace: `String[] parts = line.split("\s+");`.  
4. If `parts.length != 3` → `ProtocolException("Expected 3 tokens")`.  
5. Parse `parts[1]` and `parts[2]` to `double` using `Double.parseDouble`.  
   - On `NumberFormatException` → `ProtocolException("Invalid number format")`.  
6. Convert `parts[0]` to upper case and switch:
   - `ADD` → a + b  
   - `SUB` → a - b  
   - `MUL` → a * b  
   - `DIV` → if `b == 0`, throw `ProtocolException("Division by zero")`, else a / b  
   - default → `ProtocolException("Unsupported operation: " + op)`  
7. Return `"OK " + result`.

In `NioMathServer`, when a full command is available:

```java
try {
    String response = MathProtocol.processLine(command);
    // send response OK ...
} catch (ProtocolException e) {
    // send ERROR ...
}
```

---

## 6.5 ProtocolException (Custom Exception)

A custom checked exception used for protocol-level errors:

```java
public class ProtocolException extends Exception {
    public ProtocolException(String message) {
        super(message);
    }
}
```

This demonstrates custom exception definition and usage from the Exceptions lecture.

---

## 6.6 RequestLogger (NIO File Logging)

`RequestLogger` logs all processed requests and responses using NIO:

Responsibilities:

- Manage log file path (`logs/requests.log`).  
- Provide a method:

```java
public synchronized void log(String entry)
```

Implementation outline:

1. Format entry:

```text
[timestamp] REQ=<command> RESP=<response> CLIENT=<ip:port>
```

2. Convert string to bytes using UTF-8.  
3. Wrap bytes into `ByteBuffer`.  
4. Open `FileChannel` with `StandardOpenOption.WRITE`, `CREATE`, `APPEND`.  
5. Write while `buffer.hasRemaining()`.

`log()` should be `synchronized` to prevent interleaving log messages when called from multiple threads.

---

## 6.7 UdpStatusServer (UDP Status Service)

This component demonstrates standard UDP programming:

- Uses `DatagramSocket` bound to a specific port (default 6000).  
- Uses a loop:
  - Create a `DatagramPacket` with a byte buffer.  
  - Call `receive()` to block for incoming datagrams.  
  - Convert data to string, trim it.  
  - If the request is `"STATUS"` (case-insensitive):
    - Build a response string like:
      ```text
      MATH_SERVER_RUNNING TCP_PORT=5000 ACTIVE_CLIENTS=<n> TOTAL_REQUESTS=<m>
      ```
    - Convert to bytes, build a new `DatagramPacket` with the client’s address and port.  
    - Call `send()`.

`UdpStatusServer` must run as a separate thread started from main:

```java
Thread udpThread = new Thread(new UdpStatusServer(statusPort, sharedStats));
udpThread.setDaemon(true); // optionally daemon
udpThread.start();
```

`sharedStats` is an object holding counters for active clients and total requests (use `AtomicInteger`).

---

## 6.8 Multithreading and ExecutorService

The project uses multithreading in three ways:

1. **Selector Thread** – main TCP event loop  
2. **UDP Status Thread** – blocking UDP server  
3. **Worker Pool** – executes tasks (math operations, logging)

Initialization example:

```java
ExecutorService workerPool = Executors.newCachedThreadPool();
```

On each full command:

- Create a `Runnable` that:
  - Calls `MathProtocol.processLine()`
  - Logs the request and response
  - Enqueues the response to the client’s `pendingWrites`
  - Modifies selector interest ops to include `OP_WRITE`

Submit it to the worker pool:

```java
workerPool.execute(task);
```

This design demonstrates:

- Runnable  
- ExecutorService  
- newCachedThreadPool()  
- Thread cooperation in a concurrent server environment  

---

## 6.9 NioMathClient (TCP Client)

The client is a simple command-line program that:

1. Accepts host and port as program arguments.  
2. Connects to the math server using a blocking `Socket` or `SocketChannel`.  
3. Reads user input from the console line-by-line.  
4. Sends each line with a newline.  
5. Reads server response line-by-line and prints it.  
6. Terminates when the user types `QUIT`.

The client demonstrates basic TCP client usage as taught in the TCP lecture.

---

# 7. ByteBuffer Usage Rules

The implementation must correctly follow these rules from the NIO lectures:

1. **Allocate**: `ByteBuffer.allocate(1024)` for read buffers.  
2. **flip()**: Call before reading from the buffer after a write operation (e.g. after `read()`).  
3. **clear()**: Call before writing new data into the buffer again.  
4. **wrap()**: Use `ByteBuffer.wrap(byte[])` to create buffers for outgoing responses.  

Example pattern:

```java
readBuffer.clear();
int bytesRead = channel.read(readBuffer);
if (bytesRead > 0) {
    readBuffer.flip();
    String chunk = UTF8.decode(readBuffer).toString();
    // process chunk...
}
```

---

# 8. Concurrency Model

## 8.1 Threads

- **Main Thread**: starts all components (TCP server & UDP status server).  
- **Selector Thread**: runs the NIO event loop.  
- **UDP Thread**: runs UdpStatusServer.  
- **Worker Threads**: spawned by ExecutorService for processing requests and logging.

## 8.2 Shared Data

- `ClientSession` per client – only touched by selector thread and affected worker tasks with proper coordination.  
- Statistics object (e.g., `AtomicInteger activeClients`, `AtomicLong totalRequests`) shared between TCP server and UDP status thread.  

## 8.3 Thread-Safety

- Use `AtomicInteger`/`AtomicLong` for counters.  
- Synchronize only where necessary (e.g., `RequestLogger.log`).  
- Ensure no blocking operations (file I/O, math computation) are executed in the selector thread.

---

# 9. Protocol Summary

## 9.1 TCP Protocol

**Request:**

```text
<OP> <A> <B>\n
```

**Success Response:**

```text
OK <result>\n
```

**Error Response:**

```text
ERROR <message>\n
```

## 9.2 UDP Protocol

**Request:**

```text
STATUS
```

**Response:**

```text
MATH_SERVER_RUNNING TCP_PORT=5000 ACTIVE_CLIENTS=<n> TOTAL_REQUESTS=<m>
```

---

# 10. Testing Plan

## 10.1 Test 1 – Basic Math

1. Start the server.  
2. Start one client and connect to `localhost:5000`.  
3. Send:
   ```text
   ADD 10 20
   SUB 10 3
   MUL 2 2.5
   DIV 9 3
   ```
4. Verify correct `OK` responses and numeric results.

## 10.2 Test 2 – Error Inputs

Test invalid commands:

```text
ADD 10
MUL x y
DIV 10 0
HELLO 1 2
```

Expected responses:

- `ERROR Expected 3 tokens`  
- `ERROR Invalid number format`  
- `ERROR Division by zero`  
- `ERROR Unsupported operation: HELLO`  

## 10.3 Test 3 – Multi-Client Concurrency

1. Start server.  
2. Open 3–5 clients simultaneously.  
3. Send many mixed valid and invalid commands.  
4. Verify:
   - No server crash
   - Each client receives correct responses
   - No blocking or freezing

## 10.4 Test 4 – UDP Status

1. Start the math server (which also starts UdpStatusServer).  
2. Use a small UDP test client or separate script:
   - Send `"STATUS"` to UDP port 6000.  
3. Verify response:
   ```text
   MATH_SERVER_RUNNING TCP_PORT=5000 ACTIVE_CLIENTS=<n> TOTAL_REQUESTS=<m>
   ```
4. Connect some TCP clients, send commands, repeat STATUS query and verify counters change correctly.

## 10.5 Test 5 – Logging

1. Run some test commands as in Test 1 and Test 2.  
2. Open `logs/requests.log`.  
3. Verify log entries have:
   - Timestamp  
   - Request command  
   - Response  
   - Client IP and port  

---

# 11. Acceptance Criteria

The project is **accepted** as complete when:

1. TCP NIO math server is fully functional with multiple clients.  
2. UDP status server responds correctly to STATUS requests.  
3. Math protocol operates exactly as specified.  
4. All expected error conditions produce correct `ERROR` responses.  
5. Exceptions are used correctly (custom `ProtocolException` and standard I/O exceptions).  
6. Logging via FileChannel is implemented and logs all requests/responses.  
7. Multithreading design (selector + worker pool + UDP thread) is clearly visible in the code.  
8. The implementation compiles and runs under Java 11+ without modification.  
9. Screenshots and report can be produced from the running system to show all features.

---

# 12. File Structure Summary

```text
src/lt/niomath/
  NioMathServer.java
  ClientSession.java
  MathProtocol.java
  UdpStatusServer.java
  RequestLogger.java
  ProtocolException.java
  NioMathClient.java

logs/
  requests.log

PRD.md
```

This PRD.md describes the final design and requirements for the **NIO Concurrent Math Server with UDP Status Service** and is intended to be followed closely during implementation and reporting.
