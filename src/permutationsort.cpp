template <class T>
bool IsInOrder(T* &array, int size){
  bool is_ordered = true;
  while (is_ordered && size-1>0){
    is_ordered = array[size-1] >= array[size-2];
    --size;
  }
  return is_ordered;
}

template <class T>
void GeneratePermutations(T* &vector, int size, int start){
  if (size-start>1){
    for (int i=0; i<size-start; ++i){
      Swap(vector[start], vector[start+i]);
      GeneratePermutations(vector, size, start+1);
      if (IsInOrder(vector, size))  break;
      Swap(vector[start], vector[start+i]);
    }
  }
}

template <class T>
void PermutationSort(T* &vector, int size){
  GeneratePermutations(vector, size, 0);
}
