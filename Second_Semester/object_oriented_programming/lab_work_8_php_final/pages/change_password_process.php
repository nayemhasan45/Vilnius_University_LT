<?php
include '../classes/Database.php';
include '../classes/User.php';

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $username = $_POST['username'];
    $currentPassword = $_POST['currentPassword'];
    $newPassword = $_POST['newPassword'];

    // Initialize database connection
    $db = new Database();
    $conn = $db->getConnection();

    // Create user object
    $user = new User($conn);

    // Attempt to change password
    if ($user->changePassword($username, $currentPassword, $newPassword)) {
        // Password change successful, redirect to success page
        header("Location: success.php");
        exit;
    } else {
        // Password change failed, handle error (e.g., display error message)
        echo "Password change failed. Please check your current password.";
    }
}
?>
