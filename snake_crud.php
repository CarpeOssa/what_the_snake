<?php
$conn = new mysqli("localhost", "root", "", "what_the_snake");
if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

$action = $_POST['action'] ?? '';

if ($action === 'add') {
    // Collect form values
    $binomial = $_POST['binomial'];
    $common = $_POST['common_name'];
    $family = $_POST['family'];
    $dry = $_POST['dryweight_mg'];
    $wet = $_POST['wetweight_mg'];
    $vol = $_POST['wetvolume_ml'];
    $region = $_POST['region'];
    $habitat = $_POST['habitat'];
    $description = $_POST['description'];

    // Handle image upload
    $image_path = null;
    if (isset($_FILES['snake_image']) && $_FILES['snake_image']['error'] === UPLOAD_ERR_OK) {
        $upload_dir = 'images/';
        $filename = basename($_FILES['snake_image']['name']);
        $target_path = $upload_dir . time() . '_' . $filename;

        if (move_uploaded_file($_FILES['snake_image']['tmp_name'], $target_path)) {
            $image_path = $target_path;
        }
    }

    // Insert into species table
    $stmt = $conn->prepare("INSERT INTO species (binomial, common_name, family) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $binomial, $common, $family);
    $stmt->execute();
    $species_id = $stmt->insert_id;

    // Insert into venom_yield table
    $stmt = $conn->prepare("INSERT INTO venom_yield (species_id, dryweight_mg, wetweight_mg, wetvolume_ml) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("iddd", $species_id, $dry, $wet, $vol);
    $stmt->execute();

    // Insert into distribution table
    $stmt = $conn->prepare("INSERT INTO distribution (species_id, region, habitat) VALUES (?, ?, ?)");
    $stmt->bind_param("iss", $species_id, $region, $habitat);
    $stmt->execute();

    // Insert into descriptions table
    $stmt = $conn->prepare("INSERT INTO descriptions (species_id, description) VALUES (?, ?)");
    $stmt->bind_param("is", $species_id, $description);
    $stmt->execute();

    // Insert into images table if image uploaded
    if ($image_path !== null) {
        $stmt = $conn->prepare("INSERT INTO images (species_id, image_url) VALUES (?, ?)");
        $stmt->bind_param("is", $species_id, $image_path);
        $stmt->execute();
    }

    echo "Snake added successfully!";
}

elseif ($action === 'update') {
    $id = $_POST['species_id'];
    $binomial = $_POST['binomial'];
    $common = $_POST['common_name'];
    $family = $_POST['family'];

    $stmt = $conn->prepare("UPDATE species SET binomial=?, common_name=?, family=? WHERE species_id=?");
    $stmt->bind_param("sssi", $binomial, $common, $family, $id);
    $stmt->execute();

    echo "Snake updated successfully!";
}

elseif ($action === 'delete') {
    $id = $_POST['species_id'];

    $stmt = $conn->prepare("DELETE FROM species WHERE species_id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    echo "Snake deleted successfully!";
}

$conn->close();
?>
