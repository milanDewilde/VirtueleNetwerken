<?php
   include('config.php');
   session_start();
   
   $user_check = $_SESSION['login_user'];
   
   $quer = "SELECT username, lid_voornaam, lid_achternaam, lid_graad FROM leden WHERE username = '$user_check';";
   $ses_sql = mysqli_query($db,$quer);
   
   $row = mysqli_fetch_array($ses_sql,MYSQLI_ASSOC);

   $graad = $row['lid_graad'];
   $naam = $row['lid_voornaam'] . " " . $row['lid_achternaam'];

   if(!isset($_SESSION['login_user'])){
      header("location:login.php");
      die();
   }
?>