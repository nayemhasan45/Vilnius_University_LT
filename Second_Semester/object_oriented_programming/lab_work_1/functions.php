<?php
function myCollatz($a) {
    $seq = array($a); // Start the sequence with the initial value of $a

    while ($a != 1) {
        if ($a % 2 == 0) {
            $a = $a / 2;
        } else {
            $a = 3 * $a + 1;
        }
        $seq[] = $a; // Add the new value of $a to the sequence
    }

    return $seq;
}

function myCollatzSequenceInRange($start, $end) {
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
?>
