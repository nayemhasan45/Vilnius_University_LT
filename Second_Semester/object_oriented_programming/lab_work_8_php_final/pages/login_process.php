<?php
session_start();
include '../classes/Database.php';
include '../classes/User.php';

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Initialize database connection
    $db = new Database();
    $conn = $db->getConnection();

    // Create user object
    $user = new User($conn);

    // Attempt to login user
    if ($user->login($username, $password)) {
        // Login successful, redirect to success page
        $_SESSION["username"] = $username;
        header("Location: success.php?username=$username");
        exit;
    } else {
        // Login failed, handle error (e.g., display error message)
        echo "Login failed. Please check your username and password. <a href='login.php'>Back to Login</a>";
    }
}
?>
