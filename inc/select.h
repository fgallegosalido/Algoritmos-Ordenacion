#ifdef RADIXSORTLSD
CheckTime(&RadixSortLSD, array, n);
#endif
#ifdef RADIXSORTMSD
CheckTime(&RadixSortMSD, array, n);
#endif
#ifdef MERGESORT
CheckTime(&MergeSort, array, n);
#endif
#ifdef INSERTION
CheckTime(&Insertion, array, n);
#endif
#ifdef SLOWSORT
CheckTime(&SlowSort, array, n);
#endif
#ifdef SELECTION
CheckTime(&Selection, array, n);
#endif
#ifdef BITONICSORT
CheckTime(&BitonicSort, array, n);
#endif
#ifdef HEAPSORT
CheckTime(&HeapSort, array, n);
#endif
#ifdef QUICKSORT
CheckTime(&QuickSort, array, n);
#endif
#ifdef BUBBLESORT
CheckTime(&BubbleSort, array, n);
#endif
#ifdef PERMUTATIONSORT
CheckTime(&PermutationSort, array, n);
#endif
#ifdef COUNTINGSORT
CheckTime(&CountingSort, array, n);
#endif
