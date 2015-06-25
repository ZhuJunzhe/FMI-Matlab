%
%FMI - Chapter 2.4 - Fig xx
%

function RISGECorrx = RISGECorrxCal()
%HLBPvsBLBPvsLBP over SGE channel, RI with different correlation rates

z=[0.0 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50];
k=35;

%HLBP Simulation
ys2=[1.19715    1.19949     1.20057     1.20192     1.20337     1.20369     1.20559     1.20791     1.21047     1.21371     1.21727];

%BLBP Simulation
ys8=[1.59741    1.63585     1.67857     1.72500     1.77698     1.83501     1.90113     1.97750     2.06561     2.16882     2.29279];

%LBP
ys10=[2.06320   2.09990     2.14588     2.19588     2.25696     2.32770     2.40473     2.49567     2.59817     2.72333     2.87109];
ys11=[0.01000   0.01097     0.01094     0.01091     0.01108     0.01120     0.01097     0.01156     0.01109     0.01131     0.01164];
    
%calculate the CHT
for i=1:11
    %HLBP
    y2(1,i) = (0.518 + (ys2(1,i)-1) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
    %BLBP
    y6(1,i) = ys8(1,i) * 0.64333/0.518 - 1;
    %LBP
    y8(1,i) = (ys10(1,i) * 0.5753 + ys11(1,i) * 0.154)/0.518 - 1;
end

plot(z,y2,'b-+',z,y6,'k--x',z,y8,'r-.*','LineWidth',1);


grid
xlabel('Temporal error correlation','FontSize',12)
ylabel('RI','FontSize',12)
legend('HLBP','BLBP','LBP')
