#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct{
    int ano;
    int mes;
    int dia;
} Data;

typedef struct{
    int id;
    char marca[100];
    char modelo[100];
    int ano;
    char categoria[100];
    char combustivel[3][50];
    int numCombustivel;
    int cilindros;
    double cilindrada;
    char transmissao[50];
    char tracao[50];
    double consumoCidade;
    double consumoEstrada;
    double co2;
    bool turbo;
    Data dataRegistro;
} Veiculo;

Data parseData(char *s){

    Data data;
    sscanf(s, "%d-%d-%d", &data.ano, &data.mes, &data.dia);
    return data;
}

void formatData(Data data, char *resultado){

    sprintf(resultado, "%02d/%02d/%04d", data.dia, data.mes, data.ano);
}

Veiculo *parseVeiculo(char *s){

    Veiculo *carro = (Veiculo *)malloc(sizeof(Veiculo));
    if (carro == NULL) return NULL;

    char *dados;

    dados = strtok(s, ",");
    sscanf(dados, "%d", &carro -> id);

    dados = strtok(NULL, ",");
    sprintf(carro -> marca, "%s", dados);

    dados = strtok(NULL, ",");
    sprintf(carro -> modelo, "%s", dados);

    dados = strtok(NULL, ",");
    sscanf(dados, "%d", &carro -> ano);

    dados = strtok(NULL, ",");
    sprintf(carro -> categoria, "%s", dados);

    dados = strtok(NULL, ",");
    char combTemp[100];
    sprintf(combTemp, "%s", dados);

    dados = strtok(NULL, ",");
    sscanf(dados, "%d", &carro -> cilindros);

    dados = strtok(NULL, ",");
    sscanf(dados, "%lf", &carro -> cilindrada);

    dados = strtok(NULL, ",");
    sprintf(carro -> transmissao, "%s", dados);

    dados = strtok(NULL, ",");
    sprintf(carro -> tracao, "%s", dados);

    dados = strtok(NULL, ",");
    sscanf(dados, "%lf", &carro -> consumoCidade);

    dados = strtok(NULL, ",");
    sscanf(dados, "%lf", &carro -> consumoEstrada);

    dados = strtok(NULL, ",");
    sscanf(dados, "%lf", &carro -> co2);

    dados = strtok(NULL, ",");
    if (strcmp(dados, "true") == 0){
        carro -> turbo = true;
    }
    else{
        carro -> turbo = false;
    }

    dados = strtok(NULL, ",");
    dados[10] = '\0';

    carro -> dataRegistro = parseData(dados);

    char *partes = strtok(combTemp, ";");
    carro -> numCombustivel = 0;

    while (partes != NULL){
          sprintf(carro -> combustivel[carro -> numCombustivel], "%s", partes);
          carro -> numCombustivel++;
          partes = strtok(NULL, ";");
    }

    return carro; 
}

void formatVeiculo(Veiculo* carro, char* resultado) {

    char data[20];
    formatData(carro -> dataRegistro, data);

    char combustivel[200];
    int pos = 0;
    
    sprintf(combustivel + pos, "[");
    pos ++;

    for (int i = 0; i < carro -> numCombustivel; i++) {
        if (i > 0) {
            pos += sprintf(combustivel + pos, ",%s", carro -> combustivel[i]);
        } else {
            pos += sprintf(combustivel + pos, "%s", carro -> combustivel[i]);
        }
    }
    pos += sprintf(combustivel + pos, "]");

    char turbo[10];
    if (carro -> turbo) {
        sprintf(turbo, "true");
        } else {
        sprintf(turbo, "false");
        }

    sprintf(resultado, "[%d ## %s ## %s ## %d ## %s ## %s ## %d ## %.1lf ## %s ## %s ## %.2lf ## %.2lf ## %.1lf ## %s ## %s]", carro -> id, carro -> marca,carro -> modelo, carro -> ano, carro -> categoria, combustivel, carro -> cilindros, carro -> cilindrada, carro -> transmissao, carro -> tracao, carro -> consumoCidade, carro -> consumoEstrada, carro -> co2, turbo, data);
}

Veiculo* lerCsv(char* caminhoArquivo, int* n) {

    FILE* arquivo = fopen(caminhoArquivo, "r");
    if (arquivo == NULL) {
        return NULL;
    }

    Veiculo* conjunto = (Veiculo*) malloc (500 * sizeof (Veiculo)) ;

    char linha[1024];

    if (fgets(linha, sizeof(linha), arquivo) == NULL) {
        fclose(arquivo);
        free(conjunto);
        return NULL; 
    }

    *n = 0;
    while (fgets(linha, sizeof(linha), arquivo) != NULL) {
        Veiculo* carro = parseVeiculo(linha);
        if (carro != NULL) {
            conjunto[*n] = *carro;
            free(carro);
           (*n)++;
        }
    }

    fclose(arquivo);
    return conjunto;
}

typedef No {
	Veiculo elemento;
	No *esq;
	No *dir;
};

No* novoNo(Veiculo elemento){

	No* novo = (No*) malloc(sizeof(No));
	novo->elemento = elemento;
	novo->esq = NULL;
	novo->dir = NULL;
	return novo;	
}

No* inserir(Veiculo carro, No** i){
	
	if (*i == NULL){
		*i = novoNo(carro);

	}else if (x < (*i)->elemento){
		inserir(carro, &((*i)->esq));

	}else {
		inserir(carro, &((*i)->esq));
	}
}

void pesquisar(char modelo[], No* raiz){

	if (raiz != NULL){
		printf("raiz ");
	}

	bool res = pesquisarRec(modelo, raiz);

	if(res){
		printf("SIM");
	} else {
		printf("NAO");
	}
}

bool pesquisarRec (char modelo[], No* i){
		
	bool resp;

	if (i == NULL){
		resp = false;

	}else if (strcmp(modelo, i->elemento->modelo) == 0){
		resp = true;

	}else if (strcmp(modelo, i->elemento->modelo) < 0){

		printf("esq");
		resp = pesquisarRec(modelo, i->esq);

	}else{
		printf("dir");
		resp = pesquisarRec(modelo, i->dir);
	}

	return resp;
}

void emOrdem(No *i){

	if (i != NULL){
		
		char res[2048];
		emOrdem(i->esq);
		formatVeiculo(&i->elemento, res);
	        printf ("%s\n", res);
		emOrdem(i->dir);
	}
}
 
int main() {
    
    int totalVeiculos = 0;
    Veiculo* veiculos = lerCsv("/tmp/veiculos.csv", &totalVeiculos); 
    Veiculo consumoEstrada [100];
    int qtdConsumo = 0; 	
    No* raiz = NULL;

    int entrada;
    scanf("%d", entrada);
   
    while (entrada != -1){
	
        for (int i = 0; i < totalVeiculos; i++) {
            if (veiculos[i].id == entrada) {
		inserir(veiculos[i], raiz);
            }
        }

	scanf("%d", entrada);
    }
	
    char modelo[100];
    fgets(modelo, 100, stdin);

    while (strcmp(modelo, "FIM") != 0){
    	
	pesquisar()
    }

    emOrdem();
    free(veiculos);
}
