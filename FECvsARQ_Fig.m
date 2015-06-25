%
% FMI - Chapter 2.3 - Figure x.x
%

% Produce optimisation results for FEC schemes and ARQ schemes

clear all

% system parameters
PLR_target=1e-6; % target PLR requirment
D_target=150;    % target delay requirment, in unit of ms
Rd=5;            % multimedea dara rate, in unit of Mbps
pkt_size=1250;   % packet size, in unit of byte
t_sw=0.0;        % waiting time at the sender, in unit of ms 
t_rw=0.0;        % waiting time at the receiver, in unit of ms
RTT=10;          % round trip time, in unit of ms
Pe=[0.001:0.001:0.01,0.02:0.01:0.10];         % original link PLR

% compute the packet interval according the data rate and the packet size
ts=pkt_size*8*(1e3)/(Rd*1e6);  % in unit of ms

% searching for the optimum parameters on the FEC scheme
FEC_PLR=zeros(1, length(Pe));
FEC_RI=zeros(1, length(Pe));
n_opt=zeros(1, length(Pe));
k_lim=zeros(1, length(Pe));

for Pe_index=1:1:length(Pe)
    [FEC_PLR(Pe_index),FEC_RI(Pe_index),n_opt(Pe_index),k_lim(Pe_index)]=Optimizing_FEC(RTT,ts,Pe(Pe_index),D_target,PLR_target)
end

% output the results
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Optimisation results for FEC scheme with different RTT: Start')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
FEC_PLR
FEC_RI
n_opt
k_lim
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Optimisation results for FEC scheme with different RTT: End')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

figure(1)
semilogx(Pe,FEC_RI,'k-')
grid on
hold on
xlabel('Average link PLR');
ylabel('The total needed RI');

% searching for the optimum parameters on the ARQ scheme

ARQ_PLR=zeros(1, length(Pe_index));
ARQ_RI=zeros(1, length(Pe_index));
N_rr=zeros(1, length(Pe_index));
N_rt=zeros(3,length(Pe_index));

for Pe_index=1:1:length(Pe)
    [ARQ_PLR(Pe_index),ARQ_RI(Pe_index),N_rr(Pe_index),tmp_N_rt]=Optimizing_ARQ(RTT,ts,t_sw,t_rw,Pe(Pe_index),D_target,PLR_target)
    N_rt(1:1:length(tmp_N_rt),Pe_index)=tmp_N_rt
end;

%output the results
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Optimisation results for ARQ scheme with different RTT: Start')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
ARQ_PLR
ARQ_RI
N_rr
N_rt
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Optimisation results for ARQ scheme with different RTT: End')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

% Drawing the picture on the performance of the ARQ scheme with different
% receviers of from 1 to 7
semilogx(Pe,1*ARQ_RI,'b*-')
semilogx(Pe,2*ARQ_RI,'bv-')
semilogx(Pe,3*ARQ_RI,'bx-')
semilogx(Pe,4*ARQ_RI,'bs-')
semilogx(Pe,5*ARQ_RI,'b^-')
semilogx(Pe,6*ARQ_RI,'bd-')
semilogx(Pe,7*ARQ_RI,'bo-')

legend('FEC Scheme','ARQ Scheme with 1 receiver','ARQ Scheme with 2 receivers','ARQ Scheme with 3 receivers',...
        'ARQ Scheme with 4 receivers','ARQ Scheme with 5 receivers','ARQ Scheme with 6 receivers',...
        'ARQ Scheme with 7 receivers','location','NorthWest');
hold off
