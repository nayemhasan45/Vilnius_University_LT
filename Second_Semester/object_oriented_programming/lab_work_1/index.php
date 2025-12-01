<?php
include("./functions.php");
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collatz Calculator</title>
    <style>
        h2 {
            text-align: center;
            margin-bottom: 10px;
        }

        form {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 50%;
            margin: auto;
            border-collapse: collapse;
        }

        th,
        td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
    </style>
</head>

<body>
    <h2>Collatz Calculator</h2>
    <form action="./" method="GET">
        Enter a number to start the sequence: <input type="number" name="start_number" required /><br><br>
        <input type="submit" name="calculate" value="Calculate" />
    </form>

    <?php
    if (isset($_GET["calculate"])) {
        $inputNumber = abs($_GET["start_number"]);

        $sequenceArray = myCollatz($inputNumber);
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

    <h2>Collatz Calculator With Range</h2>
    <form action="./" method="GET">
        Enter a start number: <input type="number" name="num_1" required /><br><br>
        Enter an end number: <input type="number" name="num_2" required /><br><br>
        <input type="submit" name="calc_range" value="Calculate" />
    </form>

    <?php
    if (isset($_GET["calc_range"])) {
        $num_1 = abs($_GET["num_1"]);
        $num_2 = abs($_GET["num_2"]);

        if ($num_2 > $num_1) {
            $mySeqRangeArr = myCollatzSequenceInRange($num_1, $num_2);

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
    }
    ?>

</body>

</html>
