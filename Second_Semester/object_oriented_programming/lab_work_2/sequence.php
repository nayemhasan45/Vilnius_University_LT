<?php
	if(isset($_GET["calculate"])){
		$num = abs($_GET["start_number"]);
		
		$myArr = $progObj->collatz($num);
		$iteration = count($myArr) - 1;
		$maxArrNum = max($myArr);
		
		echo "<p>The Iteration is $iteration and The Maximum Number is ".$maxArrNum."</p>";
		echo "<p>The Collatze Sequence for ".$num." is: ";
		foreach($myArr as $ar){
			echo $ar.", ";
		}
		echo "</p>";
	}
?>