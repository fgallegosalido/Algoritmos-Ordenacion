template <class T>
void Insertion(T* &vector, int size){
  int j;

  for (int i=1; i<size; ++i){
    j=i;
    while(vector[j]<vector[j-1] && j>0){
      Swap(vector[j], vector[j-1]);
      --j;
    }
  }
}
