<?php
session_start();
include('session.php');
?>
<html>

<head>
   <title>Welkom </title>
</head>

<body>
   <h1>Welkom <?php echo $naam ?></h1>
   <p>Jouw graad is <b><?php echo $graad ?></b></p>
   <h2>Lessen voor jou: </h2>
   <ul>
      <li><a href="/LESMATERIAAL/wit/leerstofwit.php">Witte gordel</li>
      <?php echo ($graad == 'geel' || $graad == 'oranje' || $graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/geel/leerstofgeel.php">Gele gordel</li>' : '' ?>
      <?php echo ($graad == 'oranje' || $graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/oranje/leerstoforanje.php">Oranje gordel</li>' : '' ?>
      <?php echo ($graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/groen/leerstofgroen.php">Groene gordel</li>' : '' ?>
      <?php echo ($graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/blauw/leerstofblauw.php">Blauwe gordel</li>' : '' ?>
      <?php echo ($graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/bruin/leerstofbruin.php">Bruine gordel</li>' : '' ?>
      <?php echo ($graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/zwart/leerstofzwart.php">Zwarte gordel</li>' : '' ?>
      <?php echo ($graad == 'rood') ? '<li><a href = "/LESMATERIAAL/rood/leerstofrood.php">Rode gordel</li>' : '' ?>
   </ul>
   <h2><a href="logout.php">Sign Out</a></h2>
</body>

</html>