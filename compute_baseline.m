function Fo = compute_baseline(F, window_size)
    half_win = floor(window_size / 2);
    Fo = zeros(size(F));

    for i = 1:length(F)
        start_idx = max(1, i - half_win);
        end_idx = min(length(F), i + half_win);
        
        Fo(i) = mean(F(start_idx:end_idx));
    end
end