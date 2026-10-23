#include <stdio.h>

typedef struct {
	
	char[100] nome;
	int faltas;
	int final;

}Alunos;

void quickParcial(int esq, int dir, Alunos* vetor){

	 int i = esq; j = dir, meio = (esq + dir) / 2;
	 Alunos pivo = vetor[meio];

	 while (i <= j){
	 
	 	while (vetor[i] < pivo){
			i++;
		}
		while (vetor[i] > pivo){
			j--;
		}

		if ( i <= j) {
		
			Alunos tmp = vetor[i];
			vetor[i] = vetor[j];
			vetor[j] = tmp;
		}
	 
	 }



}
