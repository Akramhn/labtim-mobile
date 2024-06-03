<?php
include "connection.php";

$name = $_POST['name'] ?? null;
$email = $_POST['email'] ?? null;
$pass = sha1($_POST['pass'] ?? null);

try {
    if (isset($name, $email, $pass)) {
        $req = $db->prepare("SELECT * FROM users WHERE email=?");
        $req->execute([$email]); // Corrected the parameter passing with an array

        $exist = $req->rowCount();
        if ($exist == 0) {
            $req = $db->prepare("INSERT INTO users VALUES (null, ?, ?, ?)");
            $req->execute([$name, $email, $pass]); // Corrected the parameter passing with an array

            // Check for query execution errors
            if (!$req) {
                $errorInfo = $req->errorInfo();
                throw new Exception("Query Execution Error: " . $errorInfo[2]);
            }

            $success = 1;
            $msg = "success register";
        } else {
            $msg = "email already exists";
            $success = 0;
        }
    } else {
        $success = 0;
        $msg = "error empty data";
    }
} catch (\Throwable $th) {
    $success = 0;
    $msg = "Error: " . $th->getMessage();
}

// You need to echo the JSON response to send it to the client
echo json_encode([
    "data" => [
        $msg,
        $success
    ]
]);
?>
