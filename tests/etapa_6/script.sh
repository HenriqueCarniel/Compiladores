#!/bin/bash

directory_input="tests/etapa_6/tests/input"
directory_output_code="tests/etapa_6/tests/output"
directory_exe="tests/etapa_6/tests/exe"

for file in $directory_input/test*
do
    if [ -f "$file" ]; then
        id=${file#${directory_input}/test}
        
        assembly_file="$directory_output_code/test$id.s"
        exe_file="$directory_exe/test$id"

        # echo $file
        # echo $assembly_file
        # echo $exe_file

        ./etapa6 < $file > $assembly_file
        gcc $assembly_file -o $exe_file
        ./$exe_file
        echo resultado do teste$id: $?
    fi
done