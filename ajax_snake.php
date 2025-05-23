<?php
session_start();
if (!isset($_SESSION['user']) || $_SESSION['user'] !== 'manager') {
    header("Location: login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AJAX Snake Manager</title>
    <link rel="stylesheet" href="style.css">
    <script src="ajax_snake.js" defer></script>
</head>
<body>
<a href="logout.php" style="color:white;position:absolute;top:20px;right:20px;">Log out</a>

    <header>
        Manage Snakes (AJAX)
    </header>

    <section id="search-section">
        <h2>Click to Update or Delete Snakes</h2>
        <table>
            <thead>
                <tr>
                    <th>Species ID</th>
                    <th>Binomial</th>
                    <th>Common Name</th>
                    <th>Family</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="snakeTable">
                <?php
                $conn = new mysqli("localhost", "root", "", "what_the_snake");
                if ($conn->connect_error) {
                    die("Connection failed: " . $conn->connect_error);
                }

                $sql = "SELECT species_id, binomial, common_name, family FROM species";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        $id = $row['species_id'];
                        echo "<tr id='row_$id'>
                            <td>$id</td>
                            <td><input type='text' id='binomial_$id' value='" . htmlspecialchars($row['binomial']) . "'></td>
                            <td><input type='text' id='common_$id' value='" . htmlspecialchars($row['common_name']) . "'></td>
                            <td><input type='text' id='family_$id' value='" . htmlspecialchars($row['family']) . "'></td>
                            <td>
                                <button onclick='updateSnake($id)'>Update</button>
                                <button onclick='deleteSnake($id)'>Delete</button>
                            </td>
                        </tr>";
                    }
                } else {
                    echo "<tr><td colspan='5'>No snakes found</td></tr>";
                }

                $conn->close();
                ?>
            </tbody>
        </table>
    </section>

    <a href="index.php">Back to Dashboard</a>

</body>
</html>
