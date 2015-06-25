%
%FMI - Chapter 2.4 - Fig xx
%

function RISGEDx = RISGEDxCal()
%HLBPvsBLBPvsLBPvsHARQI over SGE channel, RI with different delay constraints


z=[20 40 60 80 100];
k=[4 12 20 28 35];
z1=[40 60 80 100];

%HLBP Simulation
ys2=[1.39785    1.26806     1.23016     1.21054     1.19927];

%HARQ Type I
ys4=[1.166987   0.578336    0.377767    0.320087    0.282912];

%HARQ Type I feedback
ys6=[0.0000     0.0130      0.0174      0.0181      0.0161];

%BLBP Simulation
ys8=[1.67857    1.67857     1.67857     1.67857     1.67857];

%LBP simulation
ys10=[2.14588   2.14588     2.14588     2.14588];
ys11=[0.0109    0.0109      0.0109      0.0109];

%calculate the CHT
for i=1:5
    %HLBP
    y2(1,i) = (0.518 + (ys2(1,i)-1) * 0.64333 + (0.64333 - 0.518)/k(1,i))/0.518 - 1;
    %HARQ Type I
    y4(1,i) = ((ys4(1,i)+1) * 0.518 + ys6(1,i) * 0.154)/0.518 - 1;
    %BLBP
    y6(1,i) = ys8(1,i) * 0.64333/0.518 - 1;
end
for i=1:4
    %LBP
    y8(1,i) = (ys10(1,i) * 0.5753 + ys11(1,i) * 0.154)/0.518 - 1;
end

plot(z,y2,'b-+',z,y6,'k--x',z1,y8,'r-.*',z,y4,'g:o','LineWidth',1);

grid
xlabel('Delay constraints (ms)','FontSize',12)
ylabel('RI','FontSize',12)
legend('HLBP','BLBP','LBP','HARQ Type I')