import java.util.*;
class No {
    public int elemento; // Conteudo do no.
    public No esq; 
    public No dir;  // Filhos da esq e dir.
    public boolean cor;
  
    public No(int elemento) {
        this.elemento = elemento;
	this.esq = null;
        this.dir = null;
	this.cor = true;
    }

    public No(int elemento, No esq, No dir) {
        this.elemento = elemento;
        this.esq = esq;
        this.dir = dir;
    }

    public boolean isNoTipoQuatro(No i){
    	
	    return i.esq != null && i.dir != null && i.esq.cor == true && i.esq.cor == true;
    }
}

class ArvoreBinaria {
	private No raiz; // Raiz da arvore
		 
	public ArvoreBinaria() {
		raiz = null;
	}

	public void fragmentar(No i){
            i.cor = true;
            i.esq.cor = false;
            i.dir.cor = false;
        }


	public boolean pesquisar(int x) {
		return pesquisar(x, raiz);
	}

	private boolean pesquisar(int x, No i) {
      		boolean resp;
		if (i == null) {
         		resp = false;

      		} else if (x == i.elemento) {
         		resp = true;

      		} else if (x < i.elemento) {
         		resp = pesquisar(x, i.esq);

      		} else {
         		resp = pesquisar(x, i.dir);
      		}
      		return resp;
	}

	/**
	 * Metodo publico iterativo para exibir elementos.
	 */
	public void caminharCentral() {
		System.out.print("[ ");
		caminharCentral(raiz);
		System.out.println("]");
	}

	private void caminharCentral(No i) {
		if (i != null) {
			int nivel = i.getNivel(i);
			int fb = i.getFatorBalanceamento(); 
			caminharCentral(i.esq); // Elementos da esquerda.
			System.out.print(i.elemento + " " + nivel  + " " + "fb:" + fb + " "); // Conteudo do no.
			caminharCentral(i.dir); // Elementos da direita.
		}
	}

	public void inserir(int x) throws Exception {

		if (raiz == null){
			raiz = new No (x);
		} else {
			raiz = inserir(x, null, null, null, raiz);
		}
		raiz.cor = false;
	}

	private void inserir(int x, No bisavo, No avo, No pai, No i) throws Exception {
	
		if (i == null){
		
			if (x < pai.elemento){
				pai.esq = new No (x);
				i = pai.esq;				
			} else {
				pai.dir = new No (x);
				i = pai.dir;
			}

			if (pai.cor == true){
				balancear(bisavo, avo, pai, i);
			}

		} else {
			
			if(isNoTipoQuatro(No i)){
				fragmentar(i);
				if (i == raiz){
					i.cor = false;
					
				} else if (pai.cor == true) {
					balancear(bisaco, avo, pai, i);
				}
			}
			
			if (x < i.elemento){
				inserir(elemento, bisavo, avo, pai, i.esq);
			} else if (x > i.elemento){
				inserir(elemento, bisavo, avo, pai, i.dir);
			}	
		}
	}

	private void balancear(No i){
		
		if ()
	}

	public void rotacionarDir (No i){

		No noEsq = i.esq;
		No noEsqDir = noEsq.dir;

		noEsq.dir = i;
		i.esq = noEsqDir;	
	}

	public void rotacionarEsq (No i){
		
		No noDir = i.dir;
		No noDirEsq = noDir.esq;

		noDir.esq = i;
		i.dir = noDirEsq;
	}
}		


class LabAVL {

	public static void main (String[] args) throws Exception{
	
			
	ArvoreBinaria a = new ArvoreBinaria();
	a.inserir(20);
	a.inserir(10);
	a.inserir(30);
	a.inserir(5);
	a.inserir(25);
	a.inserir(40);
	a.inserir(50);
		
	a.caminharCentral();
  	
	}

} 
