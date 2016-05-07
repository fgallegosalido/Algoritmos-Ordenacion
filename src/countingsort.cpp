template <class T>
void CountingSort(T* &vector, int size){
  int min=0, max=0;

  for (int i=1; i<size; ++i){
    min = (vector[min]<vector[i])?min:i;
    max = (vector[max]>vector[i])?max:i;
  }
  if (min==max) return;

  T aux_size = vector[max]-vector[min]+1;
  int* aux = new int[aux_size];

  for (int i=0; i<size; ++i)
    aux[vector[i]-vector[min]]++;

  int count = 0;

  for (int i=0; i<aux_size; ++i){
    for (int j=0; j<aux[i]; ++j){
      vector[count] = i;
      ++count;
    }
  }
}
