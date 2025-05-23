function updateSnake(speciesId) {
    const binomial = document.getElementById("binomial_" + speciesId).value;
    const common = document.getElementById("common_" + speciesId).value;
    const family = document.getElementById("family_" + speciesId).value;

    fetch("snake_crud.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `action=update&species_id=${speciesId}&binomial=${encodeURIComponent(binomial)}&common_name=${encodeURIComponent(common)}&family=${encodeURIComponent(family)}`
    })
    .then(response => response.text())
    .then(data => {
        alert(data);
    })
    .catch(error => {
        console.error("Update error:", error);
        alert("An error occurred while updating the snake.");
    });
}

function deleteSnake(speciesId) {
    if (!confirm("Are you sure you want to delete this snake?")) return;

    fetch("snake_crud.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `action=delete&species_id=${speciesId}`
    })
    .then(response => response.text())
    .then(data => {
        alert(data);
        const row = document.getElementById("row_" + speciesId);
        if (row) row.remove();
    })
    .catch(error => {
        console.error("Delete error:", error);
        alert("An error occurred while deleting the snake.");
    });
}
