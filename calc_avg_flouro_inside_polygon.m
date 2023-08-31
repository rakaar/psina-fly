function insideMatrix = calc_avg_flouro_inside_polygon(m,n, polygon_points)
   
n_pts = length(polygon_points.x);
xPolygon = round(polygon_points.x(1:n_pts));
yPolygon = round(polygon_points.y(1:n_pts)); % Add the first point again to close the triangle

% If you want to get them in the matrix form
insideMatrix = zeros(m,n);
for r = 1:m
    for c = 1:n
        insideMatrix(r,c) = inpolygon(r,c,xPolygon, yPolygon);
    end
end

% flouro_matrices_inside_matrix = uint16(insideMatrix).*im_matrix; 
% avg_flouro = sum(flouro_matrices_inside_matrix(:))/sum(insideMatrix(:));


end