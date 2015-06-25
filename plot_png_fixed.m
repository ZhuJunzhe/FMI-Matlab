function [ output_args ] = plot_png_fixed( name, width, aspect)
% name width aspect


scrsz = get(0,'ScreenSize');

%% default size is .65x screen
if nargin < 2
    size = .65;
    width = scrsz(3)*size;
end

%% default aspect is 16/10
if nargin < 3
    aspect=16/10;
end

height=width/aspect;

set(gcf,'Position',[1 height width height])
set(gcf,'PaperPositionMode','auto');
print('-painters','-loose','-r100','-dpng',[name,'.png']);
disp(['Created ' name '.png, width=' num2str(width) ' aspect=' num2str(aspect)]);