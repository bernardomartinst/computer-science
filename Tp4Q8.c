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

typedef struct No {
	Veiculo elemento;
	struct No *esq;
	struct No *dir;
    	bool cor;
}No;

No* novoNo(Veiculo elemento);
void inserir(Veiculo carro, No** raiz);
void inserirRec(Veiculo carro, No* bisavo, No* avo, No* pai, No* i, No** raiz);
void balancear(No* bisavo, No* avo, No* pai, No* i, No** raiz);
No* rotacaoDir(No* i);
No* rotacaoEsq(No* i);
bool isNoTipoQuatro(No* i);
void fragmentar(No* i);

No* novoNo(Veiculo elemento){

	No* novo = (No*) malloc(sizeof(No));
	novo->elemento = elemento;
	novo->esq = NULL;
	novo->dir = NULL;
    	novo->cor = true;
	return novo;	
}

void inserir(Veiculo carro, No** raiz){
	if (*raiz == NULL){
		*raiz = novoNo(carro);
	} else {
		inserirRec(carro, NULL, NULL, NULL, *raiz, raiz);
	}

	(*raiz) -> cor = false;
}

void inserirRec(Veiculo carro, No* bisavo, No* avo, No* pai, No* i, No** raiz){

	if (i == NULL){
		if (strcmp(carro.modelo, pai->elemento.modelo) < 0){
			pai->esq = novoNo(carro);
			i = pai->esq;
		} else if (strcmp(carro.modelo, pai->elemento.modelo) > 0){
			pai->dir = novoNo(carro);
			i = pai->dir;
		}

		if (pai->cor == true){
			balancear(bisavo, avo, pai, i, raiz);
		}

	}else {
		
		if (isNoTipoQuatro(i)){
			fragmentar(i);
			if (i == *raiz){
				i->cor = false;

			}else if (pai->cor == true){
				balancear(bisavo, avo, pai, i, raiz);
			}
		}

	 	if (strcmp(carro.modelo, i->elemento.modelo) < 0){
			inserirRec(carro, avo, pai, i, i->esq, raiz);

		}else if (strcmp(carro.modelo, i->elemento.modelo) > 0){
			inserirRec(carro, avo, pai, i, i->dir, raiz);
		}
	}	
}

void balancear (No* bisavo, No* avo, No* pai, No* i, No** raiz){

	if (pai->cor == true){
		No* novo;
	
		if (strcmp(pai->elemento.modelo, avo->elemento.modelo) > 0){
			if (strcmp(i->elemento.modelo, pai->elemento.modelo) < 0){
				avo->dir = rotacaoDir(pai);
			}
			novo = rotacaoEsq(avo);
		} else {
			
			if (strcmp(i->elemento.modelo, pai->elemento.modelo) > 0){
                                   avo->esq = rotacaoEsq(pai);
                         }
                           novo = rotacaoDir(avo);	
		}
		
		if (bisavo == NULL){
			*raiz = novo;
		} else if (strcmp(novo->elemento.modelo, bisavo->elemento.modelo) < 0){
			bisavo->esq = novo;
		} else {
			bisavo->dir = novo;
		}

		novo->cor = false;
		novo->esq->cor = true;
		novo->dir->cor = true;		
	}
}

No* rotacaoDir(No* i){

	No* noEsq = i->esq;
	No* noEsqDir = noEsq->dir;

	noEsq->dir = i;
	i->esq = noEsqDir;

	return noEsq;	
}

No* rotacaoEsq(No* i){

        No* noDir = i->dir;
        No* noDirEsq = noDir->esq;

        noDir->esq = i;
        i->dir = noDirEsq;
 
        return noDir;
}



bool pesquisarRec (char modelo[], No* i){
		
	bool resp;

	if (i == NULL){
		resp = false;

	}else if (strcmp(modelo, i->elemento.modelo) == 0){
		resp = true;

	}else if (strcmp(modelo, i->elemento.modelo) < 0){

		printf("esq ");
		resp = pesquisarRec(modelo, i->esq);

	}else{
		printf("dir ");
		resp = pesquisarRec(modelo, i->dir);
	}

	return resp;
}

void pesquisar(char modelo[], No* raiz){

	if (raiz != NULL){
		printf("raiz ");
	}

	bool res = pesquisarRec(modelo, raiz);

	if(res){
		printf("SIM\n");
	} else {
		printf("NAO\n");
	}
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

void retirarChar(char string[]){

    int tam = strlen(string);
    if (string[tam - 1] == '\n'){
        string[tam - 1] = '\0';
    }
}

bool isNoTipoQuatro (No* i){
	
	return (i->esq != NULL && i->dir != NULL && i->esq->cor == true && i->dir->cor == true);
} 

void fragmentar(No* i){
	
	i->cor = true;
	i->esq->cor = false;
	i->dir->cor = false;
}
 
int main() {
    
    int totalVeiculos = 0;
    Veiculo* veiculos = lerCsv("/tmp/veiculos.csv", &totalVeiculos); 	
    No* raiz = NULL;

    int entrada;
    scanf("%d", &entrada);
   
    while (entrada != -1){
	
        for (int i = 0; i < totalVeiculos; i++) {
            if (veiculos[i].id == entrada) {
		        inserir(veiculos[i], &raiz);
            }
        }

	    scanf("%d", &entrada);
    }
	
    char modelo[100];
    getchar();
    fgets(modelo, 100, stdin);
    retirarChar(modelo);

    while (strcmp(modelo, "FIM") != 0){
        pesquisar(modelo, raiz);
        fgets(modelo, 100, stdin);
        retirarChar(modelo);
    }    	

    emOrdem(raiz);
    free(veiculos);
}
