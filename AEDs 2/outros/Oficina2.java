import java.util.*;

class No{
	
	public int elemento;
	public No esq, dir;

	public No (int elemento){
	
		this.elemento = elemento;
		this.esq = null;
		this.dir =null;
	}
	
	public No (int elemento, No esq, No dir){

		this.elemento = elemento;
        	this.esq = esq;
        	this.dir = dir;		
	}
}



class arvoreBinaria{

	public No raiz;

	public arvoreBinaria(){
		raiz = null;
	}

	//public void inserir (int x){
	
		//raiz = inserir(x, raiz);
	//}
	
	/*
	public void inserir(int x, No i) throws Exception{
	
		if (i == null){
		
			i = new No(x);
else {
 75                                         return true;
 76                                 }

		} else if (x < i.elemento){
		
			i = inserir (i.esq, x); 

		} else if (x > i.elemento){
			
			i = inserir (i.dir, x);

		} else {
			
			throw new Exception("ja esta na arvore")
		}

		return i;
	}
	*/

	boolean isEspelho (No a, No b){
		
		
		if (a == null && b == null){
			return true;
		}

		if (a == null || b == null){
			return false;
		}

		return (a.elemento == b.elemento && isEspelho(a.esq, b.dir) && isEspelho(a.dir, b.esq));
	}
	/*
	public void inserirPai (int x) throws Excepiton {
	
		if (raiz == null){
		
			raiz = new No(x);

		} else if (x < raiz.elemento){

		   inserirPai(x, raiz.esq, raiz);
		   
      		} else if(x > raiz.elemento){

		   inserirPai(x, raiz.dir, raiz);
      		} else {
         	throw new Exception("Erro ao inserirPai!");
      		}	
	}

	public void inserirPai(int x, No i, No pai) throws Exception
	*/

}
class Oficina2 {

	public static void main (String[] args){
	
		arvoreBinaria a = new arvoreBinaria();
		arvoreBinaria b = new arvoreBinaria();
		
		a.raiz = new No (1);
		a.raiz.esq = new No (3);
		a.raiz.dir = new No (2);
		a.raiz.dir.esq = new No(5);
		a.raiz.dir.dir = new No (4);

		b.raiz = new No (1);    
		b.raiz.esq = new No (2);
		b.raiz.dir = new No (3);
		b.raiz.esq.esq = new No(4);
                b.raiz.esq.dir = new No (1);

		if (a.isEspelho(a.raiz, b.raiz)){
			System.out.println ("Deu bom");
		} else {
			System.out.println ("Deu ruim");
		}
	
	}
}
