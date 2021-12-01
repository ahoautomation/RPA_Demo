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
  background-image: url('robo.jpg');
   background-repeat: no-repeat;
   background-attachment: fixed;
   background-position: right;
   background-size: 100% 100%;
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
<title>Järjestelmä B - Laskut</title>

";

try
{
    $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);

    echo "<h1>Järjestelmä B</h1><br><h3>Laskujen syöttö</h3>
<form method='post' action='#'>
  Lasku_ID:
   <br>
  <input type='text' name='ID'>
  <br>
  Tiedostonimi:
   <br>
  <input type='text' name='tiedostonimi'>
  <br>
  Summa €:
   <br>
  <input type='text' name='summa'>
  <br> <br>
  <input type='submit' value='Tallenna'>
</form>
<br><br>

  ";
  
    # strip_tags() - Strip HTML and PHP tags from a string
    # https://www.php.net/manual/en/function.strip-tags.php
  
    # htmlspecialchars() - Convert special characters to HTML entities
    # Example: & (ampersand)	=>	&amp;
    # https://www.php.net/manual/en/function.htmlspecialchars.php
    
    $ID = htmlspecialchars(strip_tags($_POST['ID']));
    $tiedostonimi = htmlspecialchars(strip_tags($_POST['tiedostonimi']));
    $summa = htmlspecialchars(strip_tags($_POST['summa']));

    if (isset($_POST['ID'], $_POST['tiedostonimi'], $_POST['summa']) && is_numeric($_POST['ID']) && $_POST['ID'] > 0)
    {
        $sql = "DELETE FROM $table WHERE lasku_id=$ID";
        # calling PDO::prepare() and PDOStatement::execute() helps to prevent SQL injection attacks by eliminating the need to manually quote and escape the parameters. 
        # https://www.php.net/manual/en/pdo.prepare.php
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
    <th>Lasku ID</th>
    <th>Tiedostonimi</th>
    <th>Summa €</th>
  </tr>";
    foreach ($db->query("SELECT * FROM $table WHERE tila='OK'") as $row)
    {

        echo "<tr><td>" . htmlspecialchars(strip_tags($row['lasku_id'])) . "</td><td>" . htmlspecialchars(strip_tags($row['tiedostonimi'])) . "</td><td>" . htmlspecialchars(strip_tags($row['summa'])) . "</td></tr>";
    }
    $sql = "SELECT  SUM(summa) AS summa FROM example_database.laskut WHERE tila='OK'";
    $result = $db->query($sql);

    $row = $result->fetch(PDO::FETCH_ASSOC);
    echo "<tr>
  
  <th colspan='2'> Yhteensä:</th>
    <th> " . $row['summa'] . "</th>
  </tr>";

    echo "</table><br>";


    # Käsittelemättömät laskut -taulu näytetään vain, jos käsittelemättömiä laskuja löytyy tietokannasta.
    $sql = $db->prepare("SELECT * FROM $table WHERE tila='Virhe!'");
    $sql->execute();
    if ($sql->rowCount() > 0)
    {

        echo "<table>
  <tr>
    <th colspan='3'>Laskut, joiden käsittelyssä tapahtui virhe</th>
  </tr>
  <tr>
    <th>Lasku ID</th>
    <th>Tiedostonimi</th>
   <th>Epäonnistumisen syy</th>
  </tr>";
        foreach ($db->query("SELECT * FROM $table WHERE tila='Virhe!'") as $row)
        {

            echo "<tr><td>" . htmlspecialchars(strip_tags($row['lasku_id'])) . "</td><td>" . htmlspecialchars(strip_tags($row['tiedostonimi'])) . "</td><td>PDF luku epäonnistui</td></tr>";
        }

        echo "</table>";

    }

}
catch(PDOException $e)
{
    echo "Sivun käsittelyssä tapahtui virhe!";
    die();
}

