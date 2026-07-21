<!DOCTYPE html>
<html lang="en">
<head>
<title>Import Season Ticket Sales</title>
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

$fixtureid = 573988;
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
     //   echo "<table>";

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
    $checkedinvalue = 1;
} else {
$checkedinvalue = 0;
};

$bodytag = str_replace("%body%", "black", "<body text='%body%'>");


$buyerfirstname = str_replace("'", "\'", $stand->buyer_first_name);
$buyerlastname = str_replace("'", "\'", $stand->buyer_last_name);
$holderfirstname = str_replace("'", "\'", $stand->holder_first_name);
$holderlastname = str_replace("'", "\'", $stand->holder_last_name);
$answers = str_replace("'", "\'", $stand->answers);


      $sql = "REPLACE INTO ticketco_seasontickets_2425 (PurchaseDate, TicketID,  TicketCoRef,GroundArea, SeatRow, SeatNumber, TicketType, BuyerFirstName, BuyerLastName, Printed, PrintName, EventName, QuestionAnswers) VALUES ('$stand->transaction_datestamp', '$stand->uuid', '$stand->ref_number','$stand->section_name','$stand->row', '$stand->seat', '$stand->item_type_title', '$buyerfirstname', '$buyerlastname', 0, concat('$holderfirstname',' ', '$holderlastname'), '$stand->event_name', '$answers')"; 




$sql = "REPLACE INTO ticketco_seasontickets_2425 (PurchaseDate, TicketID,  TicketCoRef,GroundArea, SeatRow, SeatNumber, TicketType, BuyerFirstName, BuyerLastName, Printed, PrintName, EventName, QuestionAnswers) VALUES ('$stand->transaction_datestamp', '$stand->uuid', '$stand->ref_number','$stand->section_name','$stand->row', '$stand->seat', '$stand->item_type_title', '$buyerfirstname', '$buyerlastname', 0, concat('$holderfirstname',' ', '$holderlastname'), '$stand->event_name', '$answers')"; 

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