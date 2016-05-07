template <class T>
void QuickMedium(T* &vector, int ini, int fin);

template <class T>
void SlowMedium(T* &vector, int ini, int fin){
  if (fin > ini){
    int mid = (ini+fin)/2;

    QuickMedium(vector, ini, mid);
    QuickMedium(vector, mid+1, fin);

    if (vector[mid] > vector[fin]){
      Swap(vector[mid], vector[fin]);
    }

    QuickMedium(vector, ini, fin-1);
  }
}

template <class T>
void QuickMedium(T* &vector, int ini, int fin){
  if (fin-ini == 1){
    if (vector[ini]>vector[fin]) Swap(vector[ini], vector[fin]);
  }
  else if (fin-ini > 1){
    int division = Divide(vector, ini, fin);
    SlowMedium(vector, ini, division-1);
    SlowMedium(vector, division+1, fin);
  }
}

template <class T>
void MediumSort(T* &vector, int size){
  if (rand()%2) QuickMedium(vector, 0, size-1);
  else SlowMedium(vector, 0, size-1);
}
