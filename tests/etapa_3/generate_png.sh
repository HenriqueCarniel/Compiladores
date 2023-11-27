./etapa3 < tests/etapa_3/input/w$1 > tests/etapa_3/output/saida
./output2dot.sh < tests/etapa_3/output/saida > tests/etapa_3/output/saida.dot
dot -Tpng tests/etapa_3/output/saida.dot -o tests/etapa_3/output/saida.png