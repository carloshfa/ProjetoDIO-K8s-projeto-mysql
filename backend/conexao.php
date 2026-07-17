<?php
$servername = getenv('DB_HOST') ?: 'mysql';
$username = getenv('DB_USERNAME') ?: 'root';
$password = getenv('DB_PASSWORD') ?: 'Senha123';
$database = getenv('DB_DATABASE') ?: 'meubanco';

$link = new mysqli($servername, $username, $password, $database);

if ($link->connect_error) {
    die('Connection failed: ' . $link->connect_error);
}
?>
