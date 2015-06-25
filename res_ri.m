function [ri,plrt]=res_ri(plr,plrt)
plrv=virtual_loss(plr,plrt);
ri=plrv./(1-plrv);

% limit plrt when ri is zero
first=find(ri==0,1);
zero=find(ri==0);
plrt(zero)=plrt(first);

%stop=find(ri1<0,1);
%if isempty(stop); stop=length(ri1)+1; end
%ri1=ri1(1:stop-1);

assert(min(ri)>=0, 'RI negative: %.3f',min(ri));
