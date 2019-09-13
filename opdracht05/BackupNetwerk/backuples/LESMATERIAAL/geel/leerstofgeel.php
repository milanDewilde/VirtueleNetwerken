<?php
session_start();
include('../../session.php');
?>
<html>

<head>
   <title>Les 1 - Geel </title>
</head>

<body>
   <h1>Op naar de oranje gordel, <?php echo $naam ?></h1>
   <h2>Hier vind je alle lessen om je oranje gordel te behalen!</h2>
   <p>DIT IS DE VERNIEUWDE LEERSTOF!</p>
   <h2><a href="../../welcome.php">Back</a></h2>
   <h2><a href="../../logout.php">Sign Out</a></h2>
</body>

</html>