#include <stdio.h>
#include <string.h>

typedef struct{

    int premios;
    int ano;
    char titulo[100];

} Filme;

int comparacao(Filme a, Filme b){

    if (a.premios != b.premios){

        return a.premios > b.premios;
    }

    if (a.ano != b.ano){

        return a.ano < b.ano;
    }

    return strcmp(a.titulo, b.titulo) < 0;
    

}
void heapParcial(Filme *vetor, int n, int k){

    Filme vetorTmp[n + 1];

    for (int i = 0; i < n; i++){

        vetorTmp[i + 1] = vetor[i];
    }

    for (int tam = 2; tam <= k; tam++){

        construir(vetorTmp, tam);
    }

    for (int i = k + 1; i <= n; i++){

        if (comparacao(vetorTmp[i], vetorTmp[1])){
            
            Filme tmp;
            tmp = vetorTmp[i];
            vetorTmp[i] = vetorTmp[1];
            vetorTmp[1] = tmp;
            reconstruir(vetorTmp, k);
        }
    }

    int tam = k;

    while (tam > 1){

        Filme tmp;
        tmp = vetorTmp[1];
        vetorTmp[1] = vetorTmp[tam];
        vetorTmp[tam--] = tmp;
        reconstruir (vetorTmp, tam);
    }

    for (int i = 0; i < n; i++){

        vetor[i] = vetorTmp[i + 1];
    }
}

int getMaiorFilho(Filme* vetor, int i, int tam){

    int filho;
    if (2*i == tam || comparacao(vetor[2*i + 1], vetor[2*i])){

        filho = 2*i;
    } else {

        filho = 2*i + 1;
    }
    return filho;
}   

void reconstruir(Filme* vetor, int tam) {

    int i = 1;
    while (i <= (tam/2)){

        int filho = getMaiorFilho(vetor, i, tam);
        if (comparacao(vetor[i], vetor[filho])){

            Filme tmp;
            tmp = vetor[i];
            vetor[i] = vetor[filho];
            vetor[filho] = tmp;
            i = filho;
        } else {
            i = tam;
        }
    }

}
 
void construir(Filme *vetor, int tam) {

    for (int i = tam; i > 1 && comparacao(vetor[i/2], vetor[i]); i /= 2){

        Filme tmp;
        tmp = vetor[i];
        vetor[i] = vetor[i/2];
        vetor[i/2] = tmp;
    }
}

int main(){

    int n, k;

    while (scanf("%d %d", &n, &k) != EOF){

        Filme vetor[n];

        for (int i = 0; i < n; i++){

            scanf("%d %d %[^\n]", &vetor[i].premios, &vetor[i].ano, vetor[i].titulo);
        }

        heapParcial(vetor, n, k);

        for (int i = 0; i < k; i++){

            printf("%d %d %s\n", vetor[i].premios, vetor[i].ano, vetor[i].titulo);
        }
    }
}