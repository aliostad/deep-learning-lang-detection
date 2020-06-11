#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
#include <mare/mare.h>
#include <stdio.h>
#include <unistd.h>
using namespace std;

#define NPIXELX 1000
#define NPIXELY 1000

void calculabloque(int i,int j,double **image,int chunk_i,int chunk_j);

int main(){ //int argc, char **argv

	int i, j, px=NPIXELX, py=NPIXELY;
	int chunk_i = 17;
	int chunk_j = 17;
	double sum, promedio;
	double **im;
	mare::task_ptr **task;	
	auto g = mare::create_group("filtro");
	int a = ((py-2)/chunk_j)+2;
	int b = ((px-2)/chunk_i)+2;	
	
	im = (double **)malloc(py*sizeof(double*));


	for (i=0;i<py;i++) 
		im[i] = (double*)malloc(px*sizeof(double));
	
	task = (mare::task_ptr **)malloc(a*sizeof(mare::task_ptr*));

	for (i=0;i<=a;i++) 
		task[i] = (mare::task_ptr *)malloc(b*sizeof(mare::task_ptr));


	// "Lectura/Inicialización" de la imagen 
	for(i=0; i < px; i++)
	for(j=0; j < py; j++)
	    im[i][j] = (double) (i*NPIXELX)+j;
	
	// Promedio inicial  (test de entrada)
	sum = 0.0;
	for(i=0; i < px; i++)	
	for(j=0; j < py; j++)
	    sum += im[i][j];

	promedio = sum /(px*py);
	printf("El promedio inicial es %g\n", promedio);

	
	task[1][1] = mare::create_task([&im,i,j,chunk_i,chunk_j]{(calculabloque(1,1,im,chunk_i,chunk_j));} );
	mare::launch(g,task[1][1]);

	int modi = (px-2)%chunk_i;
	int modj = (py-2)%chunk_j;

	for(j=2; j<=((py-2)/chunk_j); j++){
		
		task[1][j] = mare::create_task([&im,i,j,chunk_i,chunk_j]{(
			calculabloque(1,((j-1)*chunk_j)+1,im,chunk_i,chunk_j));});
			mare::after(task[1][j-1],task[1][j]);
			mare::launch(g,task[1][j]);
			
	}
	

	if((modj != 0) && (j>=((py-2)/chunk_j))){
			
			task[1][j] = mare::create_task([&im,i,j,chunk_i,chunk_j,modj]{(
			calculabloque(1,((j-1)*chunk_j)+1,im,chunk_i,modj));});
			mare::after(task[1][j-1],task[1][j]);
			mare::launch(g,task[1][j]);
				
		}
		
		
	for(i=2; i<=((px-2)/chunk_i); i++){

			task[i][1] = mare::create_task([&im,i,j,chunk_i,chunk_j]
			{(calculabloque(((i-1)*chunk_i)+1,1,im,chunk_i,chunk_j));} );	
			mare::after(task[i-1][1],task[i][1]);
			mare::launch(g,task[i][1]);
			
			for(j=2; j<=((py-2)/chunk_j);j++){
					
					task[i][j] = mare::create_task([&im,i,j,chunk_i,chunk_j]
					{(calculabloque(((i-1)*chunk_i)+1,((j-1)*chunk_j)+1,im,chunk_i,chunk_j));} );	
					mare::after(task[i][j-1],task[i][j]);
					mare::after(task[i-1][j],task[i][j]);
					mare::launch(g,task[i][j]);
			}	
			
			if((modj != 0) && (j >= ((py-2)/chunk_j))){
					
				task[i][j] = mare::create_task([&im,i,j,modj,chunk_j,chunk_i]
				{(calculabloque(((i-1)*chunk_i)+1,((j-1)*chunk_j)+1,im,chunk_i,modj));} );	
				mare::after(task[i][j-1],task[i][j]);
				mare::after(task[i-1][j],task[i][j]);
				mare::launch(g,task[i][j]);
			}
	}
	
	//Calculo la última fila 
		if(modi != 0 ){
			
			task[i][1] = mare::create_task([&im,i,j,chunk_i,chunk_j,modi]
			{(calculabloque(((i-1)*chunk_i)+1,1,im,modi,chunk_j));} );	
			mare::after(task[i-1][1],task[i][1]);
			mare::launch(g,task[i][1]);
	
			for(j=2; j<=((py-2)/chunk_j);j++){
				
				task[i][j] = mare::create_task([&im,i,j,chunk_i,chunk_j,modi]
					{(calculabloque(((i-1)*chunk_i)+1,((j-1)*chunk_j)+1,im,modi,chunk_j));} );	
					mare::after(task[i][j-1],task[i][j]);
					mare::after(task[i-1][j],task[i][j]);
					mare::launch(g,task[i][j]);
			}

			if(modj != 0){

				task[i][j] = mare::create_task([&im,i,j,chunk_i,chunk_j,modi,modj]
				{(calculabloque(((i-1)*chunk_i)+1,((j-1)*chunk_j)+1,im,modi,modj));} );
				mare::after(task[i][j-1],task[i][j]);
				mare::after(task[i-1][j],task[i][j]);
				mare::launch(g,task[i][j]);	
			}
		}
	
	mare::wait_for(g);

	// Promedio tras el filtro (test de salida)
	sum = 0.0;
	for(i=0; i < px; i++)
	for(j=0; j < py; j++)
	    sum += im[i][j];

	promedio = sum /(px*py);
	printf("El promedio tras el filtro es %g\n", promedio);

	return 0; 
}


void calculabloque(int i,int j,double **im,int chunk_i,int chunk_j){
	
	int a;
	int b;
	for(a=i;a<i+chunk_i;a++){
			for(b=j;b<j+chunk_j;b++){
				im[a][b] += 0.25 * sqrt((im[a-1][b] + im[a][b-1]));
			}
	}
			
}


