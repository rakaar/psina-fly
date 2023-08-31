function RoiData = Roi_Select(mean_image)
rn = 1;
chk_tp = 0;
RoiData = {};
while chk_tp == 0
    prompt  = 'Do you want to draw any ROI(if yes press 0 else 1) : ';
    chk_tp = input(prompt);
    if chk_tp == 0
        hs=find_figure('Select_Cells');
        clf
        imagesc(mean_image)
        green=gray;green(:,1)=0;green(:,3)=0;
        colormap(green)
        axis image
        imcontrast(hs)
        title('Select Roi (backspace to delete previous point, doubleclick to end)')
        [RoiData{rn}.x,RoiData{rn}.y]=getpts(gcf);
        hold on
        plot(RoiData{rn}.x,RoiData{rn}.y,'k.')
        find_figure('Selected_Cells');
        clf
        n=length(RoiData{rn}.x);
        imagesc(mean_image)
        colormap(green)
        axis image
        hold on
        for kk=1:n
            plot(RoiData{rn}.x(kk),RoiData{rn}.y(kk),'k')
            eval(sprintf('text(RoiData{rn}.x(kk),RoiData{rn}.y(kk),''%i'')',kk))
        end
        close(hs)
        rn = rn+1;
    else
        
        break
    end
    
end


