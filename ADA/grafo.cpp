#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <ctime>
#include <algorithm>
#include <queue>
#include <utility> 
using namespace std;

struct Edge {
	int u, v; float w;
	Edge(int u = -1, int v = -1, float w = -1.0) : u(u), v(v), w(w) { }
};

class compare {
public:
	inline bool operator()(pair<int, float> a, pair<int, float> b) {
		return a.second>b.second;
	}
};
class compare2 {
public:
	inline bool operator()(Edge a, Edge b) {
		return a.w>b.w;
	}
};

template<class T>
int find(vector<T> vec, T x) {
	for (unsigned int i = 0; i<vec.size(); i++) {
		if (vec[i] == x)
			return i;
	}
	return -1;
}

template<class T>
void insertar2(vector<T> &vec, T x) {
	int i = 0;
	for (; i<vec.size() && x<vec[i]; i++) {}
	vec.insert(vec.begin() + i, x);
}

template<class T>
bool buscar2(vector<T> &vec, T x) {
	int l = 0, r = vec.size() - 1, i;
	while (l<r) {
		i = (l + r) / 2;
		if (vec[i] == x)
			return 1;
		if (vec[i]>x)
			r = i - 1;
		else
			l = i + 1;
	}
	return 0;
}

typedef vector <int> vi;
vi pset;

void init(int N)
{
	pset.assign(N, 0);
	for (int i = 0; i < N; i++)
	{
		pset[i] = i;
	}
}

int find_set(int i)
{
	if (pset[i] == i)
	{
		return pset[i];
	}
	return pset[i] = find_set(pset[i]);
}
bool issameset(int i, int j)
{
	return find_set(i) == find_set(j);
}
void joinset(int i, int j)
{
	pset[find_set(i)] = find_set(j);
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
	GRAPH(int V, bool digrafo) :weight(V), Vcnt(V), Ecnt(0), digraph(digrafo) {
		camino.assign(V, -1);
		pesos.assign(V, 100000.0);
		disp.assign(V, "unvisited");
		init(V);
	}
	void clean() {
		for (int i = 0; i<Vcnt; i++) {
			disp[i] = "unvisited";
			pesos[i] = 100000.0;
			camino[i] = 0;
		}
	};
	~GRAPH() {};
	int V()const {
		return Vcnt;
	};
	int E()const {
		return Ecnt;
	};
	bool directed()const {
		return digraph;
	};
	virtual void insert(Edge e) = 0;
	virtual void remove(Edge e) = 0;
	virtual bool edge(int u, int v) = 0;
	virtual vector<int> neightbors(int u) = 0;
	virtual void dfs(int u) = 0;
	virtual void bfs(int s) = 0;
	virtual void llenar_cola(priority_queue<Edge, vector<Edge>, compare2> &cola) = 0;
	virtual float get_peso(int u, int v) = 0;
	void recorrido(int s) {
		if (camino[s] >= 0) {
			vector<int> nodos;
			while (s != camino[s]) {
				nodos.push_back(s);
				s = camino[s];
			}
			nodos.push_back(s);
			for (int i = nodos.size() - 1; i >= 0; i--) {
				cout << nodos[i] << ",";
			}
			cout << endl;
		}
		else
			cout << "No hay un camino que llegue al nodo " << s << endl;
	}
	void dijkstra(int s, int b) {
		camino[s] = s;
		pesos[s] = 0;
		vector<int> vecinos;
		float peso;
		float aux;
		priority_queue<pair<int, float>, vector<pair<int, float> >, compare > cola;
		do {
			disp[s] = "done";
			peso = pesos[s];
			vecinos = neightbors(s);
			for (unsigned int i = 0; i<vecinos.size(); i++) {
				if (disp[vecinos[i]] != "done") {
					aux = pesos[s] + get_peso(s,i);
					if (aux<pesos[vecinos[i]]) {
						pesos[vecinos[i]] = aux;
						camino[vecinos[i]] = s;
						cola.push(make_pair(vecinos[i], pesos[vecinos[i]]));
					}
				}
			}
			s = cola.top().first;
			cola.pop();
		} while (!cola.empty());
		cout << "Hacia " << b << ": " << pesos[b] << endl;
		cout << "Recorrido: " << endl;
		recorrido(b);
		//clean();
		cout << endl;
	};
	void Kruskal() {
		float peso_total = 0;
		Edge temp;
		priority_queue<Edge, vector<Edge>, compare2> cola;
		llenar_cola(cola);
		vector<Edge> MST;
		while (!cola.empty()) {
			temp = cola.top();
			cola.pop();
			if (!issameset(temp.u, temp.v)) {
				MST.push_back(temp);
				joinset(temp.u, temp.v);
			}
		}
		/*for (unsigned int i = 0; i<MST.size(); i++) {
		cout << MST[i].u << " - " << MST[i].v << endl;
		peso_total += MST[i].w;
		}*/
		cout << "Peso total: " << peso_total << endl;
	}
};

class GRAPH_matriz : public GRAPH {
private:
	vector<vector <bool> > adj;
public:
	GRAPH_matriz(int V, bool digrafo = false) :adj(V), GRAPH(V, digrafo) {
		for (int i = 0; i < V; i++) {
			adj[i].assign(V, false);
			weight[i].assign(V, 0);
		}
	}
	~GRAPH_matriz() {};
	void insert(Edge e) {
		adj[e.u][e.v] = 1;
		weight[e.u][e.v] = e.w;
		if (digraph) {
			adj[e.v][e.u] = 1;
			weight[e.v][e.u] = e.w;
		}
		Ecnt++;
	};
	void remove(Edge e) {
		adj[e.u][e.v] = 0.0;
		if (digraph)
			adj[e.v][e.u] = 0.0;
		Ecnt--;
	};
	bool edge(int u, int v) {
		return adj[u][v];
	};
	vector<int> neightbors(int u) {
		vector<int> vecinos;
		for (int i = 0; i<Vcnt; i++) {
			if (adj[u][i])
				vecinos.push_back(i);
		}
		return vecinos;
	}
	void dfs(int u) {
		cout << u << " -> ";
		disp[u] = "in_progress";
		vector<int> vecinos = neightbors(u);
		for (unsigned int i = 0; i<vecinos.size(); i++) {
			if (disp[vecinos[i]] == "unvisited") {
				dfs(vecinos[i]);
			}
		}
		disp[u] = "done";
	};
	void bfs(int s) {
		vector<vector<int> > L(Vcnt);
		L[0].push_back(s);
		for (int i = 0; i<Vcnt; i++) {
			for (unsigned int j = 0; j<L[i].size(); i++) {
				vector<int> vecinos = neightbors(L[i][j]);
				for (unsigned int k = 0; k<vecinos.size(); k++) {
					disp[vecinos[k]] = "visited";
					L[i + 1].push_back(vecinos[k]);
					cout << vecinos[k] << " -> ";
				}
			}
		}
	};
	float get_peso(int u, int v) {
		return weight[u][v];
	};
	class adjIterator {
	private:
		const GRAPH_matriz &G;
		int i, v;
	public:
		adjIterator(const GRAPH_matriz &G, int v) : G(G), v(v), i(-1) { }
		int beg() { i = -1; return nxt(); }
		int nxt() {
			for (i++; i < G.V(); i++)
				if (G.adj[v][i] == true) return i;
			return -1;
		}
		bool end() { return i >= G.V(); }
	};
};

class GRAPH_lista : public GRAPH {
private:
	vector<vector<int> > adj;
public:
	GRAPH_lista(int V, bool digrafo = false) :adj(V), GRAPH(V, digrafo) {};
	~GRAPH_lista() {};
	void insert(Edge e) {
		adj[e.u].push_back(e.v);
		weight[e.u].push_back(e.w);
		if (digraph) {
			adj[e.v].push_back(e.u);
			weight[e.v].push_back(e.w);
		}
		Ecnt++;
	};
	void remove(Edge e) {
		/*adj[e.v][e.w] = 0;
		if (digraph)
		adj[e.w][e.v] = 0;
		Ecnt--;*/
	};
	bool edge(int u, int v) {
		return find(adj[u], v) >= 0;
	};
	vector<int> neightbors(int u) {
		return adj[u];
	}
	void dfs(int u) {
		cout << u << " -> ";
		disp[u] = "in_progress";
		vector<int> vecinos = neightbors(u);
		for (unsigned int i = 0; i<vecinos.size(); i++) {
			if (disp[vecinos[i]] == "unvisited") {
				dfs(vecinos[i]);
			}
		}
		disp[u] = "done";
	};
	void bfs(int s) {
		vector<vector<int> > L(Vcnt);
		L[0].push_back(s);
		for (int i = 0; i<Vcnt; i++) {
			for (unsigned int j = 0; j<L[i].size(); i++) {
				vector<int> vecinos = neightbors(L[i][j]);
				for (unsigned int k = 0; k<vecinos.size(); k++) {
					disp[vecinos[k]] = "visited";
					L[i + 1].push_back(vecinos[k]);
					cout << vecinos[k] << " -> ";
				}
			}
		}
	};
	inline float get_peso(int u, int v) {
		return weight[u][v];
	}
	void llenar_cola(priority_queue<Edge, vector<Edge>, compare2> &cola) {
		Edge arista;
		for (int i = 0; i<Vcnt; i++) {
			for (unsigned int j = 0; j<adj[i].size(); j++) {
				cola.push(Edge(i, adj[i][j], weight[i][j]));
			}
		}
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
void insertar(G grafo, string nodo) {
	
}

int main(int argc, char *argv[]) {
	unsigned t0, t1;
	int v, e;
	cin >> v >> e;
	int a, b;
	float w;
	GRAPH_lista grafo(v, 1);
	for (int i = 0; i<e; i++) {
		cin >> a >> b >> w;
		Edge ed(a, b, w);
		grafo.insert(ed);
	}
	//show(grafo);
	cout << "Grafo creado" << endl;
	t0 = clock();
	grafo.dijkstra(10,100);
	t1 = clock();
	double time = (double(t1 - t0) / CLOCKS_PER_SEC);
	cout << "Tiempo: " << time << endl;
	return 0;
}

