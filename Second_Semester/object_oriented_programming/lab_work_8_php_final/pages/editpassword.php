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

$password = $passwordPlateform->verifyPasswordwithUsername($id, $username);
if (empty($password)) {
    header("Location: success.php?msgtype=error&message=Password not found!");
}

?>
<?php include '../includes/header.php'; ?>

<style>
    .mt-10 {
        margin-top: 10px;
    }

    .mr-10 {
        margin-right: 10px;
    }

    .checkboxes>ul {
        list-style: none;
        /* float: left; */
        display: flex;
    }
</style>


<div class="container mt-5">
    <div class="row justify-content-center">

        <div class="col-md-6">
            <h2>Hello,<?php echo $username; ?></h2>

            <a class="btn btn-primary" href="change_password.php?username=<?php echo $username; ?>">Change Password</a>

            <a class="btn btn-danger" href="logout.php">Logout</a>
            <?php if (isset($_GET["msgtype"]) && !empty($_GET["msgtype"]) && isset($_GET["message"]) && !empty($_GET["message"])) { ?>
                <div class="mt-10 alert alert-<?php echo $_GET["msgtype"]; ?>">
                    <?php echo $_GET["message"]; ?>
                </div>
            <?php } ?>
            <div class="card">

                <div class="card-header">
                    Update Account Password
                </div>
                <div class="card-body">
                    <!-- Signup form -->
                    <form action="updatepassword.php" method="post">
                        <div class="form-group">
                            <label for="username">Account</label>
                            <input type="text" class="form-control" value="<?php echo $password->platform_name; ?>" id="plateform" name="plateform" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password:</label>
                            <input type="text" class="form-control" id="password" value="<?php echo $password->password; ?>" name="password" required>
                            <input type="hidden" name="passwordid" value="<?php echo $password->id;?>" >
                        </div>
                        

                        <div class="form-group">
                            <label for="passwordLength">Password Length (6-30):</label>
                            <input type="number" id="passwordLength" class="form-control" min="6" max="30" value="12">
                        </div>
                        <div class="form-group checkboxes">
                            <ul>
                                <li><input type="checkbox" id="uppercase" checked>
                                    <label for="uppercase">Uppercase (A-Z)</label>
                                </li>
                                <li><input type="checkbox" id="lowercase" checked>
                                    <label for="lowercase">Lowercase (a-z)</label>
                                </li>
                                <li><input type="checkbox" id="numbers" checked>
                                    <label for="numbers">Numbers (0-9)</label>
                                </li>
                                <li><input type="checkbox" id="specialChars" checked>
                                    <label for="specialChars">Special Characters</label>
                                </li>
                                <li><a href="javascript:;" class="label label-primary" id="generatePassword">Generate Password</a>
                                </li>
                            </ul>

                        </div>

                        <button type="submit" class="btn btn-success">Save</button>
                    </form>
                </div>
            </div>

        </div>
    </div>
    <script>
        $(document).ready(function() {
            $('#generatePassword').click(function() {
                var length = $('#passwordLength').val();
                var lowercase = $('#lowercase').is(':checked');
                var uppercase = $('#uppercase').is(':checked');
                var numbers = $('#numbers').is(':checked');
                var specialChars = $('#specialChars').is(':checked');

                var charset = "";
                if (lowercase) charset += "abcdefghijklmnopqrstuvwxyz";
                if (uppercase) charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                if (numbers) charset += "0123456789";
                if (specialChars) charset += "!@#$%^&*()_+~`|}{[]\:;?><,./-=";

                var password = "";
                for (var i = 0; i < length; i++) {
                    password += charset.charAt(Math.floor(Math.random() * charset.length));
                }

                $('#password').val(password);
            });
        });
    </script>
    <?php include '../includes/footer.php'; ?>