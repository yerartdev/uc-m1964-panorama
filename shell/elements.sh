#!/bin/bash

echo "Gerardo de Miguel González"
echo "Ejercicios Shell 2: elements.sh"
echo
echo "(1) Descargue el fichero: "
echo "    http://swcarpentry.github.io/shell-novice/data/data-shell.zip"
echo
echo "Descargando ..."

url="http://swcarpentry.github.io/shell-novice/data/data-shell.zip"
wget -q ${url}
ls -l $(basename ${url})

echo "OK"
echo
echo "(2) Descomprimalo ..."

unzip -q $(basename ${url})
ls -l $(basename -s .zip ${url})

echo "OK"
echo
echo "(3) Lea los ficheros XML en el directorio data/elements y los copie"
echo "    en otro (nuevo) directorio llamado 'elements_by_atomic_number'"
echo "    de forma que los nombres de los ficheros sean del tipo: "
echo "    008_Oxigen.xml, i.e [atomic numer]_[element].xml"
echo
echo "::GMG::Creamos el directorio"

destino="elements_by_atomic_number"
mkdir -v ${destino}

read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "::GMG::Hacemos la tarea ..."

origen="$(basename -s .zip ${url})/data/elements"

for fichero in ${origen}/*.xml
do
   numero_atomico="$(cat ${fichero} |grep '<atomic-number' | cut -f2 -d'>'|cut -f1 -d'<')"
   elemento=$(cat ${fichero} | grep name | cut -d'"' -f2)
   cp -v ${fichero} ${destino}/${numero_atomico}_${elemento}.xml
done

echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo
echo "::GMG::Resultado:"
echo

ls ${destino} | head -5 

echo "[...]"
echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."
echo "(4) Que cambie los permisos de estos ficheros para que sean "
echo "    editables por el grupo y para que no los pueda ver ni editar "
echo "    el resto de usuarios."
echo

echo "::GMG::Ejemplo estado acual:"
ls -l ${destino} | head -5
echo "[...]"

echo
echo "::GMG::Cambio a rw-rw----"
chmod 660 ${destino}/*.xml

echo
echo "::GMG::Resultado:"
ls -l ${destino} | head -5
echo "[...]"
echo
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."

echo
echo "(5) cree un fichero tar.gz con estos ficheros y elimine los "
echo "    ficheros y directorios intermedios"
echo
echo "::GMG::Comprimimos ..."

tar -czf ${destino}.tar.gz ${destino}/
ls -l ${destino}.*
read -n 1 -s -r -p "::GMG::Pulse una tecla para continuar ..."

echo
echo "::GMG::Limpiamos ..."
rm -Rf ${destino} $(basename ${url}) $(basename -s .zip ${url})
ls -l

echo
echo "Fin" 
