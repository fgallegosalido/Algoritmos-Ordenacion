template <class T>
void Insertion(T* &vector, int size){
  T aux;
  int j;

  for (int i=1; i<size; i++){
    j=i;
    while(vector[j]<vector[j-1] && j>0){
      aux = vector[j];
      vector[j] = vector[j-1];
      vector[j-1] = aux;
      --j;
    }
  }
}
