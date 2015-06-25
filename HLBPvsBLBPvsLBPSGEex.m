%
%FMI - Chapter 2.4 - Fig xx
%

function RISGEEx = RISGEExCal()
%HLBPvsBLBPvsLBP over SGE channel, RI with different error rates


z=[0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10];
k=35;

%average transmission
%BLBP R=7
ys2=[1.00005    1.07658     1.15042     1.22224     1.29197     1.36015     1.42622     1.49110     1.55471     1.61712     1.67857];
%LBP R=7
ys4=[1.00072    1.08174     1.16876     1.26380     1.36630     1.47615     1.59946     1.72709     1.87361     2.03324     2.20995];
%LBP average feedback R=7
ys6=[0.00062    0.0026      0.0044      0.0064      0.0063      0.0097      0.0084      0.0136      0.0100      0.0105      0.0109];
%HLBP R=7
ys8=[1.00003    1.03629     1.05730     1.07634     1.09442     1.11202     1.12952     1.14671     1.16415     1.18172     1.19927];

%calculate the CHT
for i=1:11
    %BLBP
    y2(1,i) = ys2(1,i) * 0.64333/0.518 - 1;
    %LBP
    y4(1,i) = (ys4(1,i) * 0.5753 + ys6(1,i) * 0.154)/0.518 - 1;
    %HLBP
    y6(1,i) = (0.518 + (ys8(1,i)-1) * 0.64333 + (0.64333 - 0.518)/k)/0.518 - 1;
end

plot(z,y6,'b-+',z,y2,'k--x',z,y4,'r-.*','LineWidth',1);

grid
xlabel('Error rates','FontSize',12)
ylabel('RI','FontSize',12)
legend('HLBP','BLBP','LBP')