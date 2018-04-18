#include <iostream>
#include <cstdlib>
#include <fstream>
#include <string>
using namespace std;

void mayusculas(string &palabra){
	for(int i = 0; i < palabra.size(); i++){
		palabra[i] = toupper(palabra[i]);
	}
}

void create_table(string nombre, string atributes){
	mayusculas(nombre);
	ofstream table("C:\\Users\\Estilos\\Desktop\\HarudesDB\\" + nombre + ".txt", ios::app);
	ofstream metadata("C:\\Users\\Estilos\\Desktop\\HarudesDB\\METADATA.txt", ios::app);
	metadata<<nombre+"("+atributes+")";
	metadata<<endl;
}

bool crear_tabla(){
	string tabla,atributo,temp;
	cout<<"Ingrese el nombre de la tabla:";
	cin>>tabla;
	cout<<"Ingrese el nombre del atributo:";
	cin>>temp;
	if(temp!=";"){
		mayusculas(temp);
		atributo+=temp;
		atributo+=" ";
		cout<<"Ingrese el tipo de dato:";
		cin>>temp;
		mayusculas(temp);
		if((temp=="INTEGER")||(temp=="STRING")||(temp=="DATE"))
			atributo+=temp;
		else
			return 0;
	}
	while(true){
		cout<<"Ingrese el nombre del atributo:";
		cin>>temp;
		if(temp==";")
			break;
		else{
			mayusculas(temp);
			atributo+=", ";
			atributo+=temp;
			atributo+=" ";
			cout<<"Ingrese el tipo de dato:";
			cin>>temp;
			mayusculas(temp);
			if((temp=="INTEGER")||(temp=="STRING")||(temp=="DATE"))
				atributo+=temp;
			else
				return 0;
		}
	}
	create_table(tabla,atributo);
	return 1;
}

int main(int argc, char *argv[]){
	int operation;
	while(true){
		cout<<"Ingrese la operacion:"<<endl<<endl<<"1: Crear tabla"<<endl<<"2: Insertar elemento"<<endl<<"3: Eliminar elementos"<<endl<<"4: Realizar una consulta"<<endl<<endl;
		cin>>operation;
		switch(operation){
		case 1:if(crear_tabla())
			cout<<endl<<"La tabla se ha creado con exito"<<endl;
		else
			cout<<endl<<"Error de sintaxis"<<endl;break;
		case 2:cout<<"Aun en proceso";break;
		case 3:cout<<"Aun en proceso";break;
		case 4:cout<<"Aun en proceso";break;
		}
		cout<<endl<<endl;
	}
	crear_tabla();
	return 0;
}
