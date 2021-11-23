
 <script type="text/javascript">
  setTimeout(function(){
    location = ''
  },100000)
</script>



<?php
$user = "robot";
$password = "robot123";
$database = "example_database";
$table = "laskut";
echo "
<style>
table, th, td {
  border: 2px solid black;
  border-collapse: collapse;
  padding: 5px;
      text-align: center; 
    vertical-align: middle;
}
body {
  background-image: url('robot.jpg');
   background-repeat: no-repeat;
   background-attachment: fixed;
   background-position: right;
   background-size: 300px 300px;
}
div.table 
{
    display:table;
}
form.tr, div.tr
{
    display:table-row;
}
span.td
{
    display:table-cell;
}
</style>
<title>Laskut</title>

";


try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  
    echo "<h3>Laskujen manuaalinen käsittely</h3>
<form method='post' action='#'>
  Lasku_ID:
  <input type='text' name='ID'>
  
  Tiedostonimi:
  <input type='text' name='tiedostonimi'>
  
  Summa €:
  <input type='text' name='summa'>
  <input type='submit' value='Tallenna'>
</form>
<br><br>
<br>
  "
  ;
$ID=$_POST['ID'];
$tiedostonimi=$_POST['tiedostonimi'];
$summa=$_POST['summa'];




if(isset($_POST['ID'], $_POST['tiedostonimi'], $_POST['summa']) && is_numeric( $_POST['ID'] ) && $_POST['ID'] > 0) {
$sql = "DELETE FROM $table WHERE lasku_id=$ID";
$result = $db->prepare($sql)->execute();

$sql = "INSERT INTO $table (lasku_id, tiedostonimi, summa, tila) VALUES (?,?,?,?)";
$result = $db->prepare($sql)->execute([$ID, $tiedostonimi, $summa, 'OK']);
  }


  echo "

  <table>
  <tr>
    <th colspan='3'>Käsitellyt laskut</th>
  </tr>
  <tr>
    <th>Lasku_ID</th>
    <th>Tiedostonimi</th>
    <th>Summa €</th>
  </tr>";
  foreach($db->query("SELECT * FROM $table WHERE tila='OK'") as $row) {
 
    echo "<tr><td>" . $row['lasku_id'] . "</td><td>".$row['tiedostonimi'] ."</td><td>".$row['summa']."</td></tr>";
  }
  $sql = "SELECT  SUM(summa) AS summa FROM example_database.laskut WHERE tila='OK'";
  $result = $db->query($sql);


$row = $result->fetch(PDO::FETCH_ASSOC);
  echo "<tr>
  
  <th colspan='2'> Yhteensä:</th>
    <th> " .  $row['summa'] . "</th>
  </tr>";
      
  echo "</table>";


  echo "<br>";

  echo "<table>
  <tr>
    <th colspan='3'>Käsittelemättömät laskut</th>
  </tr>
  <tr>
    <th>Lasku_ID</th>
    <th>Tiedostonimi</th>
   <th>Epäonnistumisen syy</th>
  </tr>";
  foreach($db->query("SELECT * FROM $table WHERE tila='Virhe!'") as $row) {
 
    echo "<tr><td>" . $row['lasku_id'] . "</td><td>".$row['tiedostonimi'] ."</td><td>PDF luku epäonnistui</td></tr>";
  }

      
  echo "</table>";



} catch (PDOException $e) {
    echo "Tietokantavirhe!: " . $e->getMessage() . "<br/>";
    die();
}


