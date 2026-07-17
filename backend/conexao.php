<?php
# Lê variáveis de ambiente para configurar a conexão com o MySQL.
$servername = getenv('DB_HOST') ?: 'mysql';
$username = getenv('DB_USERNAME') ?: 'root';
$password = getenv('DB_PASSWORD') ?: 'Senha123';
$database = getenv('DB_DATABASE') ?: 'meubanco';

# Cria uma conexão MySQLi usando as credenciais do ambiente.
$link = new mysqli($servername, $username, $password, $database);

if ($link->connect_error) {
    die('Connection failed: ' . $link->connect_error);
}
?>
