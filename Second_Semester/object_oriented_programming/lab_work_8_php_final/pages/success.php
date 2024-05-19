<?php
session_start();
if (!isset($_SESSION["username"]) || empty($_SESSION["username"])) {
    header("Location: login.php");
}
$username = $_SESSION["username"];
include '../classes/Database.php';
include '../classes/PasswordPlateforms.php';
// Initialize database connection
$db = new Database();
$conn = $db->getConnection();

// Create Password Plateforms object
$passwordPlateform = new PasswordPlatforms($conn);
$passwords = $passwordPlateform->userPasswords($username);

?>
<?php include '../includes/header.php'; ?>
<!-- <link rel="stylesheet" href="../style/signup.css"> -->

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
    }
    .container {
        margin-top: 5%;
    }
    .card {
        border: none;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 20px;
    }
    .card-header {
        background-color: #343a40;
        color: white;
        font-size: 1.25rem;
        text-align: center;
        padding: 15px 0;
    }
    .card-body {
        padding: 30px;
        background-color: white;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-control {
        border-radius: 5px;
        border: 1px solid #ced4da;
        padding: 10px;
        font-size: 1rem;
    }
    .form-control:focus {
        border-color: #80bdff;
        box-shadow: 0 0 5px rgba(128, 189, 255, 0.5);
    }
    .btn {
        width: 100%;
        padding: 10px;
        font-size: 1rem;
        border-radius: 5px;
        transition: background-color 0.3s, border-color 0.3s;
        margin-bottom: 10px;
    }
    .btn-primary {
        background-color: #007bff;
        border: none;
    }
    .btn-primary:hover {
        background-color: #0056b3;
    }
    .btn-danger {
        background-color: #dc3545;
        border: none;
    }
    .btn-danger:hover {
        background-color: #c82333;
    }
    .btn-success {
        background-color: #28a745;
        border: none;
    }
    .btn-success:hover {
        background-color: #218838;
    }
    .btn-warning {
        background-color: #ffc107;
        border: none;
    }
    .btn-warning:hover {
        background-color: #e0a800;
    }
    .table {
        width: 100%;
        margin-bottom: 1rem;
        background-color: transparent;
    }
    .table th, .table td {
        padding: 0.75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }
    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }
    .table tbody + tbody {
        border-top: 2px solid #dee2e6;
    }
    .alert {
        margin-top: 20px;
    }
    .checkboxes ul {
        list-style: none;
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        padding: 0;
    }
    .checkboxes ul li {
        display: flex;
        align-items: center;
        gap: 5px;
    }
</style>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h2 class="mb-4">Hello, <?php echo htmlspecialchars($username); ?></h2>
            <div class="d-flex justify-content-between mb-4">
                <a class="btn btn-primary" href="change_password.php?username=<?php echo urlencode($username); ?>">Change Password</a>
                <a class="btn btn-danger" href="logout.php">Logout</a>
            </div>
            <?php if (isset($_GET["msgtype"]) && !empty($_GET["msgtype"]) && isset($_GET["message"]) && !empty($_GET["message"])) { ?>
                <div class="alert alert-<?php echo htmlspecialchars($_GET["msgtype"]); ?>">
                    <?php echo htmlspecialchars($_GET["message"]); ?>
                </div>
            <?php } ?>
            <div class="card">
                <div class="card-header">
                    Add New Password
                </div>
                <div class="card-body">
                    <form action="insertplateform.php" method="post">
                        <div class="form-group">
                            <label for="plateform">Account</label>
                            <input type="text" class="form-control" id="plateform" name="plateform" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="text" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="form-group">
                            <label for="passwordLength">Password Length (6-30)</label>
                            <input type="number" id="passwordLength" class="form-control" name="passwordLength" min="6" max="30" value="12">
                        </div>
                        <div class="form-group checkboxes">
                            <ul>
                                <li>
                                    <input type="checkbox" id="uppercase" checked>
                                    <label for="uppercase">Uppercase (A-Z)</label>
                                </li>
                                <li>
                                    <input type="checkbox" id="lowercase" checked>
                                    <label for="lowercase">Lowercase (a-z)</label>
                                </li>
                                <li>
                                    <input type="checkbox" id="numbers" checked>
                                    <label for="numbers">Numbers (0-9)</label>
                                </li>
                                <li>
                                    <input type="checkbox" id="specialChars" checked>
                                    <label for="specialChars">Special Characters</label>
                                </li>
                                <li>
                                    <a href="javascript:;" class="btn btn-secondary" id="generatePassword">Generate Password</a>
                                </li>
                            </ul>
                        </div>
                        <button type="submit" class="btn btn-success">Save</button>
                    </form>
                </div>
            </div>
            <div class="card mt-4">
                <div class="card-header">
                    Manage Passwords
                </div>
                <?php if (!empty($passwords)) { ?>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Account</th>
                                        <th>Password</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php 
                                    $k = 0;
                                    foreach ($passwords as $password) {
                                        $k++;
                                    ?>
                                        <tr>
                                            <td><?php echo $k; ?></td>
                                            <td><?php echo htmlspecialchars($password->platform_name); ?></td>
                                            <td><?php echo htmlspecialchars($password->password); ?></td>
                                            <td>
                                                <a href="editpassword.php?id=<?php echo urlencode($password->id); ?>" class="btn btn-warning mr-2">Edit</a>
                                                <a href="deletepassword.php?id=<?php echo urlencode($password->id); ?>" class="btn btn-danger">Delete</a>
                                            </td>
                                        </tr>
                                    <?php } ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <?php } ?>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("generatePassword").addEventListener("click", function() {
            var length = document.getElementById("passwordLength").value;
            var lowercase = document.getElementById("lowercase").checked;
            var uppercase = document.getElementById("uppercase").checked;
            var numbers = document.getElementById("numbers").checked;
            var specialChars = document.getElementById("specialChars").checked;

            var charset = "";
            if (lowercase) charset += "abcdefghijklmnopqrstuvwxyz";
            if (uppercase) charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if (numbers) charset += "0123456789";
            if (specialChars) charset += "!@#$%^&*()_+~`|}{[]\\:;?><,./-=";

            var password = "";
            for (var i = 0; i < length; i++) {
                password += charset.charAt(Math.floor(Math.random() * charset.length));
            }

            document.getElementById("password").value = password;
        });
    });
</script>

<?php include '../includes/footer.php'; ?>
