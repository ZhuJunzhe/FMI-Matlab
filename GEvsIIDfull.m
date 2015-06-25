%
%FMI - Chapter 1 - Fig xx
%


function GE = GEtest()
%compare SGE channel and i.i.d. channel


%packet num
pktnum = 100;
%average packet error rate
pe = 0.10;

%
x=0:pktnum;

for i=1:pktnum+1
    %i.i.d
    y1(1,i) = cnmper(pktnum,i-1,pe);
    if y1(1,i) < 1e-10
        y1(1,i) = 0.0;
    end
    %SGE, correlation 0
%     y2(1,i) = PLRcal(i-1,pktnum,pe,0);
%     %SGE, correlation 0.10
%     y3(1,i) = PLRcal(i-1,pktnum,pe,0.10);
%     %SGE, correlation 0.50
%     y4(1,i) = PLRcal(i-1,pktnum,pe,0.50);
    %%
    %SGE, correlation 0
    y2(1,i) = PLRTcal(i-1,pktnum,pe,0);
    if y2(1,i) < 1e-10
        y2(1,i) = 0.0;
    end
    %SGE, correlation 0.10
    y3(1,i) = PLRTcal(i-1,pktnum,pe,0.10);
    if y3(1,i) < 1e-10
        y3(1,i) = 0.0;
    end
    %SGE, correlation 0.50
    y4(1,i) = PLRTcal(i-1,pktnum,pe,0.50);
    if y4(1,i) < 1e-10
        y4(1,i) = 0.0;
    end
end



%normal plot
%h = plot(x,y1,'g-',x,y2,'b--',x,y3,'k-.',x,y4,'m:','LineWidth',1);

%log y
h = semilogy(x,y1,'g-',x,y2,'b--',x,y3,'k-.',x,y4,'m:','LineWidth',1);

%log x
%h = semilogx(x,y1,'g-',x,y2,'b--',x,y3,'k-.',x,y4,'m:','LineWidth',1);

%log x, log y
%h = loglog(x,y1,'g-',x,y2,'b--',x,y3,'k-.',x,y4,'m:','LineWidth',1);

%set x limit
set(gca,'XLim',[0 pktnum]);
%set(gca,'YLim',[1e-10 0.5]);


%set x scale for log x!!!
%set(gca,'XMinorTick','off');
%set(gca,'XTick',[0 20 40 60 80 pktnum]);

%set y scale for log y!!!
%set(gca,'YMinorTick','off');
%set(gca,'YTick',[1e-10 1e-8 1e-6 1e-4 1e-2 0.1 0.2]);


grid on

xlabel('Number of packet loss in a sequence of 100 packets','FontSize',12)
ylabel('Probability','FontSize',12)
legend('i.i.d. channel','SGE channel, correlation 0.00','SGE channel, correlation 0.10','SGE channel, correlation 0.50')


%GE sequence probability using tables
function PLR = PLRTcal(k,n,pe,corr)
%GE
a = pe + corr*(1-pe);
b = (1-pe) + corr*pe;
%init, [i,j] denotes i-1 errors in j-1 symbols
for i=1:n+1
    for j=1:n+1
        probGtable(i,j) = 0;
        probBtable(i,j) = 0;
    end
end
%Set initial value for k==0 and n==0
probGtable(1,1) = (1-a)/(2-a-b);
probBtable(1,1) = (1-b)/(2-a-b);
%%
for i=2:n+1
    %for j==0
    probGtable(1,i) = probGtable(1,i-1)*b + probBtable(1,i-1)*(1-a);
    %%
    for j=2:i-1
        probGtable(j,i) = probGtable(j,i-1)*b + probBtable(j,i-1)*(1-a);
        probBtable(j,i) = probGtable(j-1,i-1)*(1-b) + probBtable(j-1,i-1)*a;
    end
    %for j==i
    probBtable(i,i) = probGtable(i-1,i-1)*(1-b) + probBtable(i-1,i-1)*a;
end
%test
% sum = 0;
% plr = 0;
% for i=1:n+1
%     p = probGtable(i,n+1) + probBtable(i,n+1);
%     sum = sum + p;
%     plr = plr + p*(i-1);
% end
% sumprob = sum
% realplr = plr/n
%test end
PLR = probGtable(k+1,n+1) + probBtable(k+1,n+1);
    
    


%sequence probability using recursion---start
function PLR = PLRcal(k,n,pe,corr)
%probability that k errors in n transmissions
    a = pe + corr*(1-pe);
    b = (1-pe) + corr*pe;
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
%sequence probability using recursion---end


function cnmp = cnmper(n,m,per)
%calculate cnm(n,m)*per^m*(1-per)^(n-m)
    sum = 1.0;
    for i=1:m
        sum = sum*per*(n-i+1)/(m-i+1);
    end
    sum = sum*((1-per)^(n-m));
    cnmp = sum;

function cnm = cnmcal(n,m)
%get m of n, n!/(m!(n-m)!)
    sum = 1;
    for i=1:m
        sum = sum*(n-i+1)/(m-i+1);
    end
    cnm = sum;


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