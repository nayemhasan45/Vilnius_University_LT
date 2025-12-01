<?php
    session_start();
    echo "Welcome ".$_SESSION['user'];
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Display Users</title>
    <style>
        *{
            margin: 0px;
            padding: 0px;
        }
        .container {
            width: 80%;
            margin: 50px auto;
        }

        .heading {
            display: flex;
            justify-content: space-evenly;
        }

        .heading_text {
            background-color: orangered;
            padding: 10px 20px;
            color: white;
            font-weight: bold;
            border-radius: 10px;
        }
        .table{
            margin-top: 20px;
        }
        .btn,
        .btn_2 {
            background-color: green;
            color: white;
            border: none;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn_2 {
            background-color: orange;
        }
        .SignUp,.logOutBtn input{
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-size: 20px;
            background-color:tomato;
            border-radius: 5px;
            color: white;
            font-weight: bold;
        }
        .SignUp a{
            text-decoration: none;
            color: white;
            font-weight: bold;
        }
        .logOutBtn{
            text-align: center;
        }
        .logOutBtn input{
            background-color: red;
            
        }
    </style>
</head>

<body>

</body>

</html>
<?php
include("connect.php");
$userProfile=$_SESSION['user'];
if(!$userProfile){
header('location:log_in.php');
}
$getData = "SELECT * FROM userdata";
$data = mysqli_query($con, $getData);
$row = mysqli_num_rows($data);

if ($row != 0) {
?>
    <div class="container">
        <div class="heading">
            <h2 class="heading_text">Displaying All User</h2>
            <a href="http://localhost/assignment/lab_work_5/index.php"><button class="SignUp">Add New User</button></a>
        </div>
        <table class="table" border="2" cellspacing="7" width="100%">
            <tr>
                <th whidth="10%">Id</th>
                <th whidth="20%">Name</th>
                <th whidth="30%">Email</th>
                <th whidth="20%">Password</th>
                <th whidth="30%">Operations</th>
            </tr>

        <?php
            $serial_num=1;
        while ($result = mysqli_fetch_assoc($data)) {
            echo "
            <tr>
                <td align='center'>$serial_num</td>
                <td align='center'>$result[name]</td>
                <td align='center'>$result[email]</td>
                <td align='center'>$result[password]</td>
                <td align='center'><a href='update_data.php?id=$result[id]'><input type='submit'  class='btn btn-primary' value='Update'></a>

                <a href='delete_user.php?id=$result[id]'><input type='submit'  class='btn_2 btn-primary' value='Delete' onclick='return deleteUser()'></a>
                </td>
            </tr>
            ";
            $serial_num++;
        }
    } else {
        echo 'No user added yet....<br>';
        echo "Go back to Login form";
?>
        <a href="http://localhost/assignment/lab_work_5/"><button class="SignUp">Sign Up</button></a>
<?php
    }
        ?>
        </table>
    </div>
    <div class="logOutBtn">
        <a href="log_out.php"><input type="submit" value="Log Out"></a>
    </div>
    <script>
        function deleteUser() {
            return confirm('are you sure you want to delete this user');
        }
    </script>