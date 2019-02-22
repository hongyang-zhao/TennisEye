function [ret_gy] = two_side_interpolation(gy)
%   Interpolate the gyroscope readings in Y-axis if saturation happens.
MIN_GY_VALUE = -2000;
index = find(gy==MIN_GY_VALUE);
if ~isempty(index)
    st = index(1);
    et = index(end);
    if st>11
        l_x = st-11:st-1;
        l_y = gy(st-11:st-1);
        l_xx = st:et;
        l_yy = csapi(l_x,l_y,l_xx);
        r_x = et+1:et+10;
        r_y = gy(et+1:et+10);
        r_xx = st:et;
        r_yy = csapi(r_x,r_y,r_xx);
        gy(l_xx) = l_yy;
    end
end
ret_gy = gy;

end

