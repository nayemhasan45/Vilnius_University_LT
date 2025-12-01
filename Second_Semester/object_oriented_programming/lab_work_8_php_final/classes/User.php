<?php
class User {
    private $conn;
    private $table_name = 'users';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function signup($username, $password) {
        // Hash the password
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        
        // Insert user into database
        $query = "INSERT INTO " . $this->table_name . " (username, password) VALUES (:username, :password)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $hashed_password);
        
        if($stmt->execute()) {
            return true;
        }
        
        return false;
    }

    public function login($username, $password) {
        // Retrieve user from database
        $query = "SELECT * FROM " . $this->table_name . " WHERE username = :username";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if($user) {
            // Verify password
            if(password_verify($password, $user['password'])) {
                return true;
            }
        }
        
        return false;
    }

    public function changePassword($username, $newPassword) {
        // Hash the new password
        $hashed_password = password_hash($newPassword, PASSWORD_DEFAULT);
        
        // Update user's password
        $query = "UPDATE " . $this->table_name . " SET password = :password WHERE username = :username";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':password', $hashed_password);
        $stmt->bindParam(':username', $username);
        //var_dump($stmt);exit;
        if($stmt->execute()) {
            return true;
        }
        
        return false;
    }
}
?>
