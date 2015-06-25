function [ri, rir1, rir2]=scenario(plr1,plr2,plr_target)

%plr1=1e-1;
%plr2=1e-1;
%plr_target=1e-1;

delay1=50;
delay2=10;

fprintf('\nplr1: %g%%,\tplr2: %g%%,\tplr_target: %g%%\n',plr1*100,plr2*100,plr_target*100);

%% e2e
plre2e=(1-(1-plr1)*(1-plr2));
ri=res_ri(plre2e,plr_target);


%% ll
maxplrt = plr_target;
%maxplrt = min(plr_target,plr1);
step = maxplrt/20000;
plrt1=0:step:maxplrt;
xlimits=[min(plrt1),max(plrt1)]; % for plot
plrt=plrt1;
length(plrt1);

[rri1,plrt1]=res_ri(plr1,plrt1);
plrt2=rest_loss(plrt1,plr_target);
test=1-(1-plrt2).*(1-plrt1)-plr_target; % should be zero
rri2=res_ri(plr2,plrt2);
rri=(rri1+rri2)/2;
%rri=rri1+rri2;
ratio=rri./ri;
simpleratio=(plr1+plr2-2*plr1*plr2)./2./(plr1+plr2-plr1*plr2);

rir1=rri1./ri;
rir2=rri2./ri;

d1 = delay1.*(1+rri1);
d2 = delay2.*(1+rri2);
de2e = (delay1+delay2).*(1+ri);
dll = d1+d2;


%% plot
clf;

%ratio plot
%subplot(4,2,[1,2]);
plot(plrt,ones(1,length(plrt)),'black--',plrt,ratio,'r-','linewidth',1);
xlabel('\lambda_{ r }[1]');
ylabel('RI relative to RI_{e2e}');
title({['\lambda[1]  = ' num2str(plr1) ',  \lambda[2]  = ' num2str(plr2) ',  \lambda_{target} = ' num2str(plr_target) ];
%    [];
%    ['Ratio RI_{ll} / RI_{e2e} (simplified ratio: ' num2str(simpleratio) ')']});
%    ['Ratio RI_{ll} / RI_{e2e}']
    });
xlim(xlimits);
ylim([0.45 1.01]);
grid on;
legend('RI_{e2e}','avg. RI_{ll}','RI link_1','RI link_2');

plot_png_fixed(['ri_overall',num2str(plr_target)],600,16/9)


clf;

%ratio plot
%subplot(4,2,[1,2]);
semilogy(plrt,ones(1,length(plrt)),'black',plrt,rir1,'b',plrt,rir2,'g--','linewidth',1);
xlabel('\lambda_{ r }[1]');
ylabel('RI relative to RI_{e2e}');
title({['\lambda[1]  = ' num2str(plr1) ',  \lambda[2]  = ' num2str(plr2) ',  \lambda_{target} = ' num2str(plr_target) ];
%    [];
%    ['Ratio RI_{ll} / RI_{e2e} (simplified ratio: ' num2str(simpleratio) ')']});
%    ['Ratio RI_{ll} / RI_{e2e}']
    });
xlim([0,plrt1(find(rir1==0,1))]);
ylim([0 5]);
grid on;
legend('RI_{e2e}','RI link_1','RI link_2');

plot_png_fixed(['ri_per_link',num2str(plr_target)],600,16/9)

rir1=min(rir1);
rir2=min(rir2);

return;


zero=find(rri==min(rri),1);
fprintf('E2E:\n\tRI/link:\t%.5f\n',ri);
fprintf('LL:\n\tMin RI/link:\t%.5g @ plr_target1 = %.5g%%\n',rri(zero),plrt1(zero)*100);
fprintf('Distribution:\n \tri1 = %.6g\tri2 = %.6g\n',rri1(zero),rri2(zero));

subplot(4,2,[3,5,7]);
plot(plrt,ones(1,length(plrt)).*ri,'rx',plrt,rri1,'g',plrt,rri2,'b',plrt,rri,'black--',plrt1(zero),rri(zero),'blackx--');
legend('RI_{e2e} per link','RI_1','RI_2','(RI_1+RI_2)/2');
%plot(plrt1,ones(1,length(plrt1)).*plre2e,'rx',plrt1,plrt1,'g',plrt1,plrt2,'b');
%legend('ri_{E2E} per link','ri_1','ri_2');
grid on;
ylabel('RI');
xlabel('plr_{target1}');
ylim([0 ri*1.3]);
xlim(xlimits);
title('RI');

%subplot(1,3,2);
%plot(plrt1,ce2e,'rx',plrt1,c1,'g',plrt1,c2,'b',plrt1(zero),cll(zero),'blackx',plrt1,cll,'black--');
%grid on;
%ylabel('cost');

zero=find(dll==min(dll),1);
subplot(4,2,[4,6,8]);
plot(plrt,ones(1,length(plrt)).*de2e,'rx',plrt,d1,'g',plrt,d2,'b',plrt,dll,'black--',plrt(zero),dll(zero),'blackx');
legend('d_{E2E}',['d_1 (' num2str(delay1) 'ms)'],['d_2 (' num2str(delay2) 'ms)'],'d_1+d_2','min(d1+d2)');
grid on;
ylabel('delay');
xlabel('plr_{target1}');
ylim([0 de2e*1.3]);
xlim(xlimits);
title('Delay');