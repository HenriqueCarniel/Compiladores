#!/bin/bash

directory_input="$PWD/tests/etapa_6/tests/input"
directory_output_code="$PWD/tests/etapa_6/tests/output"

for file in $directory_input/code*
do
    if [ -f "$file" ]; then
        id=${file#${directory_input}/code}
        assembly_file="$directory_output_code/code$id.s"
        #./etapa6 < $file > $assembly_file
    fi
done