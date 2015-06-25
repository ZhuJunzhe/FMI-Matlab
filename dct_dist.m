function dct_dist(size)
global S;
global numblocks;
S=zeros(8,8);
numblocks=0;

    function y=sumblocks(x)
        S=S+x;
        numblocks=numblocks+1;
        y=zeros(8,8);
    end

X=imread('automedon_crop.jpg');
G=rgb2gray(X);

cmap{1}=gray(256);
cmap{2}=gray(100);

%%
subplot(1,2,1);
image(G)
colormap(cmap{1});
caxis([0 255]);
axis image
axis off;

freezeColors;
%freezeColors(colorbar);

fun=@dct2;
D=blkproc(G,[8 8],fun);

Z=round(D)==0;

fun=@sumblocks;
blkproc(Z,[8 8],fun);

%%
subplot(1,2,2);
S=S./numblocks
contourf(round(S*100));
caxis([0 100]);
set(gca,'YDir','reverse');
axis image;
colorbar;
colormap(cmap{2});

freezeColors;
freezeColors(colorbar);

unfreezeColors;

title('8x8 DCT coefficient distribution');

plot_png_fixed('dct_dist',2000,3);

end