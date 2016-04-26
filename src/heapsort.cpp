#include <queue>

template <class T>
void HeapSort(T* &vector, int size){
  std::priority_queue<T> heap;

  for (int i=0; i<size; ++i){
    heap.push(vector[i]);
  }
  for (int i=size-1; i>=0; --i){
    vector[i] = heap.top();
    heap.pop();
  }
}
