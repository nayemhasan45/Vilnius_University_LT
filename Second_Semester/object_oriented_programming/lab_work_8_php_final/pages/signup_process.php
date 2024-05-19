<?php
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

    // Attempt to signup user
    if ($user->signup($username, $password)) {
        // Signup successful, redirect to success page
        header("Location: success.php?username=$username");
        exit;
    } else {
        // Signup failed, handle error (e.g., display error message)
        echo "Signup failed. Please try again.";
    }
}
?>
