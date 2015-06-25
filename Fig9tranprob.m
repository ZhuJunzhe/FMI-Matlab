%
%FMI - Chapter 1 - Fig 9
%


function tranprob = tranprobcal()
%show the i-step transition probability for a state trellis starting in B and
%ending in B, error rate 0.10 and various correlations



%%%test
%tranprob = probcal(0.10, -0.90, 1);
%return;
%%%test

%num of steps
Range = 50;
%packet error rate
p = 0.10;

x=1:Range;

for i=1:Range
    %various t
    y1(1,i)= probcal(p,-0.9,i);
    y2(1,i)= probcal(p,-0.5,i);
    y3(1,i)= probcal(p, 0, i);
    y4(1,i)= probcal(p, 0.5,i);
    y5(1,i)= probcal(p, 0.9,i);
end

h = plot(x,y1,'g-',x,y2,'b',x,y3,'k',x,y4,'m',x,y5,'r','LineWidth',2);

grid on

xlabel('Number of transition steps','FontSize',12)
ylabel('Probability in state B','FontSize',12)
legend('correlation -0.90','correlation -0.50','correlation  0.00','correlation  0.50','correlation  0.90')


%input
%p  :   average packet loss rate
%t  :   temporal error correlation
%k  :   number of transition steps
%output
%prob   :   probability in B
function prob = probcal(p,t,k)
%compute the i-step transition probability for a state trellis starting in B and
%ending in B, error rate 0.10 and various correlations

%transition matrix
a = t + p*(1-t);
b = 1 - p*(1-t);

M = [b      1-b
     1-a    a  ];

%start vector
V = [0 1];

%k-step transition
U = V*(M^k);

%return
prob = U(1,2);
%test
%prob = U;

