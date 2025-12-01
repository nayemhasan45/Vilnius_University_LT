<?php
class myProgram {
    public function collatz($a) {
        $sequence = array($a);

        while ($a != 1) {
            if ($a % 2 == 0) {
                $a = $a / 2;
            } else {
                $a = 3 * $a + 1;
            }
            $sequence[] = $a;
        }

        return $sequence;
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
            $seq[] = 1;
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