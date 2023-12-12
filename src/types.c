#include "types.h"

// Infere tipo a partir de dois nodos
DataType inferTypeFromTypes(DataType t1, DataType t2){
    DataType inferred_type = DATA_TYPE_PLACEHOLDER;
    if(t1 == DATA_TYPE_INT){
        switch(t2){
            case DATA_TYPE_INT:     inferred_type = DATA_TYPE_INT;      break;
            case DATA_TYPE_FLOAT:   inferred_type = DATA_TYPE_FLOAT;    break;
            case DATA_TYPE_BOOL:    inferred_type = DATA_TYPE_INT;      break;
            default: printf("Erro: Não foi possível inferir tipos a partir de INT e %d\n", t2); break;
        }
    }

    else if(t1 == DATA_TYPE_FLOAT){
           switch(t2){
            case DATA_TYPE_INT:     inferred_type = DATA_TYPE_FLOAT;    break;
            case DATA_TYPE_FLOAT:   inferred_type = DATA_TYPE_FLOAT;    break;
            case DATA_TYPE_BOOL:    inferred_type = DATA_TYPE_FLOAT;    break;
            default: printf("Erro: Não foi possível inferir tipos a partir de FLOAT e %d\n", t2); break;
        } 
    }

    else if(t1 == DATA_TYPE_BOOL){
        switch(t2){
            case DATA_TYPE_INT:     inferred_type = DATA_TYPE_INT;      break;
            case DATA_TYPE_FLOAT:   inferred_type = DATA_TYPE_FLOAT;    break;
            case DATA_TYPE_BOOL:    inferred_type = DATA_TYPE_BOOL;     break;
            default: printf("Erro: Não foi possível inferir tipos a partir de BOOL e %d\n", t2); break;
        }
    }
    else{
        printf("Erro: Não foi possível inferir tipos a partir de %d e %d\n", t1, t2);
    }

    return inferred_type;

}