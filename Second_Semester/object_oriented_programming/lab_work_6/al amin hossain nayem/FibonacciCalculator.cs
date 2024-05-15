using System;

public class fibonacciCalc
{
    public long calFibo(int n)
    {
        if (n == 1 || n == 2)
            return 1;

        long a = 1;
        long b = 1;
        long result = 0;

        for (int i = 3; i <= n; i++)
        {
            result = a + b;
            a = b;
            b = result;
        }

        return result;
    }

    public void TestSingleNumber(int n)
    {
        Console.WriteLine($"Fibonacci Sequence up to {n}:");
        for (int i = 1; i <= n; i++)
        {
            long fib = calFibo(i);
            Console.WriteLine($"{fib}");
        }

        long maxNum = calFibo(n);
        int iterations = n;
        Console.WriteLine($"Max num : {maxNum}");
        Console.WriteLine($"Total iterations: {iterations}");
    }

    public void testNumberRange(int start, int end)
    {
        Console.WriteLine($"Testing Fibonacci Sequence from {start} to {end}:");

        long a = 1;
        long b = 1;
        long result = 0;

        while (a <= end)
        {
            if (a >= start)
                Console.WriteLine($"{result}");
            result = a + b;
            a = b;
            b = result;
        }
    }
}