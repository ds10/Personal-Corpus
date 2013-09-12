<?php



$con=mysqli_connect("localhost","KingKongRoot","CarBoot","personalcorpus");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

$result = mysqli_query($con,"SELECT * FROM reddittopics");




echo "<table border='1'>
<tr>
<th>Subreddit</th>
<th>Topic</th>
</tr>";

while($row = mysqli_fetch_array($result))
  {
  echo "<tr>";
  echo "<td>" . $row['subreddit'] . "</td>";
  echo "<td>" . $row['topics'] . "</td>";
  echo "</tr>";
  }
echo "</table>";

mysqli_close($con);
?>