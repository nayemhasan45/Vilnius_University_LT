<?php include("./class.php");
$progObj = new separateProgramme();
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Collatz Conjecture</title>
	<style>
		.width{
			width: 85%;
			margin: auto;
			color: white;
		}
		.first_section{
			background-color: #04aa6d;
			padding: 3rem;
			border-radius: 1rem;
			margin-top: 1rem;
		}
		.first_section h2{
			text-align: center;
			font-size: 3rem;
			margin-top: 0;
		}
		.form_1st{
			display: flex;
			flex-direction: column;
			width: 40%;
			gap: 1rem;
		}
		.form_1st input:first-child{
			border-radius: 1rem;
			padding: 1rem;
			border: none;
		}
		.form_1st_input{
			border-radius: 1rem;
			padding: 1rem;
			border: none;
		}
		.form_1st input:last-child{
			width: 40%;
			padding: 1rem;
			border-radius: 1rem;
			border: none;
			align-items: center;
			margin-left: 9rem;
		}
		.sec_section{
			background-color: #ff5c35;
			padding: 3rem;
			border-radius: 1rem;
			margin-top: 1rem;
		}
		.sec_section h2{
			text-align: center;
			font-size: 3rem;
			margin-top: 0;
		}
	</style>
</head>

<body class="width">
	<section class="first_section">
		<h2>Collatz Conjecture</h2>
		<form class="form_1st" action="./" method="GET">
			Enter a number to start the sequence: <input placeholder="enter a number" type="number" name="start_number" required />
			<input type="submit" name="calculate" value="Calculate" />
		</form>
		<?php include 'sequence.php'; ?>
	</section>

	<section class="sec_section">
		<h2>Collatz Conjecture</h2>
		<form class="form_1st" action="./" method="GET">
			Enter a start number: <input placeholder="enter a number" type="number" name="num_1" required />
			Enter an end number: <input placeholder="enter a number" class="form_1st_input" type="number" name="num_2" required />
			<input type="submit" name="calc_range" value="Calculate" />
		</form>
		<?php include 'range.php'; ?>
	</section>
</body>

</html>