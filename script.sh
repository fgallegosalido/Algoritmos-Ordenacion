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
temp="temporal.gp"

really_slow=("slowsort")
slow=("insertion" "selection")
fast=("radixsortlsd" "radixsortmsd" "mergesort" "heapsort" "bitonicsort")

_compile(){

  echo "--------------------------------------"
  echo " ***** Compilación de programas *****"
  echo "--------------------------------------"

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

  echo "---------------------------------"
  echo " ***** Generación de datos *****"
  echo "---------------------------------"
  echo "Nota: Se recomienda no tener muchas cosas ejecutando para obtener resultados más limpios"

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
    printf "Ejecutando %s... (Puede tardar un rato)" "$BIN"

    for NUM in `seq 100000 100000 5000000`; do
      ./$gnu_dir/$BIN-gnuplot $NUM >> data/$BIN.dat
    done
    printf " [OK]\n"
  done
}

_init_gnuplot(){
  echo "set terminal jpeg size 800,600" > $temp
  echo "set xlabel \"Size\"" >> $temp
  echo "set ylabel \"Time (s)\"" >> $temp
  echo "set key tmargin" >> $temp
}

_graphs(){
  rm -rf graphs/separate
  if [ ! -d data ]; then
    _data
  fi

  echo "--------------------------------------------"
  echo " ***** Creación de gráficas separadas *****"
  echo "--------------------------------------------"

  mkdir -p graphs/separate 2> /dev/null

  for DATA in `ls data/`; do
    label=$(echo $DATA | cut -d"." -f1)
    printf "Creando gráfica de %s..." "$label"

    _init_gnuplot
    echo "set output \"graphs/separate/$label.jpeg\"" >> $temp
    echo "plot \"data/$DATA\" with linespoints title \"$label\"" >> $temp

    $plotter $temp
    printf " [OK]\n"
  done
  rm $temp
}

_incremental_graphs(){
  if [ ! -d data ]; then
    _data
  fi

  echo "------------------------------------------------"
  echo " ***** Creación de gráficas incrementales *****"
  echo "------------------------------------------------"

  mkdir -p graphs/comparative 2> /dev/null

  _init_gnuplot
  echo "set output \"graphs/comparative/really_slow-slow.jpeg\"" >> $temp
  printf "plot" >> $temp

  printf "Creando gráfica muy lentos-lentos..."
  for DATA in "${really_slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  for DATA in "${slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  printf " [OK]\n"

  printf "\n" >> $temp
  echo "set output \"graphs/comparative/slow-fast.jpeg\"" >> $temp
  printf "plot" >> $temp

  printf "Creando gráfica lentos-rápidos..."
  for DATA in "${slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  for DATA in "${fast[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  printf " [OK]\n"

  sed -i 's/plot,/plot/g' $temp

  $plotter $temp
  rm $temp
}

_comparative_graphs(){
  if [ ! -d data ]; then
    _data
  fi

  echo "-----------------------------------------------"
  echo " ***** Creación de gráficas comparativas *****"
  echo "-----------------------------------------------"

  mkdir -p graphs/comparative 2> /dev/null

  _init_gnuplot
  echo "set output \"graphs/comparative/really_slow.jpeg\"" >> $temp
  printf "plot" >> $temp

  printf "Creando gráfica muy lentos..."
  for DATA in "${really_slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  printf " [OK]\n"

  printf "\n" >> $temp
  echo "set output \"graphs/comparative/slow.jpeg\"" >> $temp
  printf "plot" >> $temp

  printf "Creando gráfica lentos..."
  for DATA in "${slow[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  printf " [OK]\n"

  printf "\n" >> $temp
  echo "set output \"graphs/comparative/fast.jpeg\"" >> $temp
  printf "plot" >> $temp

  printf "Creando gráfica rápidos..."
  for DATA in "${fast[@]}"; do
    printf ", \"data/$DATA.dat\" with linespoints title \"$DATA\"" >> $temp
  done
  printf " [OK]\n"

  sed -i 's/plot,/plot/g' $temp

  $plotter $temp
  rm $temp
}

_full_graph(){
  if [ ! -d data ]; then
    _data
  fi

  echo "-------------------------------------"
  echo " ***** Creación de gráfica total *****"
  echo "-------------------------------------"

  mkdir -p graphs/comparative 2> /dev/null
  count=0

  printf "Creando gráfica total..."
  for FILE in `ls data/`; do
    array[count]=$FILE
    let count=count+1
  done

  _init_gnuplot
  echo "set output \"graphs/comparative/comparativa.jpeg\"" >> $temp
  printf "plot" >> $temp

  for DATA in `ls data/`; do
    label=$(echo $DATA | cut -d"." -f1)
    printf ", \"data/$DATA\" with lines title \"$label\"" >> $temp
  done

  sed -i 's/plot,/plot/' $temp

  $plotter $temp
  rm $temp
  printf " [OK]\n"
}

_compare(){
  if [ ! -d data ]; then
    _data
  fi

  mkdir -p graphs/vs/ 2> /dev/null

  expresion="("
  for DATA in `ls data/`; do
    label=$(echo $DATA | cut -d"." -f1)
    expresion="$expresion$label|"
  done
  expresion=${expresion:0:-1}
  expresion="$expresion)"

  echo "Elige dos entre estos:"
  for DATA in `ls data/`; do
    echo "*) $(echo $DATA | cut -d"." -f1)"
  done
  printf "\n"

  while
    printf "Introduzca el nombre del primer algoritmo (uno válido) --> "
    read ALG1
    [[ ! $ALG1.dat =~ $expresion\.dat ]]
  do
    :
  done

  while
    printf "Introduzca el nombre del segundo algoritmo (uno válido) --> "
    read ALG2
    [[ ! $ALG2.dat =~ $expresion\.dat ]]
  do
    :
  done

  printf "Creando gráfica..."

  _init_gnuplot
  echo "set output \"graphs/vs/$ALG1-$ALG2.jpeg\"" >> $temp
  printf "plot \"data/$ALG1.dat\" with linespoints title \"$ALG1\", \"data/$ALG2.dat\" with linespoints title \"$ALG2\"" >> $temp

  $plotter $temp
  rm $temp
  printf " [OK]\n"
}

_help(){
  echo "Uso: ./script.sh <option>"
  echo "  --all: Genera todos los archivos (hace --mrproper, --compile, --data, --graphs y --comparative)"
  echo "  --clean: Borra los binarios que generan los datos y las gráficas que comparan dos algoritmos"
  echo "  --mrproper: Borra los datos de gnuplot, todos los binarios y todas las gráficas"
  echo "  --compile: Compila los programas"
  echo "  --data: Genera los datos (se compilarán los programas si estos no existen)"
  echo "  --graphs: Genera las gráficas de cada algoritmo a partir de los datos (se generan los datos si estos no existen)"
  echo "  --comparative: Genera las gráficas de las comparativas (tanto la total como la separada según velocidad como la incremental; generan datos si no existen)"
  echo "  --compare: Genera una gráfica comparativa de dos algoritmos (se pedirán los nombres por consola; se generan datos si estos no existen)"
  echo "  --help: Muestra esta ayuda"
  echo "  Si no hay argumentos o más de uno, devolverá un error, mostrará esta ayuda y acabará"
  echo "  Ejecutar el script en el directorio donde está, sino dará error"
}

if [ $# -eq 1 ]; then
  if [ "$1" == "--clean" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf binaries/gnuplot graphs/vs
  elif [ "$1" == "--mrproper" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf data graphs binaries
  elif [ "$1" == "--compile" ]; then
    _compile
  elif [ "$1" == "--data" ]; then
    _data
  elif [ "$1" == "--graphs" ]; then
    _graphs
  elif [ "$1" == "--comparative" ]; then
    _incremental_graphs
    _comparative_graphs
    _full_graph
  elif [ "$1" == "--compare" ]; then
    _compare
  elif [ "$1" == "--help" ]; then
    _help
  elif [ "$1" == "--all" ]; then
    find . -regex ".*~" -exec rm {} \;
    rm -rf data binaries graphs
    _compile
    _data
    _graphs
    _incremental_graphs
    _comparative_graphs
    _full_graph
  else
    echo "Error: Argumento incorrecto"
    _help
  fi
else
  echo "Error: Número de argumentos incorrecto"
  _help
fi
