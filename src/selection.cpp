template <class T>
void Selection(T* &vector, int size){
  int min;
  
  for (int i=0; i<size-1; ++i){
    min = i;
    for (int j=i+1; j<size; ++j){
      if (vector[min]>vector[j]){
        min = j;
      }
    }
    if (min != i){
      Swap(vector[i], vector[min]);
    }
  }
}
