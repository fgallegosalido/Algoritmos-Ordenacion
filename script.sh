#!/bin/bash

if ! type g++ &> /dev/null; then
  echo "No tienes instalado g++"
  echo "Instálalo usando el comando 'sudo apt-get install g++'"
  exit 1
fi

if ! type gnuplot &> /dev/null; then
  echo "No tienes instalado gnuplot"
  echo "Instálalo usando el comando 'sudo apt-get install gnuplot'"
  exit 1
fi

compiler="g++"
flags="-g -O2 -std=c++11"
plotter="gnuplot"
gnu_dir="binaries/gnuplot"

really_slow=("slowsort")
slow=("insertion" "selection")
fast=("radixsortlsd" "radixsortmsd" "mergesort" "bitonicsort")

_compile(){
  rm -rf binaries
  mkdir -p binaries/{gnuplot,print} 2> /dev/null

  for SRC in `ls src/`; do
    print_bin=$(echo $SRC | cut -d"." -f1)
    gnuplot_bin="$print_bin-gnuplot"
    macro=$(echo $print_bin | tr '[:lower:]' '[:upper:]')

    printf "Compilando %s..." "$SRC"
    $compiler $flags -D PRINT -D $macro main.cpp -o binaries/print/$print_bin
    $compiler $flags -D $macro main.cpp -o $gnu_dir/$gnuplot_bin
    printf " [OK]\n"
  done
}

_data(){
  rm -rf data
  if [ ! -d binaries ]; then
    _compile
  fi

  mkdir data 2> /dev/null

  for BIN in "${really_slow[@]}"; do
    printf "Ejecutando %s... (Puede tardar un rato)" "$BIN"

    for NUM in `seq 10 10 300`; do
      ./$gnu_dir/$BIN-gnuplot $NUM >> data/$BIN.dat
    done
    printf " [OK]\n"
  done

  for BIN in "${slow[@]}"; do
    printf "Ejecutando %s... (Puede tardar un rato)" "$BIN"

    for NUM in `seq 1000 1000 50000`; do
      ./$gnu_dir/$BIN-gnuplot $NUM >> data/$BIN.dat
    done
    printf " [OK]\n"
  done

  for BIN in "${fast[@]}"; do
    printf "Ejecutando %s... (puede tardar un rato)" "$BIN"

    for NUM in `seq 100000 100000 10000000`; do
      ./$gnu_dir/$BIN-gnuplot $NUM >> data/$BIN.dat
    done
    printf " [OK]\n"
  done
}

_graphs(){
  rm -rf graphs/separate
  if [ ! -d data ]; then
    _data
  fi

  mkdir -p graphs/separate 2> /dev/null
  archivo="temporal.gp"

  for DATA in `ls data/`; do
    label=$(echo $DATA | cut -d"." -f1)
    printf "Creando gráfica de %s..." "$label"

    echo "set terminal jpeg size 800,600" > $archivo
    echo "set output \"graphs/separate/$label.jpeg\"" >> $archivo
    echo "set xlabel \"Size\"" >> $archivo
    echo "set ylabel \"Time (s)\"" >> $archivo
    echo "set key tmargin" >> $archivo
    echo "plot \"data/$DATA\" with linespoints title \"$label\"" >> $archivo

    $plotter temporal.gp
    printf " [OK]\n"
  done
  rm temporal.gp
}

_partial_graphs(){
  if [ ! -d data ]; then
    _data
  fi

  printf "Creando gráficas parciales..."

  mkdir -p graphs/comparative 2> /dev/null
  archivo="temporal.gp"

  echo "set terminal jpeg size 800,600" > $archivo
  echo "set xlabel \"Size\"" >> $archivo
  echo "set ylabel \"Time (s)\"" >> $archivo
  echo "set key tmargin" >> $archivo
  echo "set output \"graphs/comparative/really_slow.jpeg\"" >> $archivo
  printf "plot" >> $archivo

  for DATA in "${really_slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $archivo
  done

  printf "\n" >> $archivo
  echo "set output \"graphs/comparative/slow.jpeg\"" >> $archivo
  printf "plot" >> $archivo

  for DATA in "${slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $archivo
  done

  printf "\n" >> $archivo
  echo "set output \"graphs/comparative/fast.jpeg\"" >> $archivo
  printf "plot" >> $archivo

  for DATA in "${fast[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $archivo
  done

  sed -i 's/plot,/plot/g' $archivo

  $plotter temporal.gp
  rm temporal.gp
  printf " [OK]\n"
}

_full_graph(){
  if [ ! -d data ]; then
    _data
  fi

  printf "Creando gráfica comparativa..."

  mkdir -p graphs/comparative 2> /dev/null
  count=0
  archivo=temporal.gp

  for FILE in `ls data/`; do
    array[count]=$FILE
    let count=count+1
  done

  echo "set terminal jpeg size 800,600" > $archivo
  echo "set output \"graphs/comparative/comparativa.jpeg\"" >> $archivo
  echo "set xlabel \"Size\"" >> $archivo
  echo "set ylabel \"Time (s)\"" >> $archivo
  echo "set key tmargin" >> $archivo
  printf "plot" >> $archivo

  for DATA in `ls data/`; do
    label=$(echo $DATA | cut -d"." -f1)
    printf ", \"data/$DATA\" with lines title \"$label\"" >> $archivo
  done

  sed -i 's/plot,/plot/' $archivo

  $plotter temporal.gp
  rm temporal.gp
  printf " [OK]\n"
}

_help(){
  echo "Uso: ./script.sh <option>"
  echo "  --all: Genera todos los archivos (hace --mrproper, --compile, --data, --graphs y --compare)"
  echo "  --clean: Borra los datos de gnuplot y los binarios que los generan"
  echo "  --mrproper: Borra los datos de gnuplot, todos los binarios y todas las gráficas"
  echo "  --compile: Compila los programas"
  echo "  --data: Genera los datos (se compilarán los programas si estos no existen)"
  echo "  --graphs: Genera las gráficas de cada algoritmo a partir de los datos (se generan los datos si estos no existen)"
  echo "  --compare: Genera las gráficas de las comparativas (tanto la total como la separada según velocidad; genera datos si no existen)"
  echo "  --help: Muestra esta ayuda"
  echo "  Si no hay argumentos o más de uno, devolverá un error, mostrará esta ayuda y acabará"
}

if [ $# -eq 1 ]; then
  if [ "$1" == "--clean" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf data binaries/gnuplot
  elif [ "$1" == "--mrproper" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf data graphs binaries
  elif [ "$1" == "--compile" ]; then
    _compile
  elif [ "$1" == "--data" ]; then
    _data
  elif [ "$1" == "--graphs" ]; then
    _graphs
  elif [ "$1" == "--compare" ]; then
    _partial_graphs
    _full_graph
  elif [ "$1" == "--help" ]; then
    _help
  elif [ "$1" == "--all" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf data binaries graphs
    _compile
    _data
    _graphs
    _partial_graphs
    _full_graph
  else
    echo "Error: Argumento incorrecto"
    _help
  fi
else
  echo "Error: Número de argumentos incorrecto"
  _help
fi
