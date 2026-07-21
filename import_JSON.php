<!DOCTYPE html>
<html lang="en">
<head>
<title>Import Ticket Sales</title>
</head>

<body>

<?php

echo "Started importing ... " . date("h:i:sa");
flush();
ob_flush();

/* Attempt MySQL server connection. Assuming you are running MySQL
server with default setting (user 'root' with no password) */
$link = mysqli_connect("109.228.52.95", "qosfclivedb", "P@ssword1919", "qosfctickets");


 
// Check connection
if($link === false){
    die("ERROR: Could not connect. " . mysqli_connect_error());
}

$fixtureid = 842705;
$x = 1;
$baseurl = 'https://ticketco.events:443/api/public/v1/item_grosses?token=nk6t4EzmDNuB3vAZ1gMy&event_id='.$fixtureid.'&page=';



do {


$url = $baseurl . $x;


$json = file_get_contents($url);

$data = json_decode($json);

// var_dump($data);
// print_r($data);

if (count($data->item_grosses)) {
        // Open the table
        echo "<table>";

        // Cycle through the array
        foreach ($data->item_grosses as $idx => $stand) {

            // Output a row
//             echo "<tr>";
//             echo "<td>$stand->transaction_datestamp</td>";
//             echo "<td>$stand->ref_number</td>";
//             echo "<td>$stand->holder_last_name</td>";

//             echo "<td>$stand->ref_number</td>";
//             echo "<td>$stand->section_name</td>";
//        echo "<td>$stand->item_type_title</td>";
//        echo "<td>$stand->event_name</td>";
//          echo "<td>$stand->checked_in_at</td>";
// echo "<td>$stand->item_type_type</td>";


//        echo "</tr>";


//write to db

if($stand->checked_in_at){
   if($stand->checked_out_at){
      $checkedinvalue = 0;
$checkedinturnstile = '';

   } else {
    $checkedinvalue = 1;
    $checkedinturnstile = 'notset';
 }  

} else {
$checkedinvalue = 0;
$checkedinturnstile = '';
};


if($stand->check_in_user_id == '3169864'){
$checkedinturnstile = 'turnstile1';
} else if ($stand->check_in_user_id == '3169868'){
   $checkedinturnstile = 'turnstile3';
}  else if ($stand->check_in_user_id == '3169871'){
   $checkedinturnstile = 'turnstile4';
}   else if ($stand->check_in_user_id == '3299860'){
   $checkedinturnstile = 'turnstile22';
} else if ($stand->check_in_user_id == '3299862'){
   $checkedinturnstile = 'turnstile16';
} else if ($stand->check_in_user_id == '3299865'){
   $checkedinturnstile = 'turnstile17';
} else if ($stand->check_in_user_id == '3299867'){
   $checkedinturnstile = 'turnstileE1';
} else if ($stand->check_in_user_id == '3299868'){
   $checkedinturnstile = 'turnstileE2';
} else if ($stand->check_in_user_id == '3299870'){
   $checkedinturnstile = 'turnstileE3';
} else if ($stand->check_in_user_id == '3299872'){
   $checkedinturnstile = 'turnstileE4';
}
 





      $sql = "REPLACE INTO ticketco_matchsales (PurchaseDate,  TicketCoRef,GroundArea,TicketType, EventName, QtySold, QtyCheckedIn, CheckedInDate, CheckedInOperator, ticketcotickettype, fixtureid) VALUES ('$stand->transaction_datestamp','$stand->ref_number','$stand->section_name','$stand->item_type_title', '$stand->event_name', 1, $checkedinvalue, '$stand->checked_in_at', '$checkedinturnstile', '$stand->item_type_type', $fixtureid )"; 



if(mysqli_query($link, $sql)){
    // echo "Records added successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
}
 


        }

        // Close the table
        // echo "</table>";
    }







  $x++;
} while (count($data->item_grosses));



echo "Succesfully imported at ..." . date("h:i:sa");
flush();
ob_flush();



// Close connection
mysqli_close($link);


?>
</body>


                            </html>