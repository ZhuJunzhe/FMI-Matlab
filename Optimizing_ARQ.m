%
% FMI - Chapter 2.3 - ARQ optimisation
%

function [PLR,RI,N_rr,N_rt]=Optimizing_ARQ(RTT,ts,t_sw,t_rw,Pe,D_target,PLR_target)

% This function optimize the prameters of the ARQ scheme for a receiver

% Input Parameters:
% RTT: round trip time
% ts:  packet intercal in ms
% t_sw:  the waiting time at the sender in ms
% t_rw:  the waiting time at the receiver in ms
% Pe: the orgininal link packet loss ratio
% D_target: the end-to-end target delay requirment
% PLR_target: the target packet loss ratio requirment

% Output Parmaeters:
% PLR: the final PLR of the ARQ scheme with the optimum parameters
% RI: the needed redundancy information  of the ARQ scheme with the optimum
% parameters
% N_rr: the optimum number of retransmission rounds
% N_rt: the number of retransmissions at each retransmission stage, which
% is a vector with the length of N_rr


% initiation
PLR=Pe;
RI=0.0;
N_rr=0;
N_rt=0;
t_lp=RTT+t_sw+t_rw; % the minimum time duration for one retransmission round

if(PLR_target >= Pe) 
    % no any redundancy information needed for this case
    return;
end;

warning off all

% Step 1: calculate the minimum Nrt,max to achieve the target PLR
% requirment;

N_rt_max=ceil(log(PLR_target)/log(Pe)-1);

% Step 2: calculate the maximum allowable number of retransmission rounds;

N_rr_max=floor((D_target-(RTT/2)-ts)/t_lp);

N_rr=min([N_rr_max,N_rt_max]);

% Step 3: Obtain the optimum parameters directly
N_rt=ones(1,N_rr);
N_rt(end)=N_rt_max-N_rr+1;

% compute the PLR performance with the optimum parameters
PLR=Pe.^(N_rt_max+1);

% compute the RI performance with the optimum parameters
tmp_N_rt=[1,N_rt]; % add for the first transmission

for q=1:1:N_rr
    RI=RI+N_rt(q)*(Pe.^(sum(tmp_N_rt(1:1:q))));
end



