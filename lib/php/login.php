<?php
include "connection.php";


$email = $_POST['email'] ?? null;
$pass = sha1($_POST['pass'] ?? null);
$array=null;

try {
    if (isset( $email, $pass)) {
        $req = $db->prepare("select * from users where email=?and password=?");
        $req->execute(array($email,$pass));
        $exist=$req->rowCount();
        if($exist==1){
            $array=$req->fetch();
            $msg="succes connection";
            $success=1;
      
     }
     else{
        $msg="email or password incorrect";
        $success=0;
     }
    } else {
        $success = 0;
        $msg = "error empty data";
    }
} catch (\Throwable $th) {
    $success = 0;
    $msg = "Error: " . $th->getMessage();
}

echo json_encode([
    "data" => [
        $msg,
        $success,
        $array
    ]
]);
?>
