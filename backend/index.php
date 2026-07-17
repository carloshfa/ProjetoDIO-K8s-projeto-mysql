<?
# Backend PHP simples responsável por receber dados do frontend e inserir no MySQL.
# Este arquivo atua como endpoint HTTP para o formulário de feedback.
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

include 'conexao.php';

$id =  rand(1, 999);
$nome = $_POST["nome"];
$email = $_POST["email"];
$comentario = $_POST["comentario"];

$query = "INSERT INTO mensagens(id, nome, email, comentario) VALUES ('$id', '$nome', '$email', '$comentario')";


if ($link->query($query) === TRUE) {
  echo "New record created successfully";
<?php
# Backend PHP seguro que recebe dados via POST e persiste no MySQL usando prepared statements.
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: *');
header('Content-Type: application/json; charset=utf-8');

include 'conexao.php';

// Aceita apenas requisições POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['error' => 'Method not allowed']);
  exit;
}

// Lê os campos enviados no POST (validação mínima).
$nome = isset($_POST['nome']) ? trim($_POST['nome']) : '';
$email = isset($_POST['email']) ? trim($_POST['email']) : '';
$comentario = isset($_POST['comentario']) ? trim($_POST['comentario']) : '';

if ($nome === '' || $email === '' || $comentario === '') {
  http_response_code(400);
  echo json_encode(['error' => 'Missing required fields']);
  exit;
}

// Usa prepared statement para evitar SQL injection.
$stmt = $link->prepare('INSERT INTO mensagens (nome, email, comentario) VALUES (?, ?, ?)');
if ($stmt === false) {
  http_response_code(500);
  echo json_encode(['error' => 'Prepare failed', 'detail' => $link->error]);
  exit;
}

$stmt->bind_param('sss', $nome, $email, $comentario);
$ok = $stmt->execute();

if ($ok) {
  echo json_encode(['success' => true, 'message' => 'Record created']);
} else {
  http_response_code(500);
  echo json_encode(['error' => 'Insert failed', 'detail' => $stmt->error]);
}

$stmt->close();
?>