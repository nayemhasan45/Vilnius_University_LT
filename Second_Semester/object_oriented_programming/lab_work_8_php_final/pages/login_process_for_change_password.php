<?php
include '../includes/header.php'; // Include header here to ensure Bootstrap is loaded
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
        // Login successful, redirect to change password page
        header("Location: change_password_form.php?username=$username");
        exit;
    } else {
        // Login failed, show the modal
        echo "<script>
                $(document).ready(function(){
                    $('#loginFailModal').modal('show');
                });
              </script>";
    }
}
?>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<!-- Modal -->
<div class="modal fade" id="loginFailModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Login Failed</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        User password is not matching. Please check your username and password.
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<?php include '../includes/footer.php'; ?>
