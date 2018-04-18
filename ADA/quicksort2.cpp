#include <iostream>
#include <vector>
#include <stdlib.h>
#include <time.h>
#include <ctime>
using namespace std;

int llamadas=0;

void swap(vector<int> &vec, int a, int b){
	int temp=vec[a];
	vec[a]=vec[b];
	vec[b]=temp;
}

void llenar(vector<int> &A){
	for(int i=0;i<A.size();i++)
		A[i]=rand()%100000;
}

void imprimir(vector<int> A){
	cout<<"[";
	for(int i=0;i<A.size()-1;i++)
		cout<<A[i]<<", ";
	cout<<A[A.size()-1]<<"]";
	cout<<endl<<endl;
}

int Partition_Hoare(vector<int> &A, int p, int r ){
	int x = A[p];
	int i = p-1;
	int j = r+1;
	while(true){
		do j--; while(A[j]>x);
		do i++; while(A[i]<x);
		if(i<j)
			swap(A,i,j);
		else
			return j;
	}
}

int Partition_Lomuto(vector<int> &A, int p, int r){
	int x=A[r];
	int i=p-1;
	for(int j=p;j<r;j++){
		if(A[j]<=x){
			i++;
			swap(A,i,j);
		}
	}
	swap(A,i+1,r);
	return i;
}

void QuickSort_Hoare(vector<int> &A, int p, int r){
	if(p<r){
		int q=Partition_Hoare(A,p,r);
		QuickSort_Hoare(A,p,q);
		QuickSort_Hoare(A,q+1,r);
	}
}

void QuickSort_Lomuto(vector<int> &A, int p, int r){
	if(p<r){
		llamadas++;
		int q=Partition_Lomuto(A,p,r);
		QuickSort_Lomuto(A,p,q);
		QuickSort_Lomuto(A,q+1,r);
	}
}


int main(int argc, char *argv[]) {
	unsigned t0,t1;
	srand(time(NULL));
	for(int tam=100000;tam<=1000000;tam+=100000){
		vector<int> numeros(tam);
		llenar(numeros);
		cout<<endl;
		t0=clock();
		QuickSort_Hoare(numeros,0,numeros.size()-1);
		t1=clock();
		double time = (double(t1-t0)/CLOCKS_PER_SEC);
		cout<< "Elementos:" << numeros.size() << endl;
		cout << "Tiempo: " << time<<endl;
	}
	return 0;
}
