#include <iostream>
using namespace std;
int main()
{
    int num;
    cout << "Enter the value: ";
    cin >> num;
    int sum = 0;
    for (int i = 1; i <= num; ++i)
    {
        int tempSum = 0;
        for (int j = 1; j <= i; ++j)
        {
            cout << j;
            tempSum += j;
            if (j < i)
            {
                cout << "+";
            }
        }
        sum += tempSum;
        cout << " = " << tempSum << endl;
    }
    cout << "The sum of the above series is: " << sum << endl;
    return 0;
}
