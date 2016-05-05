template <class T>
void BubbleSort(T* &vector, int size){
  T aux;
  for (int i=0; i<size-1; ++i){
    for (int j=0; j<size-i-1; ++j){
      if (vector[j]>vector[j+1]){
        Swap(vector[j], vector[j+1]);
      }
    }
  }
}
