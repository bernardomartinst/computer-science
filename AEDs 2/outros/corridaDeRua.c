#include <stdio.h>

typedef struct {

	char nome[100];
	int hora;
	int min;
	int seg;

}Participante;

void insercaoParcial (Participante* vetor, int n, int k){


	for (int i = 1; i < n; i++){
	
		Participante tmp = vetor[i];
		int j;

		if (i < k) {
			j = i - 1;
		} else {
			j = k - 1;
		}

		while (j >= 0 && (vetor[j].hora > tmp.hora || ( vetor[j].hora == tmp.hora && vetor[j].min > tmp.min) || 
				(vetor[j].hora == tmp.hora && vetor[j].min == tmp.min && vetor[j].seg > tmp.seg))){
			
			vetor[j + 1] = vetor[j];
			j--;
		}

		vetor[j + 1] = tmp;		
	}
}


int main() {
	
	int tamanho;
	int k;
	
	while (scanf ("%d %d", &tamanho, &k) != EOF){
	
		Participante vetor[tamanho];

		for (int i = 0; i < tamanho; i++){
		
			scanf("%s %d %d %d", vetor[i].nome, &vetor[i].hora, &vetor[i].min, &vetor[i].seg);
		}

		insercaoParcial(vetor, tamanho, k);

		for (int i = 0; i < k; i++){
		
			printf("%s %d %d %d\n", vetor[i].nome, vetor[i].hora, vetor[i].min, vetor[i].seg);
		}
	}
}
