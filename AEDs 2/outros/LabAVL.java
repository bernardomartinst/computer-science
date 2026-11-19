import java.util.*;
class No {
    public int elemento; // Conteudo do no.
    public No esq; 
    public No dir;  // Filhos da esq e dir.
    public int nivel;
  
    public No(int elemento) {
        this.elemento = elemento;
	this.esq = null;
        this.dir = null;
	this.nivel = 1;
    }

    public No(int elemento, No esq, No dir) {
        this.elemento = elemento;
        this.esq = esq;
        this.dir = dir;
    }

    public static int getNivel(No i){
    	return (i == null) ? 0 : i.nivel;
    }
    
    public void setNivel(){
	this.nivel = 1 + Math.max(getNivel(esq), getNivel(dir));
    }

    public int getFatorBalanceamento(){
    	
	return getNivel(dir) - getNivel(esq);
    }    

}

class ArvoreBinaria {
	private No raiz; // Raiz da arvore
		 
	public ArvoreBinaria() {
		raiz = null;
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
		raiz = inserir(x, raiz);
	}

	private No inserir(int x, No i) throws Exception {
		if (i == null) {
         		i = new No(x);

      		} else if (x < i.elemento) {
         		i.esq = inserir(x, i.esq);

      		} else if (x > i.elemento) {
         		i.dir = inserir(x, i.dir);

      		} else {
         		throw new Exception("Erro ao inserir!");
      		}
		
		i.setNivel();
		return i;
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
