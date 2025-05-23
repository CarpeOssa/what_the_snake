<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Snakes</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .snake-card {
            background-color: rgba(53, 77, 32, 0.85);
            color: white;
            margin: 40px auto;
            padding: 30px;
            width: 80%;
            border-radius: 20px;
            box-shadow: 0 0 20px rgba(0,0,0,0.6);
            text-align: left;
        }

        .snake-card h2 {
            color: #c2b8bb;
            border-bottom: 2px solid #c2b8bb;
            margin-bottom: 15px;
        }

        .snake-info {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
        }

        .snake-text {
            flex: 2;
        }

        .snake-image {
            flex: 1;
        }

        .snake-image img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            border: 2px solid #c2b8bb;
        }

        .snake-description {
            margin-top: 15px;
            font-size: 1.05em;
            line-height: 1.6em;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>

<header>Snake Species Showcase</header>

<?php
$conn = new mysqli("localhost", "root", "", "what_the_snake");
if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

$sql = "
    SELECT s.species_id, s.binomial, s.common_name, s.family,
           v.dryweight_mg, v.wetweight_mg, v.wetvolume_ml,
           d.region, d.habitat,
           descs.description AS description,
           i.image_url
    FROM species s
    LEFT JOIN venom_yield v ON s.species_id = v.species_id
    LEFT JOIN distribution d ON s.species_id = d.species_id
    LEFT JOIN descriptions descs ON s.species_id = descs.species_id
    LEFT JOIN images i ON s.species_id = i.species_id
";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "<div class='snake-card'>
            <h2>{$row['common_name']} <span style='font-weight: normal;'>({$row['binomial']})</span></h2>
            <div class='snake-info'>
                <div class='snake-text'>
                    <p><strong>Family:</strong> {$row['family']}</p>
                    <p><strong>Venom Yield (Dry):</strong> {$row['dryweight_mg']} mg</p>
                    <p><strong>Venom Yield (Wet):</strong> {$row['wetweight_mg']} mg</p>
                    <p><strong>Venom Volume:</strong> {$row['wetvolume_ml']} ml</p>
                    <p><strong>Region:</strong> {$row['region']}</p>
                    <p><strong>Habitat:</strong> {$row['habitat']}</p>
                </div>";

        if (!empty($row['image_url'])) {
            echo "<div class='snake-image'>
                    <img src='{$row['image_url']}' alt='Image of {$row['common_name']}'>
                </div>";
        }

        echo "</div><div class='snake-description'>{$row['description']}</div></div>";
    }
} else {
    echo "<p style='color: white; margin: 60px auto; width: 80%;'>No snakes found.</p>";
}

$conn->close();
?>

<a href="index.php" style="color: #c2b8bb; display: block; margin: 40px auto; text-align: center;">⬅️ Back to Dashboard</a>

</body>
</html>
