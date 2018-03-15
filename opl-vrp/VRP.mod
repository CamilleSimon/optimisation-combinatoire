/*********************************************
 * OPL 12.8.0.0 Model
 * Author: user
 * Creation Date: 21 févr. 2018 at 18:11:41
 *********************************************/


int n = ...;
range clients = 1..(n-1);
range nodes = 0..(n-1);

int K = ...;
range vehicules = 1..K;

int Q = ...;

float cost[nodes][nodes] = ...;

dvar boolean x[nodes, nodes, vehicules];

dvar int pos[nodes];

dexpr float TotalCost = sum (i in clients, j in clients, k in vehicules : i != j) cost[i][j] * x[i,j,k];

minimize TotalCost;
subject to {
	pos[0] == 0;

	forall(i in clients)
		sum(k in vehicules, j in nodes : i != j) x[i,j,k] == 1;
		
	forall(j in clients, k in vehicules)
		sum(i in nodes) x[i,j,k] == sum(l in nodes) x[j,l,k];
		
	forall(k in vehicules)
		sum(j in clients) x[0,j,k] == 1;
		
	forall(k in vehicules)
		sum(i in nodes) x[i,0,k] == 1;
		
	forall(k in vehicules)
		sum(i in clients) sum(j in nodes : i != j) x[i,j,k] <= Q;
		
	forall(i in clients, j in clients , k in vehicules : i != j)
		pos[j] >= pos[i] + 1 - n * (1 - x[i,j,k]);
		
	forall(j in clients)
	  	pos[j] <= n - 1;
}

execute {
	write("Distance totale parcourue par tous les véhicules : ");
	writeln(TotalCost);
}