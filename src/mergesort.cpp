template <class T>
void Merge(T* &vector, int ini, int pivot, int fin){
  int size = fin-ini+1;
  int f_count = 0, s_count = 0;
  T selected;
  T* aux = new T[size];

  for (int i=0; i<size; ++i){
    if(ini+f_count == pivot){
      selected = vector[pivot+s_count];
      s_count++;
    }
    else if(s_count+pivot == fin+1){
      selected = vector[ini+f_count];
      f_count++;
    }
    else{
      if(vector[ini+f_count] <= vector[pivot+s_count]){
        selected = vector[ini+f_count];
        f_count++;
      }
      else{
        selected = vector[pivot+s_count];
        s_count++;
      }
    }
    aux[i] = selected;
  }
  for (int i=0; i<size; ++i){
    vector[ini+i] = aux[i];
  }
  delete[] aux;
}

template <class T>
void MergeSortLims(T* &vector, int ini, int fin){
  int size = fin - ini + 1;
  if(size == 2){
    if(vector[fin]<vector[ini]){
      T aux = vector[ini];
      vector[ini] = vector[fin];
      vector[fin] = aux;
    }
  }
  else if(size > 2){
    int division = (ini+fin)/2;
    MergeSortLims(vector, ini, division);
    MergeSortLims(vector, division+1, fin);
    Merge(vector, ini, division+1, fin);
  }
}

template <class T>
void MergeSort(T* &vector,int size){
  MergeSortLims(vector, 0, size-1);
}
