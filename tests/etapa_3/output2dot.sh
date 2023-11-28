#!/usr/bin/bash
##
## output2dot.sh
##
## Este script converte o formato de saída
## da E3 para o formato DOT. Ele lê da
## entrada padrão e escreve na saída padrão.
## Portanto, seu uso se dá da seguinte
## forma, assumindo o desejo de visualizar
## com a ferramenta xdot (não esqueça do "-"):
##
## ./etapa3 | ./output2dot.sh | xdot -
##
## Caso houver o desejo de salvar o DOT:
##
## ./etapa3 | ./output2dot.sh > saida.dot
##
## Caso a entrada esteja em entrada.txt e
## há o desejo de salvar a saída em arquivo
##
## ./output2dot.sh < entrada.txt > saida.dot
##
##

# forçar o bash encerrar em situações de erro
set -e # quando um comando dá erro
set -u # quando uma variável não inicializada é lida

# Informar os argumentos e outras informações
echo "# Executado assim: $0 $@"
echo "# https://graphviz.org/doc/info/lang.html"

# Gerar o cabeçalho do formato DOT, um grafo direcionado
echo "digraph {"

# Ler a entrada linha por linha
while IFS="" read -r line; do
    # verificar se a linha contém um label
    LABEL_PRESENTE=$(echo $line | grep label | wc -l)

    # Se a linha conter um label
    if [[ ${LABEL_PRESENTE} -ne 0 ]]; then
	echo "  $line" | sed -e 's/0x/x/g'
    # Se a linha _não_ conter um label
    else
	echo "  $line" | sed -e 's/0x/x/g' -e 's/,/ ->/'
    fi
done

# Gerar o fechamento do grafo
echo "}"