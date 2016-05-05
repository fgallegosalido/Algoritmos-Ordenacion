template <class T>
void Compare(T* &vector, int i, int j, bool dir){
  if (dir == (vector[i] > vector[j])){
    Swap(vector[i], vector[j]);
  }
}

int GreatestPowerOfTwoLessThan(int n){
  int k = 1;
  while (k < n) k <<= 1;

  return k >> 1;
}

template <class T>
void BitonicMerge(T* &vector, int ini, int size, bool dir){
  if (size > 1){
    int mid = GreatestPowerOfTwoLessThan(size);

    for (int i = ini; i < ini+size-mid; i++){
      Compare(vector, i, i+mid, dir);
    }

    BitonicMerge(vector, ini, mid, dir);
    BitonicMerge(vector, ini+mid, size-mid, dir);
  }
}

template <class T>
void BitonicSortLims(T* &vector, int ini, int size, bool dir){
  if (size > 1){
    int mid = size / 2;
    BitonicSortLims(vector, ini, mid, !dir);
    BitonicSortLims(vector, ini+mid, size-mid, dir);
    BitonicMerge(vector, ini, size, dir);
  }
}

template <class T>
void BitonicSort(T* &vector, int size){
  BitonicSortLims(vector, 0, size, true);
}
