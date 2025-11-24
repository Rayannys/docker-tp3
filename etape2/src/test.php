<?php
// etape2/src/test.php

$servername = "DB"; // Alias réseau défini par le --name du container MariaDB
$username = "user";
$password = "password";
$dbname = "tp3_db";

// Créer la connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("<h1>? Échec de la connexion à la base de données :</h1> <pre>" . $conn->connect_error . "</pre>");
}

echo "<h1>? Connexion MariaDB réussie depuis PHP-FPM!</h1>";

// Tenter de lire les données (si elles existent)
$sql = "SELECT content, created_at FROM messages";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<h2>Contenu de la table 'messages' :</h2>";
    echo "<ul>";
    while($row = $result->fetch_assoc()) {
        echo "<li>[" . $row["created_at"] . "] " . htmlspecialchars($row["content"]) . "</li>";
    }
    echo "</ul>";
} else {
    echo "<h2>La table est vide.</h2>";
}

$conn->close();
?>
