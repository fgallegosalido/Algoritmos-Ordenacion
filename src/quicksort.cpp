template <class T>
int SelectPivot(T* &vector, int ini, int fin){
  if (fin-ini > 0){
    return (vector[ini]<vector[ini+1]) ? ini+1 : ini;
  }
  else{
    return ini;
  }
}

template <class T>
int Divide(T* &vector, int ini, int fin){
  int pivot = SelectPivot(vector, ini, ini+1);
  int left = pivot+1, right = fin;

  while(left < right){
    if (vector[left]<=vector[pivot] && vector[right]<=vector[pivot]) left++;
    else if (vector[left]>=vector[pivot] && vector[right]>=vector[pivot]) right--;
    else{
      if (vector[left]>=vector[pivot] && vector[right]<=vector[pivot])
        Swap(vector[right], vector[left]);
      left++;
      right--;
    }
  }

  if (right<left || vector[right]<vector[pivot]){
    Swap(vector[right], vector[pivot]);
    return right;
  }
  else{
    Swap(vector[right-1], vector[pivot]);
    return right-1;
  }
}

template <class T>
void QuickSortLims(T* &vector, int ini, int fin){
  if (fin-ini == 1){
    if (vector[ini]>vector[fin]) Swap(vector[ini], vector[fin]);
  }
  else if (fin-ini > 1){
    int division = Divide(vector, ini, fin);
    QuickSortLims(vector, ini, division-1);
    QuickSortLims(vector, division+1, fin);
  }
}

template <class T>
void QuickSort(T* &vector, int size){
  QuickSortLims(vector, 0, size-1);
}
