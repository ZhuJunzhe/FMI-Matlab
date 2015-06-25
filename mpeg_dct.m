function [ output_args ] = mpeg_dct( x, depth, scale, cmapfun )
%MPEG_DCT Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    cmapfun = 'gray';
end

    function c = getcmap(i)
        eval(['c=' cmapfun '(i);']);
    end

    function plotn(what,size)
        xlim([1 size]);
        ylim([1 size]);
        %image(ones(size,size)+128);
        axis image
        for i=1:size;
            for k=1:size;
                text(k,size-i+.5,num2str(what(i,k)),'HorizontalAlignment','center','VerticalAlignment','middle');
            end
        end
        axis off;
    end

%     function pcolorbar
%         ch=colorbar;
%         ch=get(ch,'children');
%         cm=colormap;
%         cd=get(ch,'cdata');
%         nd=zeros([numel(cd),3]);
%         nd(cd,:)=cm(cd,:);
%         nd=ipermute(nd',[3,1,2]);
%         set(ch,'cdata',nd);
%         set(ch,'cdatamapping','scaled');
%     end
        
size=8;

Q = [[ 8 16 19 22 26 27 29 34];
     [16 16 22 24 27 29 34 37];
     [19 22 26 27 29 34 34 38];
     [22 22 26 27 29 34 37 40];
     [22 26 27 29 32 35 40 48];
     [26 27 29 32 35 40 48 58];
     [26 27 29 34 38 46 56 69];
     [27 29 35 38 46 56 69 83]];


cmap{1} = getcmap(2^depth);

f=figure(1); clf(f); f=figure(2); clf(f);
%% original
figure(1);subplot(3,4,[1,2]);plotn(x,size);figure(2);
subplot(3,4,[1,2]);
image(x,'CDataMapping','scaled');

colormap(cmap{1});

caxis([-(2^depth)/2+1 2^(depth)/2]);
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'original image block'
end


%% DCT
y=round(dct2(x));
figure(1);subplot(3,4,[3,4]);plotn(y,size);figure(2);
subplot(3,4,[3 4]);
image(y,'CDataMapping','scaled');%%plotn(y,size)
numcolors=8*2^depth;
cmap{2}=getcmap(numcolors);

colormap(cmap{2});

caxis([-round(numcolors/2)+1 round(numcolors/2)]);
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'DCT representation'
end

%% quantization table
figure(1);subplot(3,4,[5,6]);plotn(Q,size);figure(2);
subplot(3,4,[5 6]);
image(Q,'CDataMapping','scaled');
numcolors=length(unique(round(Q)));
cmap{3}=getcmap(numcolors);

colormap(cmap{3});

caxis auto;
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'Quantization table'
end

%% quantized dct (for transmission)
Y=round((8.*y)./(Q*scale));
figure(1);subplot(3,4,[7,8]);plotn(Y,size);figure(2);
subplot(3,4,[7 8]);
image(Y,'CDataMapping','scaled');
numcolors=round(8*2^depth/scale);
cmap{4}=getcmap(numcolors);

colormap(cmap{4});

caxis([-round(numcolors/2+1) round(numcolors/2)]);
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'Reduced and scaled (8/Q/scale) DCT'
end

%% quantized dct
Y=round(Y.*Q.*(scale/8))
figure(1);subplot(3,4,[9,10]);plotn(Y,size);figure(2);
subplot(3,4,[9 10]);
image(Y,'CDataMapping','scaled');
numcolors=8*2^depth;
cmap{5}=getcmap(numcolors);

colormap(cmap{5});

caxis([-round(numcolors/2+1) round(numcolors/2)]);
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'Quantized DCT'
end

%% idct
z=round(idct2(Y));
figure(1);subplot(3,4,[11,12]);plotn(z,size);figure(2);
subplot(3,4,[11 12]);
image(z,'CDataMapping','scaled');

colormap(cmap{1});

caxis([-(2^depth)/2+1 2^(depth)/2]);
axis off;
axis image;

freezeColors;
freezeColors(colorbar);

for n=1:2;
    figure(n);
    title 'iDCT of quantized DCT'
end

end