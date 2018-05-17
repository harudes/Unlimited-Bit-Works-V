#include <iostream>
#include <vector>
#include <fstream>
#include <string>
using namespace std;

struct Edge  { int u, v; float w;
Edge(int u = -1, int v = -1, float w = -1.0) : u(u), v(v), w(w) { }
};

class GRAPH {
private:
	// Implementation-dependent code
	vector<vector <bool> > adj;
	vector<vector <float> > weight;
	vector<int> camino;
	vector<string> disp;
	vector<float> pesos;
	int Vcnt, Ecnt;
	bool digraph;
public:
	GRAPH(int V, bool digraph = false) : adj(V),weight(V), Vcnt(V), Ecnt(0), digraph(digraph) {
		for (int i = 0; i < V; i++){
			adj[i].assign(V, false);
			weight[i].assign(V, false);
			camino.assign(V,0);
			disp.push_back("unvisited");
			pesos.push_back(100000.0);
		}
	}
	void clean(){
		for(int i=0; i<Vcnt;i++){
			disp[i]="unvisited";
			pesos[i]=100000;
		}
	};
	~GRAPH(){};
	int V()const{
		return Vcnt;
	};
	int E()const{
		return Ecnt;
	};
	bool directed()const{
		return digraph;
	};
	void insert(Edge e){
		adj[e.u][e.v]=1;
		weight[e.u][e.v]=e.w;
		weight[e.v][e.u]=e.w;
		if(digraph)
			adj[e.v][e.u]=1;
			Ecnt++;
	};
	void remove(Edge e){
		adj[e.v][e.w]=0;
		if(digraph)
			adj[e.w][e.v]=0;
			Ecnt--;
	};
	bool edge(int u, int v){
		return adj[u][v];
	};
	vector<int> neightbors(int u){
		vector<int> vecinos;
		for(int i=0;i<Vcnt;i++){
			if(adj[u][i])
				vecinos.push_back(i);
		}
		return vecinos;
	}
	void dfs(int u){
		cout<<u<<" -> ";
		disp[u] = "in_progress";
		vector<int> vecinos=neightbors(u);
		for(int i=0;i<vecinos.size();i++){
			if(disp[vecinos[i]]=="unvisited"){
				dfs(vecinos[i]);
			}
		}
		disp[u]="done";
	};
	int menor_peso(){
		int x=-1,aux=0,min=0;
		for(int i=0;i<pesos.size();i++){
			if(disp[i]!="done"){
				aux=i;
				break;
			}
		}
		min=aux;
		for(int i=0;i<pesos.size();i++){
			if(disp[i]!="done"){
				if(pesos[i]<pesos[min])
					min=i;
			}
		}
		if(disp[0]!="done"||aux>0)
			x=min;
		return x;
	}
	void recorrido(int s){
		vector<int> nodos;
		while(s!=camino[s]){
			nodos.push_back(s);
		}
		nodos.push_back(s);
		for(int i=nodos.size()-1;i>=0;i--){
			cout<<nodos[i]<<",";
		}
	}
	void ordenar(vector<int> vecinos){
		float cur_value;
		int j;
		for(int i=0;i<vecinos.size();i++){
			cur_value = pesos[vecinos[i]];
			j=i-1;
			while(j >= 0 && pesos[vecinos[j]] > cur_value){
				vecinos[j+1] = vecinos[j];
				j=j-1;
			}
			pesos[vecinos[j+1]]=cur_value;
		}
	}
	void dijkstra(int s, int b, float peso){
		camino.push_back(s);
		if(s==b){
			disp[s]="done";
			cout<<"Hacia "<<s<<": "<<peso+0.0<<endl;
			cout<<"Recorrido: ";
			recorrido(s);
		}
		for(unsigned int i=0;i<camino.size();i++)
			cout<<camino[i]<<",";
		cout<<endl;
		vector<int> vecinos=neightbors(s);
		pesos[s]=peso;
		for(unsigned int i=0;i<vecinos.size();i++){
			if(disp[vecinos[i]]!="done"){
				if(pesos[s]+weight[s][vecinos[i]]<pesos[vecinos[i]]){
					pesos[vecinos[i]]=pesos[s]+weight[s][vecinos[i]];
					camino[vecinos[i]]=s;
				}
			}
		}
		int menor=menor_peso();
		if(menor>=0)
			dijkstra(menor,b,pesos[menor]);
	};
	void bfs(int s){
		vector<vector<int> > L(Vcnt);
		L[0].push_back(s);
		for(int i=0;i<Vcnt;i++){
			for(int j=0; j<L[i].size();i++){
				vector<int> vecinos=neightbors(L[i][j]);
				for(int k=0;k<vecinos.size();k++){
					disp[vecinos[k]]="visited";
					L[i+1].push_back(vecinos[k]);
					cout<<vecinos[k]<<" -> ";
				}
			}
		}
	};
	class adjIterator {
	private:
		const GRAPH &G;
		int i, v;
	public:
		adjIterator(const GRAPH &G, int v) :  G(G), v(v), i(-1) { }
		int beg() { i = -1; return nxt(); }
		int nxt() {
			for (i++; i < G.V(); i++)
				if (G.adj[v][i] == true) return i;
			return -1;
		}
		bool end() { return i >= G.V(); }
	};
};


template <class Graph>
vector <Edge> edges(Graph &G) {
	int E = 0;
	vector <Edge> a(G.E());
	for (int v = 0; v < G.V(); v++) {
		typename Graph::adjIterator A(G, v);
		for (int w = A.beg(); !A.end(); w = A.nxt())
			if (G.directed() || v < w)
				a[E++] = Edge(v, w);
	}
	return a;
}

template <class Graph>
void show(const Graph &G) {
	for (int s = 0; s < G.V(); s++) {
		cout.width(2); cout << s << ":";
		typename Graph::adjIterator A(G, s);
		for (int t = A.beg(); !A.end(); t = A.nxt()) { 
			cout.width(2); cout << t << " "; 
		}
		cout << endl;
	}
}


template <class G>
void insertar(G grafo, string nodo){
	
}

int main(int argc, char *argv[]){
	int v,e;
	cin>>v>>e;
	int a,b;
	float w;
	GRAPH grafo(v,0);
	for(int i=0;i<e;i++){
		cin>>a>>b>>w;
		Edge ed(a,b,w+0.0);
		grafo.insert(ed);
	}
	show(grafo);
	vector<int> camino;
	grafo.dijkstra(1,89,0.0);
	return 0;
}


