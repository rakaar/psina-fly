function CellData=Cell_Select(mean_image,cell_radius)

hs=find_figure('Select_Cells');
clf
imagesc(mean_image)
green=gray;green(:,1)=0;green(:,3)=0;
colormap(green)
axis image
imcontrast(hs)
title('Select Cells by clicking on midpoint (backspace to delete previous cell, doubleclick to end)')
[CellData.x,CellData.y]=getpts(gcf);
hold on
plot(CellData.x,CellData.y,'k.')
CellData.radius=cell_radius;
find_figure('Selected_Cells');
clf
n=length(CellData.x);
imagesc(mean_image)
colormap(green)
axis image
hold on
th=0:2*pi/50:2*pi;
xxx=cell_radius*cos(th);yyy=cell_radius*sin(th);
for kk=1:n
    plot(CellData.x(kk)+xxx,CellData.y(kk)+yyy,'k')
    eval(sprintf('text(CellData.x(kk),CellData.y(kk),''%i'')',kk))
end
close(hs)