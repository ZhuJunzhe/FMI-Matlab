%
% FMI - Chapter 2.3 - Table x.x
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
RTT=[10,45,60];  % round trip time, in unit of ms
Pe=0.10;         % original link PLR

% compute the packet interval according the data rate and the packet size
Ts=pkt_size*8*(1e3)/(Rd*1e6);  % in unit of ms

% searching for the optimum parameters on the FEC scheme
FEC_PLR=zeros(1, length(RTT));
FEC_RI=zeros(1, length(RTT));
n_opt=zeros(1, length(RTT));
k_lim=zeros(1, length(RTT));

for RTT_index=1:1:length(RTT)
    [FEC_PLR(RTT_index),FEC_RI(RTT_index),n_opt(RTT_index),k_lim(RTT_index)]=Optimizing_FEC(RTT(RTT_index),Ts,Pe,D_target,PLR_target)
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


% searching for the optimum parameters on the ARQ scheme
Pe=[0.02,0.03,0.10]; % Three different receivers with different orginal link PLR

ARQ_PLR=zeros(1, length(RTT));
ARQ_RI=zeros(1, length(RTT));
N_rr=zeros(1, length(RTT));
N_rt=zeros(3,length(RTT));

for Pe_index=1:1:length(Pe)
    for RTT_index=1:1:length(RTT)
        [ARQ_PLR(RTT_index),ARQ_RI(RTT_index),N_rr(RTT_index),tmp_N_rt]=Optimizing_ARQ(RTT(RTT_index),Ts,t_sw,t_rw,Pe(Pe_index),D_target,PLR_target)
        N_rt(1:1:length(tmp_N_rt),RTT_index)=tmp_N_rt
    end
    
    %output the results
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('Optimisation results for ARQ scheme with different RTT: Start')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('Pe=')
    disp(Pe(Pe_index))
    ARQ_PLR
    ARQ_RI
    N_rr
    N_rt
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('Optimisation results for ARQ scheme with different RTT: End')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end;

