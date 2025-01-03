#include <iostream>
#include <vector>
using namespace std;

// Function to get the maximum value in the array
int getMax(const vector<int>& arr) {
    int mx = arr[0];
    for (int i = 1; i < arr.size(); i++)
        if (arr[i] > mx)
            mx = arr[i];
    return mx;
}

// Count sort of arr[] according to the digit represented by exp.
void countSort(vector<int>& arr, int exp) {
    vector<int> output(arr.size());
    int i, count[10] = {0};

    // Store count of occurrences in count[]
    for (i = 0; i < arr.size(); i++)
        count[(arr[i] / exp) % 10]++;

    // Change count[i] so that count[i] now contains actual
    // position of this digit in output[]
    for (i = 1; i < 10; i++)
        count[i] += count[i - 1];

    // Build the output array
    for (i = arr.size() - 1; i >= 0; i--) {
        output[count[(arr[i] / exp) % 10] - 1] = arr[i];
        count[(arr[i] / exp) % 10]--;
    }

    // Copy the output array to arr[], so that arr[] now
    // contains sorted numbers according to current digit
    for (i = 0; i < arr.size(); i++)
        arr[i] = output[i];
}

// The main function to that sorts arr[] of size n using Radix Sort
void radixSort(vector<int>& arr) {
    // Find the maximum number to know the number of digits
    int m = getMax(arr);

    // Do counting sort for every digit. Note that instead
    // of passing digit number, exp is passed. exp is 10^i
    // where i is current digit number
    for (int exp = 1; m / exp > 0; exp *= 10)
        countSort(arr, exp);
}

// A utility function to print an array
void print(const vector<int>& arr) {
    for (int i = 0; i < arr.size(); i++)
        cout << arr[i] << " ";
    cout << endl;
}

// Driver code
int main() {
    vector<int> arr;
    int n, input;
    
    cout << "Enter number of elements: ";
    cin >> n;
    
    cout << "Enter " << n << " integers:" << endl;
    for (int i = 0; i < n; i++) {
        cin >> input;
        arr.push_back(input);
    }
    
    radixSort(arr);
    cout << "Sorted array: ";
    print(arr);
    
    return 0;
}
