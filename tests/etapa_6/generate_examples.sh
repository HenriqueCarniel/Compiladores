#!/bin/bash

directory_input="$PWD/tests/etapa_6/examples/src"
directory_output_code="$PWD/tests/etapa_6/examples/assembly"

for file in $directory_input/ex*
do
    if [ -f "$file" ]; then
        id=${file#${directory_input}/ex}
        id=${id%.*}

        assembly_file="$directory_output_code/ex$id.s"

        gcc -S $file -o $assembly_file

    fi
done