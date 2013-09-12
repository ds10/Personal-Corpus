<?php

//error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

//1) connect to mysql

$db = new PDO('mysql:host=localhost;dbname=personalcorpus;charset=utf8', 'KingKongRoot','CarBoot');


//2)

$row = 1;
if (($handle = fopen("markblog.csv", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
    	//print_r($data);
        $num = count($data);
        echo "<p> $num fields in line $row: <br /></p>\n";
        $row++;
       
          
           for ($c=0; $c < $num; $c++) {
             $idata = $db->quote($data[$c]);
            // echo $data[$c] . "<br />\n";
            
            $query = "INSERT INTO store(store) VALUES($idata)";
            // print $query;
             $result = $db->exec($query);
		//  //print $result;
         // print  $db->lastInsertId();
       		}
          
    }
    fclose($handle);
}

?>