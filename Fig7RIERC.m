%
%FMI - Chapter 1 - Fig 7
%


function RIERC = RIERCcal()
%compute the RI over Erasure channel with residual error
Range = 5000;

%overall loss rate
p = 0.01;

x=linspace(0, p, Range);

for i=1:Range
    %BSC
    y(1,i)= (p-x(1,i))/(1-p);
end

h = plot(x,y,'b-','LineWidth',1.5);

grid on

xlabel('Residual error rate','FontSize',12)
ylabel('Redundancy information','FontSize',12)



