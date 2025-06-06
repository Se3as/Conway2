#!/bin/bash

OUTPUT="game"
SRC_DIR="src"
INCLUDE_DIR="include"

SOURCES=$(find "$SRC_DIR" -name '*.cpp')

# Verificaciones
command -v fltk-config >/dev/null 2>&1 || { echo "❌ FLTK no está instalado. Ejecutá: sudo apt install libfltk1.3-dev"; exit 1; }

# Flags
FLTK_FLAGS=$(fltk-config --cxxflags)
FLTK_LIBS=$(fltk-config --ldflags)

# Librerías manuales extra
EXTRA_LIBS="-lfltk_images"
DEBUG_FLAGS="-g -Og"

echo "Compilando con FLTK..."

g++ $SOURCES -I"$INCLUDE_DIR" $FLTK_FLAGS $FLTK_LIBS $EXTRA_LIBS $DEBUG_FLAGS -o $OUTPUT

if [ $? -eq 0 ]; then
    echo "✅ Compilado correctamente: ./$OUTPUT"

    echo
    ./game

else
    echo "❌ Error de compilación"
fi