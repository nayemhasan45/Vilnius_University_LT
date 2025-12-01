<?php
include('connect.php');
session_start();
$userProfile = $_SESSION['user'];
if (!$userProfile) {
    header('location:log_in.php');
}
$id = $_GET['id'];
$getData = "DELETE FROM  userdata  WHERE id='$id'";
$result = mysqli_query($con, $getData);
if ($result) {
    echo "<script>alert('User Deleted')</script>";
?>
    <meta http-equiv="refresh" content="0; url=http://localhost/assignment/lab_work_5/display.php" />
<?php
} else {
    echo "<script>alert('Failed To Delete')</script>";
}
?>