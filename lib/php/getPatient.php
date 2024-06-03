<?php
include "connection.php";
$result=array();
try {
    $sql="select * from patients";
    $req=$db->query($sql);
    while($a=$req->fetch()){
        $result[]=$a;
    }

} catch (PDOException $th) {
    //throw $th;
}
echo json_encode($result);
?>