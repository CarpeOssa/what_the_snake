<?php
session_start();
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Replace with your real credentials
    if ($username === "ccommander" && $password === "hailcobra!") {
        $_SESSION['user'] = 'manager';
        header("Location: ajax_snake.php");
        exit;
    } else {
        $error = "Invalid credentials.";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login - What The Snake</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1 style="background-color: rgba(255,255,255,0.85); padding: 15px 30px; border-radius: 12px; display: inline-block; color: #841617;">
    Manager Login
	</h1>

    <form method="POST" style="margin: auto; width: 300px;">
        <label for="username">Username:</label>
        <input type="text" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" name="password" required><br><br>

        <button type="submit">Login</button>
    </form>
    <?php if (!empty($error)) echo "<p style='color:red;text-align:center;'>$error</p>"; ?>
	<div style="text-align: center; margin-top: 20px;">
    <a href="index.php" style="color: #841617; font-weight: bold; text-decoration: none; background-color: rgba(255,255,255,0.9); padding: 10px 20px; border-radius: 8px; box-shadow: 0 0 5px rgba(0,0,0,0.2); display: inline-block;">
        ⬅ Go Back
    </a>
</div>

</body>
</html>
