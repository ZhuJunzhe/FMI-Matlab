%
% FMI - Chapter 2.3 - FEC optimisation
%

function [PLR,RI,n_opt,k_lim]=Optimizing_FEC(RTT,ts,Pe,D_target,PLR_target)

% This function optimize the prameters of the FEC scheme for a given
% scenario
%
% Input Parameters:
%
% RTT: round trip time
% ts:  packet intercal in ms
% Pe: the orgininal link packet loss ratio
% D_target: the end-to-end target delay requirment
% PLR_target: the target packet loss ratio requirment
%
% Output Parmaeters:
%
% PLR: the final PLR of the FEC scheme with the optimum parameters
% RI: the needed redundancy information  of the FEC scheme with the optimum
% parameters
% n_opt: the optimum parameter n of the FEC scheme
% k_lim: the limited length of k for the FEC scheme due to the strict delay
% constraints.


% initiation
PLR=Pe;
RI=0.0;

% compute the length of the k according to the system parameters
k_lim=floor((D_target-(RTT/2))/ts);
n_opt=k_lim;

if(PLR_target >= Pe) 
    % no any redundancy information needed for this case
    return;
end;

warning off all


while PLR > PLR_target
    tmp_PLR=0.0;
    n_opt=n_opt+1;
    for i=1:1:k_lim
        for e=max([n_opt-k_lim+1,i]):1:(n_opt-k_lim+i)

            % compute the probability P(n,e)
            P_n_e=nchoosek(n_opt,e)*(Pe.^e)*((1-Pe).^(n_opt-e));

            % compute the probability Pd(e,i)
            Pd_e_i=nchoosek(k_lim,i)*nchoosek(n_opt-k_lim,e-i)/nchoosek(n_opt,e);

            % compute the final PLR performance of the FEC scheme
            tmp_PLR=tmp_PLR+(1/k_lim)*i*P_n_e*Pd_e_i;
        end;
    end;
    PLR=tmp_PLR;
end;

RI=(n_opt-k_lim)/k_lim;




    
