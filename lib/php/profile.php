<?php
include "connection.php";

$name = $_POST['name'] ?? null;
$email = $_POST['email'] ?? null;
$pass = sha1($_POST['pass'] ?? null);
$id = $_POST['id'] ?? null;
$success = 0;
$array=null;
try {
    if (isset($name, $email, $pass, $id)) {
        $req = $db->prepare("SELECT * FROM users WHERE email=? AND id!=?");
        $req->execute([$email, $id]);

        $exist = $req->rowCount();
        if ($exist == 0) {
            // Use the correct SQL syntax for updating a record
            $req = $db->prepare("UPDATE users SET nom=?, email=?, password=? WHERE id=?");
            $req->execute([$name, $email, $pass, $id]);
            $req2 = $db->prepare("select * from users where email=?and password=?");
            $req2->execute(array($email,$pass));
            $exist2=$req->rowCount();
            if($exist2==1){
                $array=$req->fetch();
            }
            // Check for query execution errors
            if (!$req) {
                $errorInfo = $req->errorInfo();
                throw new Exception("Query Execution Error: " . $errorInfo[2]);
            }

            $success = 1;
            $msg = "Success update";
        } else {
            $msg = "Email already exists";
            $success = 0;
        }
    } else {
        $success = 0;
        $msg = "Error: Empty data";
    }
} catch (\Throwable $th) {
    $success = 0;
    $msg = "Error: " . $th->getMessage();
}

// You need to echo the JSON response to send it to the client
echo json_encode([
    "data" => [
        $msg,
        $success,
        $array
    ]
]);
?>
