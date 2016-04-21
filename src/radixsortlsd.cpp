#include <queue>

template <class T>
void RadixSortLSD(T* &vector, int size){
  std::queue<T> ones, zeros;
  int bit = 1, offset;

  for (int i=0; i<sizeof(T)*8; i++){
    for(int j=0; j<size; j++){
      ((vector[j] & (bit<<i)) == 0) ? ones.push(vector[j]) : zeros.push(vector[j]);
    }
    offset = 0;
    while(!ones.empty()){
      vector[offset] = ones.front();
      ones.pop();
      offset++;
    }
    while(!zeros.empty()){
      vector[offset] = zeros.front();
      zeros.pop();
      offset++;
    }
  }
}
