%
%FMI - Chapter 1 - Fig xx
%


function GE = GEtest()
%compare SGE channel and i.i.d. channel


%packet num
pktnum = 10;
%average packet error rate
pe = 0.10;

%
x=1:pktnum;

for i=1:pktnum
    %i.i.d
    y1(1,i) = cnmper(pktnum,i,pe);
    %SGE, correlation 0
    y2(1,i) = PLRcal(i,pktnum,pe,0);
    %SGE, correlation 0.10
    y3(1,i) = PLRcal(i,pktnum,pe,0.10);
    %SGE, correlation 0.50
    y4(1,i) = PLRcal(i,pktnum,pe,0.50);
end

%normal plot
%h = plot(x,y1,'g-+',x,y2,'b--x',x,y3,'k-.*',x,y4,'m:o','LineWidth',1);

%log y
h = semilogy(x,y1,'g-+',x,y2,'b--x',x,y3,'k-.*',x,y4,'m:o','LineWidth',1);

%log x
%h = semilogx(x,y1,'g-+',x,y2,'b--x',x,y3,'k-.*',x,y4,'m:o','LineWidth',1);

%log x, log y
%h = loglog(x,y1,'g-+',x,y2,'b--x',x,y3,'k-.*',x,y4,'m:o','LineWidth',1);

%set x limit
set(gca,'XLim',[1 pktnum]);

%set x scale for log x!!!
%set(gca,'XMinorTick','off');
%set(gca,'XTick',[1 5 pktnum]);

grid on

xlabel('Number of packet loss in a sequence of 10 packets','FontSize',12)
ylabel('Probability','FontSize',12)
legend('i.i.d. channel','SGE channel, correlation 0.00','SGE channel, correlation 0.10','SGE channel, correlation 0.50')



%
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