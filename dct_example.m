function dct_example

depth=8; % color depth in bits


%% gaussian
x2=round(customgauss([8 8],2,2,0,-2^(depth-1),2^(depth),[1,0]));
scale=10;
mpeg_dct(x2,depth,scale,'hot');

figure(1)
plot_png_fixed('dct_n_gauss',800,12/16);
figure(2)
plot_png_fixed('dct_i_gauss',800,9/16);


%% "circle"
x1=[ -10 -10 -10 10  10  -10 -10 -10;...
    -10 10  10  10  10  10  10  -10;...
    10  10  10  -10  -10  10  10  10;...
    10  10  -10  -10  -10  -10  10  10;...
    10  10  -10  -10  -10  -10  10  10;...
    10  10  10  -10  -10  10  10  10;...
    -10 10  10  10  10  10  10  -10;...
    -10 -10 -10 10  10  -10 -10 -10 ...
    ]./20.*2^depth;

x1(x1<0)=x1(x1<0)+1;

scale=31;
mpeg_dct(x1,depth,scale,'hot');

figure(1)
plot_png_fixed('dct_n_circle',800,12/16);
figure(2)
plot_png_fixed('dct_i_circle',800,9/16);

return

%% gaussian
x2=round(customgauss([8 8],1,1,0,-2^(depth-2),2^(depth-1),[1,0]));
scale=10;
mpeg_dct(x2,depth,scale);

figure(1)
plot_png_fixed('dct_n_gauss',800,12/16);
figure(2)
plot_png_fixed('dct_i_gauss',800,9/16);
