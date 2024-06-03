<?php
include "connection.php";


$post=json_decode($_POST["data"]);
$nom=$post->nom;
$prenom=$post->prenom;
$tel=$post->tel;
$token=$post->token;
$_key=$post->_key;
$isok=false;
$msg="";
try {
    $req=$db->prepare("insert into patients(nom,prenom,tel,token,_key)values(?,?,?,?,?)");
    $req->execute(array($nom,$prenom,$tel,$token,$_key));
    if($req)
    {
    $isok=true;
    $msg="ajouter avec succès";
    }
    else{
        $msg="échec d'ajout";
    }
} catch (\Throwable $th) {
    $msg="échec d'ajout";
}
echo json_encode(["data"=>[$isok,$msg]])

?>