%
%FMI - Chapter 2.4 - Fig xx
%

function RIiidRx = RIiidRxCal()
%HLBPvsBLBPvsLBP over i.i.d. channel, RI with different number of receivers

x=1:1:50;
k=35;
m=7;

for i=1:1:50
    %HLBP Theoretical, CHT
    yt2(1,i)=(0.518 + (hlbpexptcal(k,0.10,i)-1) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
end
x1=1:1:50;
for i=1:1:50
    %Ideal LBP Theoretical, CHT
    yt4(1,i)=lbpexptcal(m,0.10,i) * 0.5753/0.518 - 1;
end
x2=1:1:50;
for i=1:1:50
    %BLBP Theoretical, CHT
    yt6(1,i)=blbpexptcal(m,0.10,i) * 0.64333/0.518 - 1;
end

%simulation
z=[1 3 5 7 9 11 13 15];
z1=[1 3 5 7 9];%need more simulation
%HLBP Simulation
ys2=[0.11106    0.16218     0.18370     0.19715     0.20687     0.21435     0.22064     0.22589];
%LBP
%expt
ys3=[1.11123    1.37014     1.69248     2.10096     2.60183];
%feedback
ys4=[0.00000    0.00544     0.0114      0.0109      0.01270];
%BLBP
ys6=[1.11114    1.30408     1.46398     1.59741     1.70896     1.80290     1.88315     1.95033];

%calculate the CHT
for i=1:8
    %HLBP
    y2(1,i) = (0.518 + ys2(1,i) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
    %BLBP
    y6(1,i) = ys6(1,i) * 0.64333/0.518 - 1;
end
for i=1:5
    %LBP
    y4(1,i) = (ys3(1,i) * 0.5753 + ys4(1,i) * 0.154)/0.518 - 1;
end

plot(x,yt2,'b-',z,y2,'b+',x2,yt6,'k--',z,y6,'kx',x1,yt4,'r-.',z1,y4,'r*','LineWidth',1)

grid
xlabel('Number of receivers','FontSize',12)
ylabel('RI','FontSize',12)
legend('HLBP Theoretical','HLBP Simulation','BLBP Theoretical','BLBP Simulation','LBP Theoretical','LBP Simulation')
%legend('boxoff')

function expt = lbpexptcal(m,p,r)
%compute the expected number of transmission of BLBP
    sum = 0;
    for i=1:m+1
        sum = sum + (1 - (1 - p)^r)^(i-1);
    end
    expt = sum;
    
    
function expt = blbpexptcal(m,p,r)
%compute the expected number of transmission of BLBP
    sum = 0;
    for i=1:m+1
        sum = sum + 1 - (1 - p^(i-1))^r;
    end
    expt = sum;
    

function hlbpexpt = hlbpexptcal(k,p,r)
%Expected number of transmissions of HLBP
    pt = 0.000001;
    expt = k;
    for i=1:k
        pk = 0;
        for j=k:(k+i-1)
            pk = pk + (fact(k+i-1)/(fact(j)*fact(k+i-1-j)))*((1-p)^j)*(p^(k+i-1-j));    
        end
        expt = expt + 1 - (pk)^r;
        if 1-pk <= pt
            break;
        end
    end
    hlbpexpt = expt/k;
    
    
function fact = fact(m)
%compute fact
    sum = 1;
    for i=1:m
        sum = sum*i;
    end
    if m == 0
        sum = 1;
    end
    fact = sum;