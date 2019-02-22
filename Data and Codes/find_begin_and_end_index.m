function [begin_index,end_index,flag] = find_begin_and_end_index(gy)
%FIND_FIRST_PEAK Summary of this function goes here
%   Detailed explanation goes here
begin_index = 0;
end_index = 0;
flag = 1;

if abs(min(gy)) > abs(max(gy))
    gy = -gy;
end

WINDOW = 4;
for i = 40:length(gy)-WINDOW
    if gy(i) == max(gy(i-WINDOW:i+WINDOW)) && gy(i) > 500
        begin_index = i;
        break;
    end
end

if begin_index == 0 || gy(begin_index) == gy(begin_index-1) || gy(begin_index) == gy(begin_index+1)
    flag = 0;
    return;
end


end_index = begin_index + 1;
while abs(gy(end_index-1)) >= abs(gy(end_index))
    if end_index == 100
        flag = 0;
        break;
    end
    end_index = end_index + 1;
end


% if gy(begin_index) > 0
%    gy = -gy; 
% end
% end_index = begin_index + 1;
% while gy(end_index-1) < gy(end_index)
%     if end_index == 100
%         flag = 0;
%         break;
%     end
%     end_index = end_index + 1;
% end


end_index = end_index - 1;
if end_index - begin_index > 20
    flag = 0;
end


end

