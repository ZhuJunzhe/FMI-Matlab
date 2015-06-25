#include <stdio.h>
#include <math.h>

#define MaxLen 101

void SeqProbSGE(int n, double pe, double corr);

main() {
	int n;
	double pe,corr;
	//
	n = 100;
	pe = 0.10;
	corr = 0.50;
	printf("Sequence length %d, error rate %f, correlation %f\n",n,pe,corr);
	printf("The probability of loss 0 - %d packets:\n",n);
	SeqProbSGE(n,pe,corr);
}

//Sequence probability for Simplified GE channel
//input
//	n:		sequence length;
//	pe:		average error rate
//	corr:		loss correlation
void SeqProbSGE(int n, double pe, double corr) {
	//
	//double probtable[MaxLen,MaxLen];	//not needed;
	double probGtable[MaxLen][MaxLen];	//end in G
	double probBtable[MaxLen][MaxLen];	//end in B
	//
	double a,b;
	int i,j;
	//GE
	a = pe + corr*(1-pe);
	b = (1-pe) + corr*pe;
	//init
	//PG[x,0]=0;PB[x,0]=0;PG[i,i]=0;PB[0,x]=0;
	for(i=0;i<MaxLen;i++) {
		for(j=0;j<MaxLen;j++) {
			probGtable[i][j] = 0;
			probBtable[i][j] = 0;
		}
	}
	//Seg initial value for k==0 and n==0
	probGtable[0][0] = (1-a)/(2-a-b);
	probBtable[0][0] = (1-b)/(2-a-b);
	//
	for(i=1;i<MaxLen;i++) {//n
		//for j==0
		probGtable[0][i] = probGtable[0][i-1]*b + probBtable[0][i-1]*(1-a);
		//
		for(j=1;j<i;j++) {//k
			probGtable[j][i] = probGtable[j][i-1]*b + probBtable[j][i-1]*(1-a);
			probBtable[j][i] = probGtable[j-1][i-1]*(1-b) + probBtable[j-1][i-1]*a;
		}
		//for j==i
		probBtable[i][i] = probGtable[i-1][i-1]*(1-b) + probBtable[i-1][i-1]*a;
	}
	//
	//print resoults
	double sum,plr;
	sum = 0;
	plr = 0;
	for(j=0;j<n+1;j++) {
		printf("%.10f\n",probGtable[j][n]+probBtable[j][n]);
		sum = sum + probGtable[j][n]+probBtable[j][n];
		plr = plr + j*(probGtable[j][n]+probBtable[j][n]);
	}
	plr = plr/n;
	printf("The sum probability is %.10f\n",sum);
	printf("The actual average plr is %.10f\n",plr);
}
