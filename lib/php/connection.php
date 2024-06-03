<?php
    $host = "localhost";
    $dbname = "id21088984_labtim";
    $user = "id21088984_akram";
    $passw = "Labtim/2023";
    
    try {
        $db = new PDO("mysql:host=$host; dbname=$dbname", $user, $passw);
        echo "connected";
    } catch (\Throwable $th) {
        echo "Error: ".$th->getMessage();
    }
?>