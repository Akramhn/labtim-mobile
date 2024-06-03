<?php
include "connection.php";

$idp = json_decode($_POST["idp"]);
$isok = false;
$msg = "";

try {
    $req = $db->prepare("DELETE FROM `patients` WHERE id_patient = ?");
    $req->execute([$idp]); // Corrected line
    $isok = true;
    $msg = "Suppression ok";
} catch (\Throwable $th) {
    $msg = "Echec suppression";
    //throw $th;
}

echo json_encode([
    "data" => [
        $isok,
        $msg
    ]
]);
?>
