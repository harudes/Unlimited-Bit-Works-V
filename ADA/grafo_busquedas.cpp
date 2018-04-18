#include <iostream>
#include <vector>
using namespace std;

template <class T>
int dfs(T u, int cur_time){
	u.start_time=cur_time;
	cur_time++;
	u.status = "in_progress";
	for(int i=0;i<u.neightbors.size();i++){
		if(u.neightbors[i].status=="unvisited"){
			cur_time=(dfs(u.neightbors[i]),cur_time);
			cur_time++;
		}
	}
	u.end_time = cur_time;
	u.status="done";
	return cur_time;
}

template <class T>
void bfs(T s, int n){
	vector<vector<T> > L(n);
	L[0].push_back(s);
	for(int i=0;i<n;i++){
		for(int j=0; j<L[i].size();i++){
			for(int k=0;k<L[i][j].neightbors.size();k++){
				L[i][j].neightbors[k].status="visited";
				L[i+1].push_back(L[i][j].neightbors[k]);
			}
		}
	}
}

int main(int argc, char *argv[]) {
	
	return 0;
}

