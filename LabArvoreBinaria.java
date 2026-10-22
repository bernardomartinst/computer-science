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

class arvoreBinaria (){

	public No raiz;

        public arvoreBinaria(){
                 raiz = null;
        }

	public void inserir (int x){
 
                 raiz = inserir(x, raiz);
        }
 
        private void inserir(int x, No i) throws Exception{
 
                if (i == null){
 
                        i = new No(x);
 
                } else if (x < i.elemento){
 
                        i = inserir (i.esq, x);

                } else if (x > i.elemento){
 
                        i = inserir (i.dir, x);
 
                } else {
 
                        throw new Exception("ja esta na arvore")
                }
 
                return i;
        }

	public void emOrdem (No i){

                 if (i != null){

                     	preOrdem(i.esq);
                        System.out.print (i.elemento + " ");
                        preOrdem (i.dir);
                }
        }

        public void preOrdem (No i){

                if (i != null){

			System.out.print (i.elemento + " ");
                        preOrdem (i.esq);
                        preOrdem (i.dir);
                 }

         }

         public void posOrdem (No i){

                if (i != null){

                        preOrdem (i.esq);
                        preOrdem (i.dir);
                        System.out.print (i.elemento + " ");
		}
        }

	public boolean pesquisar (int x, No i){
	
		boolean aux;	
		
		if (i == null){

			aux = false;

		} else if (x == i.elemento){
			
			aux = true;

		} else if (x < i.elemento){
		
			pesquisar(x, i.esq);

		} else {
		
			pesquisar (x, i.dir)
		}

		return aux;
	}
}

class LabArvoreBinaria {

	public static void main (String[] args){
	
		Scanner scan = new Scanner (System.in);
		String entrada;

		
		
		
	
	
	}
}

