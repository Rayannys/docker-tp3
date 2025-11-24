# etape1/launch.ps1
$HOST_PATH = Get-Item $PSScriptRoot -Force | Select-Object -ExpandProperty FullName

Write-Host "--- Étape 1 : Démarrage de Nginx + PHP-FPM (sans Compose) ---"

# Nettoyage des containers nommés
docker stop HTTP, SCRIPT -t 1 2>$null
docker rm HTTP, SCRIPT 2>$null

# Suppression du réseau
docker network rm tp3_net 2>$null

# 1. Création d'un réseau custom
Write-Host "1. Création du réseau 'tp3_net'"
docker network create tp3_net

# 2. Lancement du container SCRIPT (PHP-FPM)
Write-Host "2. Lancement du container SCRIPT (PHP-FPM)"
docker run -d `
  --name SCRIPT `
  --network tp3_net `
  -v "$HOST_PATH/src:/app" `
  php:7.4-fpm

# 3. Lancement du container HTTP (NGINX)
Write-Host "3. Lancement du container HTTP (NGINX)"
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
Write-Host "Consultez http://localhost:8080/ dans votre navigateur."
