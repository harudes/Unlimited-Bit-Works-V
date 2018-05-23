#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <ctime>
using namespace std;

struct Edge  { int u, v; float w;
Edge(int u = -1, int v = -1, float w = -1.0) : u(u), v(v), w(w) { }
};

template<class T>
int find(vector<T> vec, T x){
	for(int i=0;i<vec.size();i++){
		if(vec[i]==x)
			return i;
	}
	return -1;
}

class GRAPH {
protected:
	vector<vector <float> > weight;
	vector<int> camino;
	vector<string> disp;
	vector<float> pesos;
	int Vcnt, Ecnt;
	bool digraph;
public:
	GRAPH(int V, bool digrafo):weight(V),Vcnt(V),Ecnt(0),digraph(digrafo){
		camino.assign(V,0);
		pesos.assign(V,100000.0);
		disp.assign(V,"unvisited");
	}
	void clean(){
		for(int i=0; i<Vcnt;i++){
			disp[i]="unvisited";
			pesos[i]=100000.0;
			camino[i]=0;
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
	virtual void insert(Edge e)=0;
	virtual void remove(Edge e)=0;
	virtual bool edge(int u, int v)=0;
	virtual vector<int> neightbors(int u)=0;
	virtual void dfs(int u)=0;
	virtual void bfs(int s)=0;
	virtual float get_peso(int u, int v)=0;
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
			s=camino[s];
		}
		nodos.push_back(s);
		for(int i=nodos.size()-1;i>=0;i--){
			cout<<nodos[i]<<",";
		}
		cout<<endl;
	}
	void dijkstra2(int a, int b, float peso){
		vector<int> vecinos;
		int s=a;
		disp[s]="done";
		if(s==b){
			cout<<"Hacia "<<s<<": "<<peso+0.0<<endl;
			cout<<"Recorrido: "<<endl;
			recorrido(s);
		}
		else{
			vecinos=neightbors(s);
			pesos[s]=peso;
			for(unsigned int i=0;i<vecinos.size();i++){
				if(disp[vecinos[i]]!="done"){
					if(pesos[s]+get_peso(s,vecinos[i])<pesos[vecinos[i]]){
						pesos[vecinos[i]]=pesos[s]+get_peso(s,vecinos[i]);
						camino[vecinos[i]]=s;
					}
				}
			}
			int menor=menor_peso();
			if(menor>=0)
				dijkstra2(menor,b,pesos[menor]);
		}
	};
	void dijkstra(int s, int b, float peso){
		camino[s]=s;
		dijkstra2(s,b,peso);
		//clean();
		cout<<endl;
	};
};

class GRAPH_matriz : public GRAPH{
private:
	vector<vector <bool> > adj;
public:
	GRAPH_matriz(int V, bool digrafo = false):adj(V),GRAPH(V,digrafo){
		for (int i = 0; i < V; i++){
			adj[i].assign(V, false);
			weight[i].assign(V, 0);
		}
	}
	~GRAPH_matriz(){};
	void insert(Edge e){
		adj[e.u][e.v]=1;
		weight[e.u][e.v]=e.w;
		if(digraph){
			adj[e.v][e.u]=1;
			weight[e.v][e.u]=e.w;
		}
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
	float get_peso(int u, int v){
		return weight[u][v];
	};
	class adjIterator {
	private:
		const GRAPH_matriz &G;
		int i, v;
	public:
		adjIterator(const GRAPH_matriz &G, int v) :  G(G), v(v), i(-1) { }
		int beg() { i = -1; return nxt(); }
		int nxt() {
			for (i++; i < G.V(); i++)
				if (G.adj[v][i] == true) return i;
			return -1;
		}
		bool end() { return i >= G.V(); }
	};
};

class GRAPH_lista : public GRAPH{
private:
	vector<vector<int> > adj;
public:
	GRAPH_lista(int V, bool digrafo = false):adj(V),GRAPH(V,digrafo) {};
	~GRAPH_lista(){};
	void insert(Edge e){
		adj[e.u].push_back(e.v);
		weight[e.u].push_back(e.w);
		if(digraph){
			adj[e.v].push_back(e.u);
			weight[e.v].push_back(e.w);
		}
		Ecnt++;
	};
	void remove(Edge e){
		adj[e.v][e.w]=0;
		if(digraph)
			adj[e.w][e.v]=0;
		Ecnt--;
	};
	bool edge(int u, int v){
		return find(adj[u],v)>=0;
	};
	vector<int> neightbors(int u){
		return adj[u];
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
	float get_peso(int u, int v){
		return weight[u][find(adj[u],v)];
	}
	/*class adjIterator {
	private:
		const GRAPH_matriz &G;
		int i, v;
	public:
		adjIterator(const GRAPH_matriz &G, int v) :  G(G), v(v), i(-1) { }
		int beg() { i = -1; return nxt(); }
		int nxt() {
			for (i++; i < G.V(); i++)
				if (G.adj[v][i] == true) return i;
			return -1;
		}
		bool end() { return i >= G.V(); }
	};	*/
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
	unsigned t0,t1;
	int v,e;
	cin>>v>>e;
	int a,b;
	float w;
	GRAPH_lista grafo(v,0);
	for(int i=0;i<e;i++){
		cin>>a>>b>>w;
		Edge ed(a,b,w+0.0);
		grafo.insert(ed);
	}
	//show(grafo);
	cout<<"Grafo creado"<<endl;
	t0=clock();
	grafo.dijkstra(10,100,0.0);
	t1=clock();
	double time = (double(t1-t0)/CLOCKS_PER_SEC);
	cout << "Tiempo: " << time<<endl;
	return 0;
}

