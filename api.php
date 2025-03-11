<?php
include 'config.php';

header("Content-Type: application/json");

$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (!isset($data['name'], $data['dob'], $data['height'], $data['sex'], $data['phone_number'])) {
    http_response_code(400);
    echo json_encode(["message" => "Manglende eller ugyldige data"]);
    exit;
}

$name = $data['name'];
$dob = $data['dob'];
$height = $data['height'];
$sex = $data['sex'];
$phone_number = $data['phone_number'];
$gang = $data['gang'] ?? null; 
$note = $data['note'] ?? null;

$sql_check = "SELECT * FROM population WHERE phone_number = ?";
$stmt_check = $link->prepare($sql_check);
$stmt_check->bind_param("s", $phone_number); 
$stmt_check->execute();
$result = $stmt_check->get_result();

if ($result->num_rows > 0) {
    http_response_code(400);
    echo json_encode(["message" => "Spillerne med dette telefonnummer findes allerede"]);
    exit;
}

$sql_insert = "INSERT INTO population (name, dob, height, sex, phone_number, gang, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
$stmt_insert = $link->prepare($sql_insert);
$stmt_insert->bind_param("ssissss", $name, $dob, $height, $sex, $phone_number, $gang, $note);

if ($stmt_insert->execute()) {
    http_response_code(200);
    echo json_encode(["message" => "Personen findes allerede i systemet."]);
} else {
    http_response_code(500);
    echo json_encode(["message" => "Registreringen mislykkedes."]);
}

$stmt_check->close();
$stmt_insert->close();
?>
