#include <stdio.h>
#include <string.h>

typedef struct {
	
	char nome[100];
	int faltas;
	int final;

}Alunos;

void quickParcial(int esq, int dir, int k, Alunos* vetor){

	 int i = esq; 
	 int j = dir;
	 Alunos pivo = vetor[(esq + dir) / 2];

	 while (i <= j){
	 
	 	while (vetor[i].final > pivo.final || (vetor[i].final == pivo.final && vetor[i].faltas < pivo.faltas) || (vetor[i].final == pivo.final && vetor[i].faltas == pivo.faltas && strcmp(vetor[i].nome, pivo.nome) < 0)){
			i++;
		}
		while (vetor[j].final < pivo.final || (vetor[j].final == pivo.final && vetor[j].faltas > pivo.faltas) || (vetor[j].final == pivo.final && vetor[j].faltas == pivo.faltas && strcmp(vetor[j].nome, pivo.nome) > 0)){
			j--;
		}

		if ( i <= j) {
		
			Alunos tmp = vetor[i];
			vetor[i] = vetor[j];
			vetor[j] = tmp;
			i++;
			j--;
		}
	 
	 }

	 if (j > esq ){

		quickParcial (esq, j, k, vetor);
	 }

	 if (i < k && i < dir){

		quickParcial (i, dir, k, vetor);
	 }
}

int main(){

	int n, k;

	while (scanf("%d %d", &n, &k) != EOF){

		Alunos vetor[n];
		for (int i = 0; i < n; i++){

			scanf("%d %d %[^\n]", &vetor[i].final, &vetor[i].faltas, vetor[i].nome);
		}

		quickParcial (0, n - 1, k, vetor);

		for (int i = 0; i < k; i++){

			printf("%d %d %s\n", vetor[i].final, vetor[i].faltas, vetor[i].nome);
		}
	}
}
