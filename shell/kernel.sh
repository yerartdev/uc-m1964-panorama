#!/bin/bash

echo "Gerardo de Miguel González"
echo "Ejercicios Shell 1: kernel.sh"
echo
echo "(1) Descargue el kernel de linux más reciente"
echo

url="https://git.kernel.org/torvalds/t/linux-4.19-rc7.tar.gz"

echo "::GMG::Descargando de kernel.org (mainline) 4.19-rc7 ..."
echo

if [ ! -f $(basename ${url}) ]; then
    wget ${url}
else
    echo "::GMG::Ya se ha descargado previamente"
fi

echo
echo "(2) Descomprimalo"
echo
echo "::GMG::Descomprimiendo ..."
echo

if [ ! -d $(basename -s .tar.gz ${url}) ]; then
    tar -xzf $(basename ${url})
else
    echo "::GMG::Ya se ha descomprimido previamente"
    echo 
fi

du -sh $(basename -s .tar.gz ${url})
ls $(basename -s .tar.gz ${url})

echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "(3) localice todos los scripts de python que contiene el kernel"
echo
echo "::GMG::Buscando ..."

find $(basename -s .tar.gz ${url}) -type f -name *.py > python-scripts.txt

echo "OK"
echo
echo "::GMG::Ver en fichero python-scripts.txt ..."
echo
echo "Hay $(cat python-scripts.txt |wc -l) ficheros"

cat python-scripts.txt|head

echo "[...]"
echo

read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."

echo
echo "(4) localice aquellos que usan la librería datetime"
echo
echo "::GMG::Buscando ..."

find $(basename -s .tar.gz ${url}) -type f -name *.py \
     -exec grep -l "import datetime" {} \; > python-scripts-datetime.txt

echo "OK"
echo
echo "::GMG::Ver en fichero python-scripts-datetime.txt ..."

cat python-scripts-datetime.txt

echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo

echo "(5) cual es la script de mayor tamaño de los anteriores"
echo
echo "::GMG::Buscando ..."
find $(basename -s .tar.gz ${url}) -type f -name *.py \
     -exec grep -l "import datetime" {} \; \
     -printf "%s  %f %p\n"|sort -nr|head -1

echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "(6) muestre únicamente las funciones y clases (con sus métodos) "
echo "    que define"
echo
echo "::GMG::Detectamos las clases por su definición en Python"
echo "       con el kewyword 'class'"
echo

awk '/^class/' linux-4.19-rc7/tools/power/pm-graph/sleepgraph.py|cut -d' ' -f2|tr -d ':'

echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "::GMG::Identificamos los métodos de las clases porque son funciones"
echo "       definidas en Python con el keyword 'def' y además deben estar"
echo "       identadas con un tabulador"
echo

awk '/^\tdef/' linux-4.19-rc7/tools/power/pm-graph/sleepgraph.py|head -5

echo "[...]"
echo
echo "::GMG:: Hay $(awk '/^\tdef/' linux-4.19-rc7/tools/power/pm-graph/sleepgraph.py|wc -l) métodos repartidos en las diferentes clases"
echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "::GMG::Finalmente las funciones independientes están definidas"
echo "       también con 'def' pero sin tabulación"
echo

awk '/^def/' linux-4.19-rc7/tools/power/pm-graph/sleepgraph.py|head -10

echo "[...]"
echo
echo "::GMG::Son un total de $(awk '/^def/' linux-4.19-rc7/tools/power/pm-graph/sleepgraph.py|wc -l)"
echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo

echo "(7) ¿cuál es el nombre de el único script del kernel que "
echo "    hace uso de estas funciones?"
echo
echo "::GMG::Por definición será el que hace un import de ese módulo:"
echo "       import sleepgraph"
echo
echo "::GMG::Buscando ..."

unico=$(find $(basename -s .tar.gz ${url}) -type f -name *.py \
     -exec grep -l "sleepgraph" {} \;) 

echo $(basename ${unico})
echo
echo "::GMG::Hace un \"$(cat ${unico}|grep 'import sleepgraph')\""
echo
echo "Fin"
