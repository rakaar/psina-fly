%%%% Cell Selection
%%%% 26-05-23
%%
clear; close all;clc;
code_dir = pwd;
main_dirr = 'E:\2-P\Data_2p\REAL STUFFS';
figs_path = 'E:\2-P\PSINA_df_f_cells_rois_fig_files\';
% cd(main_dirr);
% curr_dirr = '\\Darkknightrises\f\Sarani_ADLab';
% cd(curr_dirr);

% some Parameters
cellradius = 6;

dirrnam = uigetdir;
dirrnam_split = strsplit(dirrnam, '\');
tseries_folder_name = dirrnam_split{end};
exp_date = dirrnam_split{end-1};

mat_filename = strcat(exp_date, '_', tseries_folder_name, '.mat');
if ~exist(mat_filename, 'file')
    
    cd(dirrnam);

    filname = dir('*.tif');
    f1={filname.name};
    c1=cellfun(@(w) str2double(w(40)),f1);
    id1=find(c1==2);

    % getting dimensions of a single image
    im = imread(filname(1).name);
    disp('starting mean')
    allim_pre_corr = zeros(length(id1),size(im,1),size(im,2));
    for ii = 1 : length(id1)
        allim_pre_corr(ii,:,:) = imread(filname(id1(ii)).name);
    end
    
    cd(code_dir)
    %% - image correction - NO TIME
    save('temp.mat') % temp place before clearing memory
    disp('Saving Big file')
    tic
    save('allim_pre_corr', 'allim_pre_corr', '-v7.3') % saving this huge var seperately
    toc

    clear; % clear and low allim only
    allim_pre_corr = load('allim_pre_corr.mat');
    allim_pre_corr = allim_pre_corr.allim_pre_corr;
    allim_reshape = reshape(allim_pre_corr,  1, size(allim_pre_corr,1), size(allim_pre_corr,2), size(allim_pre_corr,3));
    clear allim_pre_corr
        tic
        rg=5;
        [niters,nfr,nr,nc]=size(allim_reshape);
        imlast=squeeze(squeeze(allim_reshape(1,1,:,:)));
        seq=0;
        for kk=1:niters
            startm=1;
            if kk==1
                startm=2;
            end
            for mm=startm:nfr
                disp([num2str(mm) ' out of ' num2str(nfr) ' frames'])
                tempcur=zeros(nr+2*rg+1,nc+2*rg+1);
                imcur=squeeze(squeeze(allim_reshape(kk,mm,:,:)));
                
                for ii=1:2*rg+1
                    for jj=1:2*rg+1
                        tempcur(ii:(ii+nr-1),jj:(jj+nc-1))=imcur;
                        allc(ii,jj)=corr2(imlast,tempcur(rg+1:rg+nr,rg+1:rg+nc));
                    end
                end
                
                seq=seq+1;
                sallc(seq,:,:)=allc;
                [mx mxn]=max(allc);
                [mxx mxnn]=max(mx);
                mxcij=[mxn(mxnn) mxnn];
                tempcur(mxcij(1):(mxcij(1)+nr-1),mxcij(2):(mxcij(2)+nc-1))=imcur;
                allim_reshape(kk,mm,:,:)=tempcur(rg+1:rg+nr,rg+1:rg+nc);
            end
        end
        toc
    % corrected images to normal
    allim = squeeze(allim_reshape);

    mallim = squeeze(mean(allim));
    disp('ended mean')
    load('temp.mat')
    clear allim_pre_corr; % this is very huge, waste of memory

  
else
    disp('Loading from OLD cache file')
    disp('### Delete it and re-run this code if you want to re-calculate ###')
    load(mat_filename);
end



% -

disp('Start Cell Selection')
CellData =  Cell_Select_Spont(mallim,cellradius);
close all; % close once done with selection
lum_of_cells=LumCalc_Spont(allim,CellData);
% ncells=size(lum_of_cells,1);
% nframs=size(lum_of_cells,2);
% med_cell_lum=nanmedian(lum_of_cells')';
% Cell_dff=(lum_of_cells-repmat(med_cell_lum,1,nframs))./repmat(med_cell_lum,1,nframs);
% sCell_dff=squeeze(Calc_CausalSmooth_dff(Cell_dff,1));


disp('End of Cell selection, About to start ROI selection')
%%%
RoiData = Roi_Select(mallim);
close all; % close once done with selection


xml_file_name =  strcat(tseries_folder_name, '.xml');
xml_file_path = strcat(main_dirr, '\', exp_date, '\', tseries_folder_name, '\', xml_file_name);
frame_period = get_framePeriod_from_xml(xml_file_path);


disp('Saving vars for future use')
% save(mat_filename, 'RoiData', 'CellData', 'frame_period', 'mallim', 'allim');
save(mat_filename, 'allim','RoiData', 'CellData', 'frame_period', 'mallim', '-v7.3')
disp('Saved')


%% - Commenting because has code that uses array exceeding memory limits
% roi_lum = LumCalc_Roi(allim,RoiData);

% med_roi_lum = nanmedian(roi_lum')';
% Roi_dff = (roi_lum-repmat(med_roi_lum,1,nframs))./repmat(med_roi_lum,1,nframs);
% sRoi_dff = squeeze(Calc_CausalSmooth_dff(Roi_dff,1));

% %%%

% resultfile=strcat('OAR_',filname(ii).name(1:25));
% eval(sprintf('save %s lum_of_cells  sCell_dff mallim CellData med_cell_lum RoiData roi_lum med_roi_lum Roi_dff sRoi_dff',resultfile))

% [som1 som2] = imgxyxc
% correct(allim);

%%%%%%%%%%%% Mean cells %%%%%%%%%%
window_size_in_mins = 20;
n_frames = size(allim,1);
n_rows = size(allim,2);
n_cols = size(allim,3);


% flouroscence of cells and df/f
n_cells = length(CellData.x);
cells_flouro_over_time = zeros(n_cells, n_frames);
cells_df_f_over_time = zeros(n_cells, n_frames);
for n = 1:n_cells
    
    cells_df_f_over_time(n,:) = calc_df_f_mov_window(lum_of_cells(n,:), window_size_in_mins, frame_period);
    
    figure
        subplot(2,1,1)
        plot(lum_of_cells(n,:))
        title(['Cell num ' num2str(n) ' -- ' exp_date ' -- ' tseries_folder_name])
        xlabel('Time (s)')
        ylabel('f')    
        
        subplot(2,1,2)
        plot(cells_df_f_over_time(n,:))
        title('deltaF/F')
        xlabel('Time (s)')
        ylabel('deltaF/F')
        
        saveas(  gcf, strcat(  figs_path,strrep(mat_filename, '.mat', ''), '_cell_', num2str(n), '.fig'  ) );
end



%%%%%%%%%%% Mean of all Rois %%%%%%%%%%%%%%%
% flouroscence of Rois and df/f
n_rois = length(RoiData);
masks_for_rois = zeros(n_rois, n_rows, n_cols);

for n = 1:n_rois
    polygon_points = RoiData{n};
    masks_for_rois(n,:,:) = calc_avg_flouro_inside_polygon(n_rows,n_cols,polygon_points);
end 


rois_flouro_over_time = zeros(n_rois, n_frames);
rois_df_f_over_time = zeros(n_rois, n_frames);

for t = 1:n_frames
    for n = 1:n_rois
        mask_for_nth_roi = uint16(squeeze(masks_for_rois(n,:,:)));
        allim_at_t_time_nth_roi = uint16(squeeze(allim(t, :, :)));
        flouro_matrices_inside_matrix = allim_at_t_time_nth_roi.*mask_for_nth_roi; 
        avg_flouro = sum(flouro_matrices_inside_matrix(:))/sum(mask_for_nth_roi(:));
        rois_flouro_over_time(n,t) = avg_flouro;
    end
end

for n = 1:n_rois
    F = rois_flouro_over_time(n,:);
    df_f = calc_df_f_mov_window(F, window_size_in_mins, frame_period);

    figure
    subplot(2,1,1)
    plot(F)
    title(['Roi num ' num2str(n) ' -- ' exp_date ' -- ' tseries_folder_name])
    xlabel('Time (s)')
    ylabel('f')    
    subplot(2,1,2)
    
    plot(df_f)
    title('deltaF/F')
    xlabel('Time (s)')
    ylabel('deltaF/F')
    saveas(  gcf, strcat(  figs_path ,strrep(mat_filename, '.mat', ''), '_roi_', num2str(n), '.fig'  ) );
end