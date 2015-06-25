function h264_transform()

depth=8;
QStep=[0.625 0.6785 0.8125 0.875 1 1.125 1.25 1.375 1.625 1.75 2 2.25 2.5];
QP=10;
qbits=15+floor(QP/6);
f=2^qbits/3;


    function plotn(what,size)
        xlim([1 size]);
        ylim([1 size]);
        for i=1:size;
            for k=1:size;
                text(k,size-i+1,num2str(what(i,k)),'HorizontalAlignment','center','VerticalAlignment','middle');
            end
        end
        axis image
        axis off
    end

X=[5 11 8 10; 9 8 4 12; 1 10 11 4; 19 6 15 7];

a=1/2;
b=sqrt(2/5);
a2=a^2;
ab2=a*b/2;
b24=b^2/4;

C=[1 1 1 1; 2 1 -1 -2; 1 -1 -1 1; 1 -2 2 -1];
E=[a2 ab2 a2 ab2; ab2 b24 ab2 b24; a2 ab2 a2 ab2; ab2 b24 ab2 b24];
MF=round(2^qbits/QStep(QP+1).*E);

W=C*X*C';
Z=bitshift(round((abs(W).*MF+f)),-qbits);
Z=sign(W).*Z;

f=figure(1);clf(f);
subplot(2,3,1);plotn(X,4);
subplot(2,3,2);plotn(W,4);
subplot(2,3,3);plotn(Z,4);
colormap(gray(256));
caxis([-(2^depth)/2+1 2^(depth)/2]);
subplot(2,3,4);image(X,'CDataMapping','scaled');plotn(X,4);
axis off;
axis image
subplot(2,3,5);image(W,'CDataMapping','scaled');
axis off;
axis image
subplot(2,3,6);image(Z,'CDataMapping','scaled');
axis off;
axis image

end