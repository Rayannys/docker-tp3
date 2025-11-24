-- etape2/mariadb_init/create.sql
-- Crée une table simple pour tester la connexion PHP.
CREATE DATABASE IF NOT EXISTS tp3_db;
USE tp3_db;
CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- L'accent a ete retire (reussie -> reussie) pour eviter l'erreur d'encodage Windows/MariaDB
INSERT INTO messages (content) VALUES ('Connexion reussie ! Premier message de test.');
