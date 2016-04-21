#include <iostream>
#include <cstdlib>
#include <chrono>
#include "inc/includes.h"

template <class T>
void PrintVector(T* vector, int size){
  for (int i=0; i<size; ++i){
    std::cout << vector[i] << " ";
  }
  std::cout << std::endl;
}

template <class T>
void CheckTime(void (*f)(T*&, int), T* &vector, int size){
  std::chrono::high_resolution_clock::time_point tantes, tdespues;
  std::chrono::duration<double> transcurrido;

  tantes = std::chrono::high_resolution_clock::now();
  (*f)(vector, size);
  tdespues = std::chrono::high_resolution_clock::now();

  transcurrido = std::chrono::duration_cast<std::chrono::duration<double>>(tdespues - tantes);

  std::cout << size << " " << transcurrido.count() << std::endl;
}

int main(int argc, char * argv[]){
  if (argc != 2){
    std::cerr << "Formato " << argv[0] << " <num_elem>" << std::endl;
    return -1;
  }

  int n = atoi(argv[1]);
  int range;

#if defined RADIXSORTLSD || defined RADIXSORTMSD
  unsigned short * array = new unsigned short[n];
  range = (n<65536)?n:65536;
#else
  unsigned int * array = new unsigned int[n];
  range = n;
#endif
  srand(time(0));

  for (int i = 0; i < n; i++){
    array[i] = rand()%range;
  }

#ifdef PRINT
  PrintVector(array, n);
#endif

#include "inc/select.h"

#ifdef PRINT
  PrintVector(array, n);
#endif
}
