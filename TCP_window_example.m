function tcp_win_ex()

x=0:30;


slow1=2.^(0:5);

lin1=(1:9)+slow1(6);


rw=(-.5*x)+50;


slow2=[2.^(0:4) lin1(8)/2];

lin2=(1:4)+lin1(8)/2;

windowsize=[slow1 lin1 rw(17:21) slow2 lin2];

plot(windowsize,'bo-'); hold all
plot(x,rw,'blackx-')
plot(x,[ones(1,15)*32 nan(1,5) ones(1,11)*20],'r--');

hold off;

legend('Contention window CW','Receiver window RW');

ylabel('Transmission window min(CW,RW) in kB');
xlabel('Transmission number');

plot_png_fixed('tcp_win',815,16/9.4);
