#!/bin/bash

directory_input="tests/etapa_7/input"
directory_output="tests/etapa_7/output"

for input_file in $directory_input/in*
do
    if [ -f "$input_file" ]; then
        id=${input_file#${directory_input}/in}

        output_file="$directory_output/digraph$id.dot"
        output_png_file="$directory_output/digraph$id.png"

        ./etapa7 < $input_file > $output_file
        dot -Tpng $output_file -o $output_png_file
    fi
done