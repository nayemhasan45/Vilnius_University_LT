<?php
include("./class.php");
$collatzProgram = new myProgram();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collatz Sequence Statistics</title>
    <style>
        .histogram {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 10px;
            margin-bottom: 5px;
        }
        .bar {
            background-color: #007bff;
            width: 20px;
            border-radius: 3px;
            margin-right: 5px;
        }
        .display{
            display: grid;
            grid-template-columns: repeat(5,1fr);
        }
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        form {
            text-align: center;
            margin-bottom: 20px;
        }

        form input {
            padding: 10px;
            margin: 5px;
        }

        input[type="submit"] {
            background-color: #4caf50;
            color: white;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h2>Collatz Conjecture Calculator</h2>
    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="GET">
        Enter a number to start the sequence: <input type="number" name="start_number" required />
        <input type="submit" name="calculate" value="Calculate" />
    </form>
    <?php
    if (isset($_GET["calculate"])) {
        $inputNumber = abs($_GET["start_number"]);

        $sequenceArray = $collatzProgram->collatz($inputNumber);
        $iterationCount = count($sequenceArray) - 1;
        $maxArrayNumber = max($sequenceArray);

        echo "<p>The Iteration is $iterationCount and The Maximum Number is " . $maxArrayNumber . "</p>";
        echo "<p>The Collatze Sequence for " . $inputNumber . " is: ";
        foreach ($sequenceArray as $arrayElement) {
            echo $arrayElement . ", ";
        }
        echo "</p>";
    }
    ?>
    <br><br>
    
    <h2>Collatz Conjecture Calculator</h2>
    <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="GET">
        Enter a start number: <input type="number" name="num_1" required />
        Enter an end number: <input type="number" name="num_2" required />
        <input type="submit" name="calc_range" value="Calculate" />
    </form>

    <?php
    if (isset($_GET["calc_range"])) {
        $num_1 = abs($_GET["num_1"]);
        $num_2 = abs($_GET["num_2"]);

        if ($num_2 > $num_1) {
            $mySeqRangeArr = $collatzProgram->collatzSequenceInRange($num_1, $num_2);

            echo "<h2>Collatz Sequence Range</h2>";
            echo "<table border='1'>";
            echo "<tr><th>Number</th><th>Max Number</th><th>Iteration</th></tr>";

            foreach ($mySeqRangeArr as $ar1) {
                echo "<tr>";
                echo "<td>" . $ar1["number"] . "</td>";
                echo "<td>" . $ar1["highest_number"] . "</td>";
                echo "<td>" . $ar1["iteration"] . "</td>";
                echo "</tr>";
            }

            echo "</table>";

            $maxVal = max(array_column($mySeqRangeArr, 'iteration'));
            $minVal = min(array_column($mySeqRangeArr, 'iteration'));

            echo "<br><p>Maximum Iteration:</p>";
            echo "<table border='1'>";
            echo "<tr><th>Number</th><th>Max Number</th><th>Iteration</th></tr>";

            foreach ($mySeqRangeArr as $ar1) {
                if ($ar1["iteration"] == $maxVal) {
                    echo "<tr>";
                    echo "<td>" . $ar1["number"] . "</td>";
                    echo "<td>" . $ar1["highest_number"] . "</td>";
                    echo "<td>" . $ar1["iteration"] . "</td>";
                    echo "</tr>";
                }
            }

            echo "</table>";

            echo "<br><p>Minimum Iteration:</p>";
            echo "<table border='1'>";
            echo "<tr><th>Number</th><th>Max Number</th><th>Iteration</th></tr>";

            foreach ($mySeqRangeArr as $ar1) {
                if ($ar1["iteration"] == $minVal) {
                    echo "<tr>";
                    echo "<td>" . $ar1["number"] . "</td>";
                    echo "<td>" . $ar1["highest_number"] . "</td>";
                    echo "<td>" . $ar1["iteration"] . "</td>";
                    echo "</tr>";
                }
            }

            echo "</table>";
        } else {
            echo "Please enter the correct number!";
        }
        echo "<style>";
        echo "h2 { text-align: center; margin-bottom: 10px; }";
        echo "form { text-align: center; margin-bottom: 20px; }";
        echo "table { width: 50%; margin: auto; border-collapse: collapse; }";
        echo "th, td { border: 1px solid black; padding: 8px; text-align: center; }";
        echo "</style>";
    }
    ?> <br><br>
    <h2>Collatz Sequence Statistics</h2>
    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
        <label for="start">Start Number:</label>
        <input type="number" id="start" name="start" required>
        <br>
        <label for="end">End Number:</label>
        <input type="number" id="end" name="end" required>
        <br>
        <input type="submit" value="Calculate">
    </form>
</body>
</html>

<?php
// PHP code starts here
class myCollatzProgram {
    public function collatz($a) {
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

    public function collatzSequenceInRange($start, $end) {
        $sequences = array();

        for ($i = $start; $i <= $end; $i++) {
            $seq = $this->collatz($i);
            $sequences[] = array(
                'number' => $i,
                'sequence' => $seq
            );
        }

        return $sequences;
    }
}

class CollatzStatistics extends myCollatzProgram {
    public function calculateHistogram() {
        $histogram = array();

        // Get start and end numbers from the form
        $start = $_POST['start'];
        $end = $_POST['end'];

        $sequences = $this->collatzSequenceInRange($start, $end);

        foreach ($sequences as $sequenceData) {
            $sequence = $sequenceData['sequence'];
            foreach ($sequence as $iteration => $value) {
                if (isset($histogram[$iteration])) {
                    $histogram[$iteration][] = $value;
                } else {
                    $histogram[$iteration] = array($value);
                }
            }
        }

        return $histogram;
    }
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Create an instance of the CollatzStatistics class
    $collatzStats = new CollatzStatistics();
    
    // Calculate histogram
    $histogram = $collatzStats->calculateHistogram();
    
    // Display histogram
    echo "<h3>Collatz Histogram</h3>";
    echo"<div class='display'>";
    foreach ($histogram as $iteration => $sequence) {
        echo "<div class='histogram'>";
        $barWidth = count($sequence) * 10; // Adjust the width of the bar
        echo "<div class='bar' style='height: {$barWidth}px;'></div>";
        echo "<span>Iteration $iteration:</span>";
        echo "</div>";
    }
    echo"</div>";
}
?>
