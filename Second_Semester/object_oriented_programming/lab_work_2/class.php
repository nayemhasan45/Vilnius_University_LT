<?php
class separateProgramme {
	public function collatz($num) {
		$seq = array($num); // Start the sequence with the initial value of $a

		while ($num != 1) {
			if ($num % 2 == 0) {
				$num = $num / 2;
			} else {
				$num = 3 * $num + 1;
			}
			$seq[] = $num; // Add the new value of $a to the sequence
		}

		return $seq;
	}

	public function collatzSequenceInRange($start, $end) {
		$sequences = array();

		for ($i = $start; $i <= $end; $i++) {
			$seq = array();
			$num = $i;

			while ($num != 1) {
				$seq[] = $num;
				if ($num % 2 == 0) {
					$num = $num / 2;
				} else {
					$num = 3 * $num + 1;
				}
			}
			$seq[] = 1; // Add 1 to the end of the sequence
			$sequences[] = array(
				'number' => $i,
				'highest_number' => max($seq),
				'iteration' => count($seq) - 1
			);
		}

		return $sequences;
	}
}
?>