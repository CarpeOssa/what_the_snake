<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Snake Statistics</title>
    <link rel="stylesheet" href="style.css">
    <style>
        section {
            background-color: rgba(53, 77, 32, 0.85);
            padding: 30px;
            margin: 60px auto;
            width: 85%;
            border-radius: 20px;
            box-shadow: 0 0 15px rgba(0,0,0,0.6);
            color: white;
        }

        h2 {
            color: #c2b8bb;
            border-bottom: 2px solid #c2b8bb;
            padding-bottom: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background-color: white;
            color: black;
        }

        th, td {
            border: 1px solid #c2b8bb;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #841617;
            color: white;
        }

        a {
            color: #c2b8bb;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <header>Snake Statistics Dashboard</header>

    <section>
        <h2>Venom Yield (Dry Weight) – Previous & Next Species (Alphabetically)</h2>
        <?php
        $conn = new mysqli("localhost", "root", "", "what_the_snake");
        if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

        $sql = "
            SELECT s.species_id, s.binomial, v.dryweight_mg,
                LAG(v.dryweight_mg) OVER (ORDER BY s.binomial) AS previous_yield,
                LEAD(v.dryweight_mg) OVER (ORDER BY s.binomial) AS next_yield
            FROM species s
            JOIN venom_yield v ON s.species_id = v.species_id
        ";
        $result = $conn->query($sql);

        echo "<table><tr><th>ID</th><th>Binomial</th><th>Dry (mg)</th><th>Prev</th><th>Next</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>
                <td>{$row['species_id']}</td>
                <td>{$row['binomial']}</td>
                <td>{$row['dryweight_mg']}</td>
                <td>{$row['previous_yield']}</td>
                <td>{$row['next_yield']}</td>
            </tr>";
        }
        echo "</table>";
        ?>
    </section>

    <section>
        <h2>Running Total of Venom Yield (mg) by Family</h2>
        <?php
        $sql = "
            SELECT s.family, s.binomial, v.dryweight_mg,
                SUM(v.dryweight_mg) OVER (PARTITION BY s.family ORDER BY s.binomial) AS running_total
            FROM species s
            JOIN venom_yield v ON s.species_id = v.species_id
        ";
        $result = $conn->query($sql);

        echo "<table><tr><th>Family</th><th>Species</th><th>Dry (mg)</th><th>Running Total</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>
                <td>{$row['family']}</td>
                <td>{$row['binomial']}</td>
                <td>{$row['dryweight_mg']}</td>
                <td>{$row['running_total']}</td>
            </tr>";
        }
        echo "</table>";
        ?>
    </section>

    <section>
        <h2>Above-Average Venom Producers</h2>
        <?php
        $sql = "
            SELECT s.binomial, v.dryweight_mg,
                AVG(v.dryweight_mg) OVER () AS avg_yield
            FROM species s
            JOIN venom_yield v ON s.species_id = v.species_id
            WHERE v.dryweight_mg > (
                SELECT AVG(dryweight_mg) FROM venom_yield
            )
        ";
        $result = $conn->query($sql);

        echo "<table><tr><th>Binomial</th><th>Dry (mg)</th><th>Avg Yield</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>
                <td>{$row['binomial']}</td>
                <td>{$row['dryweight_mg']}</td>
                <td>{$row['avg_yield']}</td>
            </tr>";
        }
        echo "</table>";
        ?>
    </section>

    <a href="index.php">Back to Dashboard</a>

</body>
</html>
