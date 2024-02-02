#!/bin/bash

directory_input="$PWD/tests/etapa_5/input"
directory_output_code="$PWD/tests/etapa_5/output_code"
directory_output_info="$PWD/tests/etapa_5/output_info"

for file in $directory_input/test*
do
    if [ -f "$file" ]; then
        id=${file#${directory_input}/test}

        file_code="$directory_output_code/out_code$id"
        file_info="$directory_output_info/out_info$id"

        ./etapa5 < $file > $file_code
        python3 ilocsim.py -i -m -s -t $file_code > $file_info
    fi
done