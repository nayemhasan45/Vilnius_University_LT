using System;
// using Internal;
class Program
{
    static void Main(string[] args)
    {
        fibonacciCalc calc = new fibonacciCalc();

        // Test single number
        int numberToTest = 20;
        calc.TestSingleNumber(numberToTest);

        // Test number range
        Console.WriteLine("\nEnter range");
        Console.Write("Start: ");
        int start = int.Parse(Console.ReadLine());
        Console.Write("End: ");
        int end = int.Parse(Console.ReadLine());
        calc.testNumberRange(start, end);
    }
}