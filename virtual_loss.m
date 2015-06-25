function [ vplr ] = virtual_loss( plr, plr_target )
%VIRTUAL_LOSS Summary of this function goes here
%   Detailed explanation goes here

% compute the virtual loss (v) / pretended loss (p)

vplr=zeros(1,length(plr_target));

for i=1:length(plr_target)
    rplr=plr_target(i);
    if plr >= rplr
        vplr(i) = (plr-rplr)./(1-rplr);
    else
        vplr(i) = 0;
    end
end