function lum_of_cells=LumCalc_Spont(passed_allims,celldat)

ptt=[0:0.1:2*pi];
[nframes,nr,nc]=size(passed_allims);
allims=zeros(nr,nc,nframes);
for kk=1:nframes
    allims(:,:,kk)=passed_allims(kk,:,:);
end
radius=celldat.radius;
lum_of_cells=zeros(length(celldat.x),nframes);

for jj=1:length(celldat.x)
    xxi=sin(ptt)*radius+celldat.x(jj);
    yyi=cos(ptt)*radius+celldat.y(jj);
    
    for fr=1:nframes
        [sx,x11,y11]=roipoly(allims(:,:,fr),xxi,yyi);
        [xx,yy]=find(sx);
        lum_of_cells(jj,fr)=mean(mean(allims(xx,yy,fr)));
    end
end
% 
% ptt=[0:0.1:2*pi];
% [rows,cols,nframes,lpset]=size(tavimall);
% 
% lumsum1=zeros(celldat.cellno,lpset,nframes);
% 
% for jj=1:celldat.cellno
%     for kk=1:lpset
%        for fr=1:nframes
%            xxi=sin(ptt)*dia+celldat.cell_coordsx(jj);
%            yyi=cos(ptt)*dia+celldat.cell_coordsy(jj);
%            [sx,x11,y11]=roipoly(tavimall(:,:,fr,kk),xxi,yyi);
%            [xx,yy]=find(sx);
%            lumsum1(jj,kk,fr)=mean(mean(tavimall(xx,yy,fr,kk)));
%            
%        end
%     end
%     
% end