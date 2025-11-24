# etape2/launch.ps1
$HOST_PATH = Get-Item $PSScriptRoot -Force | Select-Object -ExpandProperty FullName

Write-Host "--- Étape 2 : Démarrage de Nginx, PHP-FPM Custom et MariaDB (sans Compose) ---"

# Nettoyage des containers et du réseau
docker stop HTTP, SCRIPT, DB -t 1 2>$null
docker rm HTTP, SCRIPT, DB 2>$null
docker network rm tp3_net 2>$null

# 1. Création d'un réseau custom
Write-Host "1. Création du réseau 'tp3_net'"
docker network create tp3_net

# 2. Construction de l'image PHP custom (avec mysqli)
Write-Host "2. Construction de l'image 'php-mysqli-custom'..."
docker build -t php-mysqli-custom -f "$HOST_PATH/config/Dockerfile_PHP" "$HOST_PATH/config"

# 3. Lancement du container DB (MariaDB)
Write-Host "3. Lancement du container DB (MariaDB)"
docker run -d `
  --name DB `
  --network tp3_net `
  -e MARIADB_ROOT_PASSWORD=rootpass `
  -e MARIADB_DATABASE=tp3_db `
  -e MARIADB_USER=user `
  -e MARIADB_PASSWORD=password `
  -v "$HOST_PATH/mariadb_init:/docker-entrypoint-initdb.d" `
  mariadb:latest
  
# Attendre un peu que la DB soit initialisée (nécessaire pour l'initdb.d)
Start-Sleep -Seconds 10
Write-Host "MariaDB lancée et initialisée..."

# 4. Lancement du container SCRIPT (PHP-FPM Custom)
Write-Host "4. Lancement du container SCRIPT (PHP-FPM Custom)"
docker run -d `
  --name SCRIPT `
  --network tp3_net `
  -v "$HOST_PATH/src:/app" `
  php-mysqli-custom
  
# 5. Lancement du container HTTP (NGINX)
Write-Host "5. Lancement du container HTTP (NGINX)"
docker run -d `
  --name HTTP `
  --network tp3_net `
  -p 8080:80 `
  -v "$HOST_PATH/src:/app" `
  -v "$HOST_PATH/config/default.conf:/etc/nginx/conf.d/default.conf" `
  nginx:latest

Write-Host ""
Write-Host "--- Statut des containers ---"
docker ps
Write-Host ""
Write-Host "--- Test de validité ---"
Write-Host "Consultez http://localhost:8080/ (pour phpinfo) et http://localhost:8080/test.php (pour la DB) dans votre navigateur."
