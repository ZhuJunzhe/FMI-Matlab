%% Generation of van der Monde Code
% 
% Copyright 2013 Telecommunications Lab
% $Revision: 1.0 $ $Date: 2013/12/09 $
%%
% 
% Galois-Field gf(2³) with normal generator D³+D+1 
% Alternatively try D³+D²+1 (13 decimal)
PP = 11;
% Generate table if you want to have it faster (not required)
% gftable(3,PP);

% Create GF and primitive element
A=gf([0:7],3,PP); alpha = A(3);
% Galois-Field in exponentially sorted order
AE = A;
for k=0:6; AE(k+2)=alpha^k; end;

% Generator-Matrix following van der Monde
G = gf(eye(4,7),3,PP);
for k=1:4; G(k,1:7) = AE(2:8).^(k-1); end;

% Systematic Generator-Matrix
% G = gf(eye(4,7),3,PP);
% for k=1:4; G(k,5:7) = AE([2 3 4]).^(k-1); end;

% Example message
m = gf([2 3 7 6],3,PP);
c = m*G;

% Gaps at positions 2,4 and 5
c_ = c([1 3 6 7]); 
G_ = G(1:4,[1 3 6 7]);

% Reconstruction
m_ = c_*inv(G_);

% Check
if ((m - m_) == 0);
    disp('Hurra! Errors are corrected!');
else
    disp('Oops; something went wrong!');
end;