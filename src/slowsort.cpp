template <class T>
void Slow(T* &vector, int ini, int fin){
  if (fin > ini){
    int mid = (ini+fin)/2;

    Slow(vector, ini, mid);
    Slow(vector, mid+1, fin);

    if (vector[mid] > vector[fin]){
      T aux = vector[mid];
      vector[mid] = vector[fin];
      vector[fin] = aux;
    }

    Slow(vector, ini, fin-1);
  }
}

template <class T>
void SlowSort(T* &vector, int size){
  Slow(vector, 0, size-1);
}
