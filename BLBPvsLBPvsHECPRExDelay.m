%
%FMI - Chapter 2.4 - Fig xx
%

function avgtran = blbphec()
%BLBPvsLBPvsHEC-PR over SGE channel, Delay with different error rates

z=[0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10];

%BLBP R=1357
%delay 1ms
ys2=[5.060   6.390    7.210    7.237    7.228    8.056    8.002    8.300    9.164    9.858    10.623];
%LBP
ys4=[8.786  26.178   27.232   29.732   30.716   31.739   32.928   33.671   34.705   39.007   40.741];
%HEC-PR R=1357
ys6=[24.6740    49.656      57.605      60.201      59.674      62.617      68.595  68.593  72.129   73.706 75.746];


plot(z,ys2,'k--x',z,ys4,'r-.*',z,ys6,'g:o','LineWidth',1);

grid
xlabel('Error rates','FontSize',12)
ylabel('Maximum multicast delay (ms)','FontSize',12)
legend('BLBP','LBP','HEC-PR')
