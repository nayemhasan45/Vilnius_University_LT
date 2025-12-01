
<?php
	if(isset($_GET["calc_range"])){
		$num_1 = abs($_GET["num_1"]);
		$num_2 = abs($_GET["num_2"]);
		
		if($num_2 > $num_1){
			$mySeqRangeArr = $progObj->collatzSequenceInRange($num_1, $num_2);
			
			$maxVal = 0;
			foreach($mySeqRangeArr as $ar1){
				$mxVal = $ar1["iteration"];
				if($mxVal > $maxVal){$maxVal = $mxVal;} //here we get the maximum iteration
				echo "<p>Number: ".$ar1["number"]." | Max. Number: ".$ar1["highest_number"]." | Iteration: ".$ar1["iteration"]."</p>";
			}
			
			$minVal = $maxVal;
			echo "<br><p>Maximun Iteration:</p>";
			foreach($mySeqRangeArr as $ar1){
				$mxVal = $ar1["iteration"];
				if($mxVal < $minVal){$minVal = $mxVal;} //here we get the minimum iteration
				if($mxVal == $maxVal){
					echo "<p>Number: ".$ar1["number"]." | Max. Number: ".$ar1["highest_number"]." | Iteration: ".$ar1["iteration"]."</p>";
				}
			}
			
			echo "<br><p>Minimum Iteration:</p>";
			foreach($mySeqRangeArr as $ar1){
				$mxVal = $ar1["iteration"];
				if($mxVal == $minVal){
					echo "<p>Number: ".$ar1["number"]." | Max. Number: ".$ar1["highest_number"]." | Iteration: ".$ar1["iteration"]."</p>";
				}
			}
		}else{
			echo "Please enter the correct number!";
		}
	}
?>