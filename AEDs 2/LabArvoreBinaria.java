import java.util.*;

class No {

	public int elemento;
	public No esq, dir;

	public No(int elemento) {

		this.elemento = elemento;
		this.esq = null;
		this.dir = null;
	}

	public No(int elemento, No esq, No dir) {

		this.elemento = elemento;
		this.esq = esq;
		this.dir = dir;
	}
}

class arvoreBinaria {

	public No raiz;

	public arvoreBinaria() {
		raiz = null;
	}

	public void inserir(int x) throws Exception {

		raiz = inserir(raiz, x);
	}

	private No inserir(No i, int x) throws Exception {

		if (i == null) {

			i = new No(x);

		} else if (x < i.elemento) {

			i.esq = inserir(i.esq, x);

		} else if (x > i.elemento) {

			i.dir = inserir(i.dir, x);

		} else {

			throw new Exception("ja esta na arvore");
		}

		return i;
	}

	public void emOrdem() {

		if (raiz == null) {

			System.out.println("V");
		} else {

			emOrdem(raiz);
			System.out.println();

		}
	}

	private void emOrdem(No i) {

		if (i != null) {

			emOrdem(i.esq);
			System.out.print(i.elemento + " ");
			emOrdem(i.dir);
		}
	}

	public void preOrdem() {

		if (raiz == null) {

			System.out.println("V");
		} else {

			preOrdem(raiz);
			System.out.println();
		}
	}

	private void preOrdem(No i) {

		if (i != null) {

			System.out.print(i.elemento + " ");
			preOrdem(i.esq);
			preOrdem(i.dir);

		}

	}

	public void posOrdem() {

		if (raiz == null) {

			System.out.println("V");
		} else {

			posOrdem(raiz);
			System.out.println();
		}
	}

	private void posOrdem(No i) {

		if (i != null) {

			posOrdem(i.esq);
			posOrdem(i.dir);
			System.out.print(i.elemento + " ");
		}
	}

	public void pesquisar(int x) {

		boolean res = pesquisar(x, raiz);

		if (res) {

			System.out.println("S");
		} else {
			System.out.println("N");
		}
	}

	private boolean pesquisar(int x, No i) {

		boolean resp;

		if (i == null) {

			resp = false;

		} else {

			System.out.print(i.elemento + " ");

			if (x == i.elemento) {

				resp = true;

			} else if (x < i.elemento) {

				resp = pesquisar(x, i.esq);

			} else {

				resp = pesquisar(x, i.dir);
			}

		}

		return resp;
	}
}

class LabArvoreBinaria {

	public static void main(String[] args) {

		arvoreBinaria arvore = new arvoreBinaria();

		Scanner scan = new Scanner(System.in);

		while (scan.hasNextLine()) {

			String entrada = scan.nextLine();
			String[] comando = entrada.split(" ");

			try {

				if (comando[0].compareTo("I") == 0) {

					arvore.inserir(Integer.parseInt(comando[1]));
				}

				if (comando[0].compareTo("P") == 0) {

					arvore.pesquisar(Integer.parseInt(comando[1]));
				}

				if (comando[0].compareTo("PRE") == 0) {

					arvore.preOrdem();
				}

				if (comando[0].compareTo("POS") == 0) {

					arvore.posOrdem();
				}

				if (comando[0].compareTo("EM") == 0) {

					arvore.emOrdem();

				}

			} catch (Exception e) {

				System.out.println(e.getMessage());
			}
		}
	}
}
