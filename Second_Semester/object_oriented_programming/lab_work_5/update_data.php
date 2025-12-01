<?php include('connect.php');
session_start();
$userProfile = $_SESSION['user'];
if (!$userProfile) {
    header('location:log_in.php');
}
$id = $_GET['id'];
$getData = "SELECT * FROM userdata WHERE id=$id";
$data = mysqli_query($con, $getData);
$row = mysqli_num_rows($data);
$result = mysqli_fetch_assoc($data);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User data login</title>
    <!-- daisy ui for design -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.10.2/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body>
    <div class="w-1/2 mx-auto space-y-5">
        <div class="text-center text-4xl">
            <h1 class="">Update your data</h1>
        </div>
        <form action="" method="POST">
            <div class="space-y-6">
                <label class="input input-bordered flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM12.735 14c.618 0 1.093-.561.872-1.139a6.002 6.002 0 0 0-11.215 0c-.22.578.254 1.139.872 1.139h9.47Z" />
                    </svg>
                    <input type="text" class="grow" value="<?php echo $result['name']; ?>" placeholder="Username" name="name" required />
                </label>
                <label class="input input-bordered flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                        <path d="M2.5 3A1.5 1.5 0 0 0 1 4.5v.793c.026.009.051.02.076.032L7.674 8.51c.206.1.446.1.652 0l6.598-3.185A.755.755 0 0 1 15 5.293V4.5A1.5 1.5 0 0 0 13.5 3h-11Z" />
                        <path d="M15 6.954 8.978 9.86a2.25 2.25 0 0 1-1.956 0L1 6.954V11.5A1.5 1.5 0 0 0 2.5 13h11a1.5 1.5 0 0 0 1.5-1.5V6.954Z" />
                    </svg>
                    <input type="text" class="grow" value="<?php echo $result['email']; ?>" placeholder="Email" name="email" required />
                </label>
                <label class="input input-bordered flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                        <path fill-rule="evenodd" d="M14 6a4 4 0 0 1-4.899 3.899l-1.955 1.955a.5.5 0 0 1-.353.146H5v1.5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-2.293a.5.5 0 0 1 .146-.353l3.955-3.955A4 4 0 1 1 14 6Zm-4-2a.75.75 0 0 0 0 1.5.5.5 0 0 1 .5.5.75.75 0 0 0 1.5 0 2 2 0 0 0-2-2Z" clip-rule="evenodd" />
                    </svg>
                    <input type="password" value="<?php echo $result['password']; ?>" class="grow" name="password" required />
                </label>
                <input type="submit" value="Update" class="btn btn-primary w-full" name="register">
            </div>
        </form>

    </div>
</body>

</html>
<?php
error_reporting(0);
if ($_POST['register']) {
    $userName = $_POST['name'];
    $userEmail = $_POST['email'];
    $userPass = $_POST['password'];

    $data = "UPDATE userdata SET name='$userName',email='$userEmail',password='$userPass' WHERE id='$id'";
    $storeData = mysqli_query($con, $data);
    if ($storeData) {
        echo "<script>alert('Details Updated Successfully')</script>";
?>
        <meta http-equiv="refresh" content="0; url=http://localhost/assignment/lab_work_5/display.php" />
<?php
    } else {
        echo "Error";
    }
}
?>