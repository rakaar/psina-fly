function df_f = calc_df_f_mov_window(F, window_size_in_mins, frame_period)
    % Compute ΔF/F using a moving window baseline
    % Inputs:
    %   F: Fluorescence signal
    %   window_size_in_mins: Window size in minutes
    %   frame_period: Frame period in seconds
    window_size = round((window_size_in_mins * 60)/frame_period);  % For example
    
    % Compute the moving average baseline
    Fo = compute_baseline(F, window_size); 
    
    % Compute the net signal
    net_signal = F - Fo; 

    % Compute ΔF/F
    df_f = net_signal ./ Fo;
end
