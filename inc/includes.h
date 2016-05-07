template <class T>
void Swap(T &i, T &j){
  T aux = i;
  i = j;
  j = aux;
}

#include "../src/radixsortlsd.cpp"
#include "../src/radixsortmsd.cpp"
#include "../src/mergesort.cpp"
#include "../src/bitonicsort.cpp"
#include "../src/insertion.cpp"
#include "../src/slowsort.cpp"
#include "../src/selection.cpp"
#include "../src/heapsort.cpp"
#include "../src/quicksort.cpp"
#include "../src/bubblesort.cpp"
#include "../src/permutationsort.cpp"
#include "../src/countingsort.cpp"
#include "../src/mediumsort.cpp"
