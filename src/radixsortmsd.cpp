#include <queue>

template <class T>
void RadixMSDPos(T* &vector, int size, int offset){
  if (size>1 && offset>0){
    std::queue<T> zeros, ones;
    int index, size2;
    T* partition;

    for (int i=0; i<size; ++i){
      ((vector[i] & (1<<offset-1)) == 0) ? zeros.push(vector[i]) : ones.push(vector[i]);
    }
    index = 0;
    while(!zeros.empty()){
      vector[index] = zeros.front();
      zeros.pop();
      index++;
    }
    size2 = index;
    RadixMSDPos(vector, size2, offset-1);
    partition = &(vector[size2]);
    while(!ones.empty()){
      vector[index] = ones.front();
      ones.pop();
      index++;
    }
    RadixMSDPos(partition, size-size2, offset-1);
  }
}

template <class T>
void RadixSortMSD(T* &vector, int size){
  RadixMSDPos(vector, size, sizeof(T)*8);
}
