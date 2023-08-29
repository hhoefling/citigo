<?php

# erzeugt soc.txt asyncron da es laenger dauerk kann
# jedenfalls mehr als 1 bis 2 Sekunden.

 $para='';
 if( isset($_GET['para'] )) 
    $para=$_GET['para'] ;
  
 exec("./soc_citigo/getsoc.sh $para >>./soc_citigo/getsoc.log 2>&1 & ", $output,$retval);
# echo "Returned with status $retval and output:\n";
# print_r($output);
# echo "\n";

 # Nehme letzten ermittelten Wert mit zurueck, warte nicht auf das Ende der aktuellen abfrage
 $soc  = file_get_contents('./soc.txt');
 echo $soc

?>

