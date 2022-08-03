<?php
/*$servername = "localhost";
$username = "root";
$password = "";
$dbname = "";*/

$servername = "localhost";
$username = "username";
$password = "password";
$dbname = "databasename";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_query($conn, "SET SESSION time_zone = '+1:00'");
mysqli_query($conn, "SET NAMES 'utf8mb4'");

// Check connection
if ($conn->connect_error) {
    echo $conn->connect_error;
  die("Connection failed: " . $conn->connect_error);
}

?>