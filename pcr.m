function pcr()

clear all;
close all;

fs=25; % Hz, number of PCR samples per second
samples=2e3; % number of PCR samples in total
time=samples/fs; % in seconds

clockdev = 30000*27e0; % 30 ppm is allowed

refclock=27e6; % PCR reference clock at 27MHz
sysclock=refclock + clockdev; % system clock is a bit faster

fprintf('clockdev=%gHz, sysclock = refclock + %g%%, refclock/sysclock = %g\n',clockdev,(sysclock-refclock)/refclock*100,refclock/sysclock);

t_offset=10000; % seconds
PCR_offset=3*refclock+1000; %
timer_res=1/10e-6; % 10us timer granularity

int_mem = 60000; % integrator memory in seconds
int_mem = int_mem * fs; % integrator memory in samples

f_PCR=refclock;

PCR=0:refclock/fs:refclock*time-1;
PCR=PCR+PCR_offset;
T_SYS=0:sysclock/fs:sysclock*time-1;
T_SYS=T_SYS./refclock;
T_SYS=T_SYS(1:samples);
T_SYS=T_SYS+t_offset;

%% normally distributed phase error
ep_var=50; % variance of phase error

ep=sqrt(ep_var)*randn(1,samples)/1000;

% %save and load phase error to have identical runs. You can delete ep.mat
% if exist('ep.mat','file')
%      load('ep.mat','ep');
% else
%      ep=sqrt(ep_var)*randn(1,samples)/1000;
%      save('ep.mat','ep');
%      fprintf('new ep\n');
% end

% uncomment to remove jitter (phase error all zero)
%ep=zeros(1,samples);

% Add phase error to T_SYS or PCR, whatevery you please
%T_SYS = T_SYS + ep(1:samples);

PCR = PCR + f_PCR*ep(1:samples);

% Quantize T_SYS (quite realistic)
T_SYS = round(T_SYS*timer_res)/timer_res;

figure(1);
plots=3;
plotnum=0;
subplot(plots,1,inc(plotnum));
plot((1:samples)/fs,ep(1:samples)*1000,'r.');
legend('Random Gaussian process');
xlabel('seconds');
ylabel('ms');
ylim([-20 20]);
grid on;

subplot(plots,1,inc(plotnum));
bins=-20e-3:1e-4:20e-3;
h=histc(ep,bins);
bar(bins*1000,h/samples);
xlabel('ms');
xlim([-20 20]);
grid on;
hold off;

subplot(plots,1,inc(plotnum));
drift=(clockdev/fs)/refclock:(clockdev/fs)/refclock:(clockdev/fs)/refclock*samples;
if isempty(drift); drift = zeros(1,samples); end;
plot((1:samples)/fs,(ep(1:samples)+drift)*1000,'green'); hold all;
plot((1:samples)/fs,drift*1000,'black');
legend('System time stamp (as deviation from PCR time)','Clock drift');
xlabel('seconds');
ylabel('ms');
grid on;
hold off;


%% Filter config
cutoff=.1; %Hz
order=2;
[b,a] = butter(order,cutoff/fs*2,'low');

%% Init recursion
phi_bar(1)=PCR(1);
phi_hat(1)=phi_bar(1);
cf_hat(1)=1;
ef_hat(1)=0;
ep_bar(1)=0;

%% loose some packets, make sure first is not lost
loss=round(rand(1,100)*samples);
loss(loss==0)=[];
PCR(loss)=[];
T_SYS(loss)=[];

len=length(PCR);

%% start the algorithm
figure(2);

t0=1;
for t=t0+1:len;
    
    PCR_diff = f_PCR * (T_SYS(t)-T_SYS(t-1));
    phi_hat(t)  = phi_bar(t-1) + cf_hat(t-1) * PCR_diff;
    
    ep_hat(t)   = PCR(t) - phi_hat(t);
   
    FILT        = filter(b,a,ep_hat(t0:t));
        
    ep_bar(t)   = FILT(end);
    
    %t_          = (T_SYS(t)-T_SYS(max(t0,t-int_mem)));
    %ef_hat(t)   = 1/t_ * sum(ep_bar(max(t0,t-int_mem):t));
    ef_hat(t)   = sum(ep_bar(max(t0,t-int_mem):t));
    %ef_hat(t)   = sum(ep_bar(t0:t));
    
    cf_hat(t)   = f_PCR/(f_PCR-ef_hat(t));
   
    %phi_bar(t)  = phi_hat(t)+ep_bar(t);
    phi_bar(t)  = phi_hat(t)+ep_hat(t)+ep_bar(t);
      
%      if mod(t,round(samples/500))==0
%          plots=6;
%          plotnum=0;
%          subplot(plots,1,inc(plotnum));
%          %plot(T_SYS-t_offset-(PCR-PCR_offset)/refclock,'r-'); hold all;
%          plot((phi_bar-PCR(t0:t))/refclock,'g-');
%          ylabel('s');
%          grid on;
%          %legend('T_{SYS}','phi_bar');
%          subplot(plots,1,inc(plotnum));
%          plot(ep(t0:t)*1000,'r.'); hold all;
%          plot(ep_hat/refclock*1000,'g-');
%          plot(ep_bar/refclock*1000,'b-'); hold off;
%          %legend('ep','ep_{hat}','ep_{bar}');
%          ylabel('ep in ms');
%          grid on;
%          subplot(plots,1,inc(plotnum));
%          %plot(ef_hat-(sysclock-refclock)); hold all;
%          %plot(t0:t,ones(1,t)*clockdev); hold all;
%          plot(ef_hat); hold off;
%          ylabel('ef_{hat} in Hz');
%          grid on;
%          %legend('clockdev','ef_hat');
%          subplot(plots,1,inc(plotnum));
%          plot(cf_hat); hold all;
%          plot(t0:t,ones(1,t)*refclock/sysclock);
%          ylabel('cf_{hat}');% - CF');
%          hold off;
%          grid on;
%          subplot(plots,1,inc(plotnum));
%          plot(FILT);
%          grid on;
%          subplot(plots,1,inc(plotnum));
%          plot(diff(cf_hat));
%          grid on;
%          pause(.1);
%      end
end

figure(3);
subplot(3,1,1);
jitter_o=abs((refclock/sysclock)*(T_SYS-t_offset)-(PCR-PCR_offset)/refclock);
jitter_v=abs((phi_bar-PCR)/refclock);
semilogy((1:len)/fs,jitter_o,'rx');
hold all;
semilogy((1:len)/fs,jitter_v,'gx');
filtlen=round(len/30);
semilogy((1:len)/fs,filtfilt(ones(1,filtlen)/filtlen,1,jitter_o),'black-');
semilogy((1:len)/fs,filtfilt(ones(1,filtlen)/filtlen,1,jitter_v),'black-');
legend('original |e_p|','virtual |e_p|','mean values');
xlabel('seconds');
ylabel('seconds');
ylim([1e-8 1]);
grid on;
hold off;
title(['Phase error is filtered by butterworth with cutoff=' num2str(cutoff) 'Hz']);

subplot(3,1,2);
plot((1:len)/fs,cf_hat);
ylabel('c_f');
grid on;
hold off;

subplot(3,1,3);
plot((1:len-1)/fs,abs(diff(cf_hat)*fs));
ylabel('absolute derivative of c_f in Hz');
grid on;
hold off;

fprintf('mean jitter before: %gms, after: %gus\n',mean(jitter_o)*1000,mean(jitter_v)*1000000);
mean(ef_hat(end-100:end))
mean(cf_hat(end-100:end))

%plot_png_fixed(['pcr_cutoff_' num2str(cutoff) 'Hz.png'],800,1.2/1);

return


    function y=lim(x,l)  % limit x within l
        y=sign(x)*max(l,abs(x));
    end

    function waitforclose
        while(not(isempty(get(0,'CurrentFigure'))));
            pause(.1);
        end
    end

end
