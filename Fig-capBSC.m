%
%FMI - Chapter 1 - Fig 4
%


function capBSC = capBSCcal()
%compute the capacity of BSC channel
Range = 5000;
x=linspace(0, 1, Range);

for i=1:Range
    %BSC
    y(1,i)= 1 - entropycal(x(1,i));
end

plot(x,y,'b-','LineWidth',1.5)

grid on

xlabel('Error probability','FontSize',12)
ylabel('Channel capacity','FontSize',12)


%input
%p  :   error rate
%output
%h  :   entropy value
function h = entropycal(p)
%compute the entropy
    h = -p*log(p) - (1-p)*log(1-p);
