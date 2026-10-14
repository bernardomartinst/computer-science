import java.util.Scanner;
import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;

class Veiculo {
	
	private int id;
	private String marca;
	private String modelo;
	private int ano;
	private String categoria;
	private String[] combustivel;
	private int cilindros;
	private double cilindradas;
	private String transmissao;
	private String tracao;
	private double consumoCidade;
	private double consumoEstrada;
	private double co2;
	private boolean turbo;
	private Data dataRegistro;

	public Veiculo(){
	}
 
	public int getId(){
		return id;
	}

	public void setId(int id){
		this.id = id;
	}

	public String getMarca(){
		return marca;
	}

	public void setMarca(String marca){
		this.marca = marca;
	}

	public String getModelo(){
		return modelo;
	}

	public void setModelo(String modelo){
		this.modelo = modelo;
	}

	public int getAno(){
		return ano;
	}

	public void setAno(int ano){
		this.ano = ano;
	}

	public String getCategoria(){
		return categoria;
	}

	public void setCategoria(String categoria){
		this.categoria = categoria;
	}

	public String[] getCombustivel(){
		return combustivel;
	}

	public void setCombustivel(String[] combustivel){
		this.combustivel = combustivel;
	}

	public int getCilindros(){
		return cilindros;
	}

	public void setCilindros(int cilindros){
		this.cilindros = cilindros;
	}	
	
	public double getCilindradas(){
		return cilindradas;
	}

	public void setCilindradas(double cilindradas){
		this.cilindradas = cilindradas;
	}

	public String getTransmissao (){
		return transmissao;
	}

	public void setTransmissao (String transmissao){
		this.transmissao = transmissao;
	}

	public String getTracao(){
		return tracao;
	}

	public void setTracao (String tracao){
		this.tracao = tracao;
	}

	public double getConsumoCidade(){
		return consumoCidade;
	}

	public void setConsumoCidade (double consumoCidade){
		this.consumoCidade = consumoCidade;
	}

	public double getConsumoEstrada(){
		return consumoEstrada;
	}

	public void setConsumoEstrada(double consumoEstrada){
		this.consumoEstrada = consumoEstrada;
	}

	public double getCo2(){
		return co2;
	}

	public void setCo2(double co2){
		this.co2 = co2;
	}
	
	public boolean getTurbo (){
		return turbo;
	}

	public void setTurbo (boolean turbo){
		this.turbo = turbo;
	}

	public Data getData(){
		return dataRegistro; 
	}

	public void setData (Data dataRegistro){
		this.dataRegistro = dataRegistro;
	}

	public static  Veiculo parseVeiculo(String s){
		
		String dados[] = s.split(",");
		Data dataRegistro = Data.parseData(dados[14]);
		Veiculo carro = new Veiculo();

		carro.setId (Integer.parseInt (dados[0]));
	        carro.setMarca (dados[1]);
		carro.setModelo (dados[2]);
		carro.setAno (Integer.parseInt (dados[3]));
		carro.setCategoria (dados[4]);
		carro.setCombustivel(dados[5].split(";"));
		carro.setCilindros (Integer.parseInt (dados[6]));
		carro.setCilindradas (Double.parseDouble(dados[7]));
		carro.setTransmissao (dados[8]);
		carro.setTracao (dados[9]);
		carro.setConsumoCidade (Double.parseDouble(dados[10]));
		carro.setConsumoEstrada (Double.parseDouble(dados[11]));
		carro.setCo2 (Double.parseDouble (dados[12]));
		carro.setTurbo (Boolean.parseBoolean (dados[13]));
		carro.setData (dataRegistro);

		return carro;
	}

	public String format () {

		String strCombustivel = "[";

   		 for (int i = 0; i < combustivel.length; i++) {

   	     		 strCombustivel += combustivel[i];

       			 if (i < combustivel.length - 1) {

           		 strCombustivel += ",";
       			 }
   		 }

   		 strCombustivel += "]";
	
		String mensagem = String.format(Locale.US, "[%d ## %s ## %s ## %d ## %s ## %s ## %d ## %.1f ## %s ## %s ## %.2f ## %.2f ## %.1f ## %b ## %s]",
    getId(), getMarca(), getModelo(), getAno(), getCategoria(), strCombustivel, getCilindros(), getCilindradas(), 
    getTransmissao(), getTracao(), getConsumoCidade(), getConsumoEstrada(), getCo2(), getTurbo(), getData().format());
		
		return mensagem;
	}
}

class Data {

	private int ano;
	private int mes;
	private int dia;

	public Data(){
	}

	public Data (int ano, int mes, int dia){
		this.ano = ano;
		this.mes = mes;
		this.dia = dia; 
	}

	public int getAno(){
		return ano;
	}

	public void setAno(int ano){
		this.ano = ano;
	}

	public int getMes(){
                 return mes;
        }
        
       	public void setMes(int mes){
                this.mes = mes;
	}

	public int getDia(){
                 return dia;
         }
 
         public void setDia(int dia){
                 this.dia = dia;
         }
	
	public static Data parseData(String s){
		
		int dia, mes, ano;

		String[] divisao = s.split("-");

		ano = Integer.parseInt (divisao [0]);
		mes = Integer.parseInt (divisao [1]);
		dia = Integer.parseInt (divisao [2]);

		Data resultado = new Data(ano, mes, dia);
		return resultado;
	
	}

	public String format(){
		
		String mensagem = String.format ("%02d/%02d/%04d", dia, mes, ano);
		return mensagem; 
	}	
}
	
class LeitorCsv{	
	
	public static Veiculo[] ler(String caminhoArquivo){

	Veiculo conjunto[] = new Veiculo[500];

	try {
		File arquivo = new File(caminhoArquivo);
		Scanner scanner = new Scanner (arquivo);
		
		if (scanner.hasNextLine()){
			scanner.nextLine();
		}
			
		for (int i = 0; i < 500; i++){
			
			if(scanner.hasNextLine()){
		
				String string = scanner.nextLine();
				conjunto[i] = Veiculo.parseVeiculo(string);
			}
		}	
	
	}

	catch (FileNotFoundException e){
		System.out.println ("Erro ao abrir o arquivo" + caminhoArquivo);
	}

	return conjunto;
	}
}	


public class Tp3Q1 {

	public static void mergeSort (Veiculo carros[], int esq, int dir){
		
		if (esq < dir){

         		int meio = (esq + dir) / 2;
         		mergeSort(carros, esq, meio);
         		mergeSort(carros, meio + 1, dir);
         		intercalar(carros, esq, meio, dir);
      		}
   	}
	
	public static void intercalar (Veiculo[] carros, int esq, int meio, int dir){

		int nEsq, nDir;

		nEsq = meio - esq + 1;
		nDir = dir - meio;

		Veiculo[] vetDir = new Veiculo[nDir];
		Veiculo[] vetEsq = new Veiculo[nEsq];

		int iEsq, iDir, i;

		for (iDir = 0; iDir < nDir; iDir++){
				
			vetDir[iDir] = carros[iDir + meio + 1];
		}

		for (iEsq = 0; iEsq < nEsq; iEsq++){
			
			vetEsq [iEsq] = carros[esq + iEsq];
		}

		iDir = 0;
		iEsq = 0;

		i = esq;

		while (iEsq < nEsq && iDir < nDir){
		
			if (vetEsq[iEsq].getConsumoCidade() < vetDir[iDir].getConsumoCidade()){
			
				carros[i++] = vetEsq[iEsq++];
				
			} else if (vetEsq[iEsq].getConsumoCidade() > vetDir[iDir].getConsumoCidade()){
			
				carros[i++] = vetDir[iDir++];
			
			} else if (vetEsq[iEsq].getCategoria().compareToIgnoreCase(vetDir[iDir].getCategoria()) > 0){
			
				carros[i++] = vetDir[iDir++];

			} else {
			
				carros[i++] = vetEsq[iEsq++];
			}	
		}

		while (iEsq < nEsq){
		
			carros[i++] = vetEsq[iEsq++];
		}

		while (iDir < nDir){
			carros[i++] = vetDir [iDir++];
		}
	}
	
	public static void main (String []args){

		Veiculo carros[] = new Veiculo[500];
		Veiculo consumoCidade[] = new Veiculo[500];
		int qtdConsumoCidade = 0;
		carros = LeitorCsv.ler("/tmp/veiculos.csv");	
		Scanner scan = new Scanner (System.in);

		int vetor[] = new int[500];

		int num = scan.nextInt();

		while ( num != -1 ){
	
			for (int j = 0; j < carros.length; j++){
				
				if (carros[j].getId() == num){
					
					consumoCidade[qtdConsumoCidade] = carros[j];
					j = carros.length;
					qtdConsumoCidade++;
				}
			}

			num = scan.nextInt();
		}

		mergeSort(consumoCidade, 0, qtdConsumoCidade - 1);

		for (int k = 0; k < qtdConsumoCidade; k++){

                         System.out.println (consumoCidade[k].format());
                 }
 	}	
}
