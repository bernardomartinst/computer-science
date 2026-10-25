import java.util.*;

class CelulaMat {

         public int elemento;
         public CelulaMat sup, inf, dir, esq;

         CelulaMat (){
                 this(0);
         }

         CelulaMat(int elemento){
                 this.elemento = elemento;
                 sup = null;
                 inf = null;
                 esq = null;
                 dir = null;
         }
}

class Matriz {

         public CelulaMat inicio;
         public int linha, coluna;

         Matriz (int c, int l){

		 int contador = 0;
                 inicio = new CelulaMat(contador++);
                 this.linha = l;
                 this.coluna = c;

                 CelulaMat aux = inicio;

                 for (int i = 1; i < coluna; i++){
                         aux.dir = new CelulaMat (contador++);
                         aux.dir.esq = aux;
                         aux = aux.dir;
                 }

                 CelulaMat inicioLinhaAcima = inicio;

                 for (int i = 1; i < linha; i++){
                         inicioLinhaAcima.inf = new CelulaMat (contador++);
                         inicioLinhaAcima.inf.sup = inicioLinhaAcima;

                         CelulaMat atual = inicioLinhaAcima.inf;
                         CelulaMat acima = inicioLinhaAcima;

                         for (int j = 1; j < coluna; j++){
				
				 acima = acima.dir;

                                 atual.dir = new CelulaMat (contador++);
                                 atual.dir.esq = atual;

                                 acima.dir.sup = acima;
				 acima.inf = atual.dir;

                                 atual = atual.dir;
                         }

                         inicioLinhaAcima = inicioLinhaAcima.inf;
                 }
         }

         public void mostrar(){
              
                 CelulaMat auxLinha = inicio;

                 for (int i = 0; i < linha; i++){

                         if (i % 2 !=  0){

                                 for (int j = coluna; j > 0; j--){
                                         System.out.println(auxLinha.elemento);
                                         auxLinha = auxLinha.esq;
                                 }

                         } else {

                                 for (int j = 0; j < coluna; j++){
                                         System.out.println(auxLinha.elemento);
                                         auxLinha = auxLinha.dir;
                                 }
                         }

                         auxLinha = auxLinha.inf;
                 }
         }
}

class Oficina1 {

         public static void main (String[] args) {

		Matriz matriz = new Matriz (4,4);

		matriz.mostrar();

         }
}
