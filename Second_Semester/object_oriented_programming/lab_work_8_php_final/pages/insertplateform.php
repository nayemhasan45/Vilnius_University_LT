<?php
session_start();
if (!isset($_SESSION["username"]) || empty($_SESSION["username"])) {
    header("Location: login.php");
}
$username = $_SESSION["username"];
include '../classes/Database.php';
include '../classes/PasswordPlateforms.php';

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $plateform = $_POST['plateform'];
    $password = $_POST['password'];

    // Initialize database connection
    $db = new Database();
    $conn = $db->getConnection();

    // Create Password Plateforms object
    $passwordPlateform = new PasswordPlatforms($conn);

    // Attempt to store password
    if ($passwordPlateform->savePasswordRecord($username, $plateform,$password)) {
        // Password Stored Successfully, redirect to success page
        header("Location: success.php?msgtype=success&message=Password Stored Successfully");
        exit;
    } else {
        // Password stored failed redirect with error
        header("Location: success.php?msgtype=error&message=Oops Something went wrong");
    }
}
?>
