<?php
session_start();
if (!isset($_SESSION["username"]) || empty($_SESSION["username"])) {
    header("Location: login.php");
}
if (!isset($_GET["id"]) || empty($_GET["id"])) {
    header("Location: success.php?msgtype=warning&message=Invalid Password Id!");
}
$username = $_SESSION["username"];
$id = null;
if (isset($_GET["id"]) && !empty($_GET["id"])) {
    $id = $_GET["id"];
}
include '../classes/Database.php';
include '../classes/PasswordPlateforms.php';
// Initialize database connection
$db = new Database();
$conn = $db->getConnection();

// Create Password Plateforms object
$passwordPlateform = new PasswordPlatforms($conn);

$password = $passwordPlateform->deletePasswordRecord($id);
if (empty($password)) {
    header("Location: success.php?msgtype=error&message=Password not found!");
}

if($password){
    header("Location: success.php?msgtype=success&message=Password deleted successfully!");
}
?>
