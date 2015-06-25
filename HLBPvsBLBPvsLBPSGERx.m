%
%FMI - Chapter 2.4 - Fig xx
%

function machecriex = machecriexcal()
%HLBPvsBLBPvsLBP over SGE channel, RI with different number of receivers

x=1:1:50;
k=20;
m=7;
c=0.10;
for i=1:1:50
    %HLBP Theoretical, CHT
    yt2(1,i)=(0.518 + (hlbpgeexptcal(k,m,0.10,c,i)-1) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
end
x1=1:1:50;
for i=1:1:50
    %Ideal LBP Theoretical, CHT
    yt4(1,i)=lbpgeexptcal(m,0.10,c,i) * 0.5753/0.518 - 1;
end
x2=1:1:50;
for i=1:1:50
    %BLBP Theoretical, CHT
    yt6(1,i)=blbpgeexptcal(m,0.10,c,i) * 0.64333/0.518 - 1;
end

%simulation
z=[1 3 5 7 9 11 13 15];
z1=[1 3 5 7 9];%need more simulation
%HLBP Simulation
%k=20
%p=0.10
ys2=[1.11182    1.18025     1.21087     1.23017     1.24455     1.25547     1.26493     1.27269];
%LBP
%expt
ys3=[1.12374    1.40804     1.75516     2.14588     2.63309];
%feedback
ys4=[0.00000    0.00544     0.0114      0.0109      0.01270];
%BLBP
ys6=[1.12348    1.34031     1.52302     1.67857     1.81072     1.92495     2.02321     2.10934];

%calculate the CHT
for i=1:8
    %HLBP
    y2(1,i) = (0.518 + (ys2(1,i)-1) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
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

%LBP GE expt
function lbpexpt = lbpgeexptcal(m,p,c,r)
%Expected number of transmissions of LBP over GE model
%probability from Bad to Bad
a = p + c*(1-p);
%probability from Good to Good
b = (1-p)+c*p;
%
sum = 1;
temp0 = 0;
for i=1:r
    temp0 = temp0 + (fact(r)/(fact(i)*fact(r-i)))*(p^i)*((1-p)^(r-i));
end
sum = sum + temp0;
temp1 = 0;
for i=1:r
    temp1 = temp1 + (fact(r)/(fact(i)*fact(r-i)))*(p^i)*((1-p)^(r-i))*(1-((1-a)^i)*(b^(r-i)));
end
sum=sum+temp1;
temp2 = 0;
for i=4:m+1
    %temp = temp + (1 - (1 - p)^r)^(i-1);
    temp2 = temp2 + temp1*(((1 - (1-p)^r))^(i-3));
end
sum = sum + temp2;
lbpexpt = sum;

%BLBP GE expt
function blbpexpt = blbpgeexptcal(m,p,c,r)
%Expected number of transmissions of BLBP over GE model
%probability from Bad to Bad
a = p + c*(1-p);
%probability from Good to Good
b = (1-p)+c*p;
%main function
sum = 1;
for i=2:(m+1)
    sum = sum + 1 - (1 - PLRcal(i-1,i-1,a,b))^r;
end
blbpexpt = sum;

%HLBP GE expt
function hlbpexpt = hlbpgeexptcal(k,m,p,c,r)
%Expected number of transmissions of HLBP over GE model
%probability from Bad to Bad
a = p + c*(1-p);
%probability from Good to Good
b = (1-p)+c*p;
%main function
sum = k;
for i=1:m
    temp = 0;
    for j=0:i-1
        x = j;
        if k-1 < j
            x = k-1;
        end
        for l=0:x
            temp = temp + (fact(k-1)/(fact(l)*fact(k-1-l)))*(p^l)*((1-p)^(k-1-l))*PLRcal(j-l,i,a,b);
        end
    end
    sum = sum + 1 - temp^r;
    %sum = sum + 1 - (1 - PLRcal(i-1,i-1,a,b))^r;
end
hlbpexpt = sum/k;


%functions
function PLR = PLRcal(k,n,a,b)
%probability that k errors in n transmissions
    PLR = PLRGcal(k,n,a,b) + PLRBcal(k,n,a,b);

function PLRG = PLRGcal(k,n,a,b)
%probability that k errors in n transmissions ending in state Good
    if (k==0 && n==0)
        PLRG = (1-a)/(2-a-b);
    else if (n==0)
            PLRG = 0;
        else
            PLRG = PLRGcal(k,n-1,a,b)*b + PLRBcal(k,n-1,a,b)*(1-a);
        end
    end

function PLRB = PLRBcal(k,n,a,b)
%probability that k errors in n transmissions ending in state Bad
    if (k==0 && n==0)
        PLRB = (1-b)/(2-a-b);
    else if (n==0)
            PLRB = 0;
        else
            PLRB = PLRBcal(k-1,n-1,a,b)*a + PLRGcal(k-1,n-1,a,b)*(1-b);
        end
    end

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