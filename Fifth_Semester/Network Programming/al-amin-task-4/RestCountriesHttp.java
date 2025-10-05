import java.net.URI;
import java.net.http.*;
import java.io.*;
import java.time.Duration;

public class RestCountriesHttp {
    public static void main(String[] args) throws IOException, InterruptedException {

        HttpClient hc = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();

        HttpRequest getRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://restcountries.com/v3.1/independent?status=true"))
                .GET()
                .build();

        HttpResponse<String> getResponse =
                hc.send(getRequest, HttpResponse.BodyHandlers.ofString());

        try (PrintWriter writer = new PrintWriter(new FileWriter("RestCountriesResponse.txt"))) {
            writer.println("=== GET REQUEST ===");
            writer.println("Status Code: " + getResponse.statusCode());
            writer.println("Response Body (first 600 characters):");
            String body = getResponse.body();
            int length = Math.min(body.length(), 600);
            writer.println(body.substring(0, length));
            writer.println();
            System.out.println("GET request done. Data saved to RestCountriesResponse.txt");
        }

        HttpRequest postRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://jsonplaceholder.typicode.com/posts"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(
                        "{\"title\": \"RestCountries POST Test\", " +
                        "\"body\": \"This is a POST request example\", " +
                        "\"userId\": 1}"
                ))
                .build();

        HttpResponse<String> postResponse =
                hc.send(postRequest, HttpResponse.BodyHandlers.ofString());

        try (PrintWriter writer = new PrintWriter(new FileWriter("RestCountriesResponse.txt", true))) {
            writer.println("=== POST REQUEST ===");
            writer.println("Status Code: " + postResponse.statusCode());
            writer.println("Response Body:");
            writer.println(postResponse.body());
            System.out.println("POST request done. Data appended to RestCountriesResponse.txt");
        }

        System.out.println("\n✅ Task 2 finished successfully. Check RestCountriesResponse.txt file.");
    }
}
