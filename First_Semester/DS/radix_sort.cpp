#include <iostream>
using namespace std;
// get the max number from an array
int getMax(int arr[], int n) {
    int max = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}
// Using counting sort to sort the elements
void countingSort(int arr[], int n, int place) {
    int output[n];
    int count[10] = {0};
    for (int i = 0; i < n; i++) {
        int index = arr[i] / place;
        count[index % 10]++;
    }
    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        int index = arr[i] / place;
        output[count[index % 10] - 1] = arr[i];
        count[index % 10]--;
    }
    for (int i = 0; i < n; i++) {
        arr[i] = output[i];
    }
}
// Radix Sort
void radixSort(int arr[], int n) {
    int max_element = getMax(arr, n);
    for (int place = 1; max_element / place > 0; place *= 10) {
        countingSort(arr, n, place);
    }
}
int main() {
    int n;
    cout << "Enter the number of elements: ";
    cin >> n;
    int arr[n];
    cout << "Enter the elements: ";
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }
    radixSort(arr, n);
    cout << "Sorted array: "; //Assending order
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    return 0;
}
