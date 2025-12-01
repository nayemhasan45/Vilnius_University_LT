#include <iostream>
#include <vector>
using namespace std;

int main() {
    int size;
    cout << "Enter the size of the array: ";
    cin >> size;
    vector<int> myArray(size);
    // Input elements for the array
    cout << "Enter " << size << " integers for the array:" <<endl;
    for (int i = 0; i < size; ++i) {
        cin >> myArray[i];
    }
    //create a new array
    int newSize=size/2;
    vector<int> secArray(newSize);

    // Create the second array
    for (int i = 0; i < newSize; i++) {
        secArray[i] = myArray[i] + myArray[size - i - 1];
    }

    // Print the array
    cout << "Array elements are: ";
    for (int i = 0; i < newSize; i++) {
        cout << secArray[i] << " ";
    }
    cout << endl;
    return 0;
}
