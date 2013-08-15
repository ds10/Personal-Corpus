<?php

//error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

//1) connect to mysql

$db = new PDO('mysql:host=localhost;dbname=personalcorpus;charset=utf8', 'KingKongRoot','CarBoot');


//2)

$row = 1;
if (($handle = fopen("tweets.csv", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
    	print_r($data);
        $num = count($data);
        echo "<p> $num fields in line $row: <br /></p>\n";
        $row++;
       
          $query = "INSERT INTO store(store, site, date) VALUES('$data[7]', 'twitter','$data[5]')";
          print $query;
          $result = $db->exec($query);
		  print $result;
          print  $db->lastInsertId();
    }
    fclose($handle);
}

?>