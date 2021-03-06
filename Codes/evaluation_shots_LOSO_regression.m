
close all
clear
clc

load new_data_all_7.mat

temp_data = all_data;
temp_label = all_data_label;
clear all_data all_data_label

USER_NUM = 5;
all_data = cell(USER_NUM,1);
all_data{1} = temp_data{2};
all_data{2} = temp_data{3};
all_data{3} = temp_data{4};
all_data{4} = temp_data{5};
all_data{5} = temp_data{6};
all_data_label{1} = temp_label{2};
all_data_label{2} = temp_label{3};
all_data_label{3} = temp_label{4};
all_data_label{4} = temp_label{5};
all_data_label{5} = temp_label{6};


WINDOW = 100;
Radius = 0.8;
%% parameter:
k_array = zeros(1,USER_NUM);%[0.02546,0.02835,0.02402, 0.02392];
b_array = zeros(1,USER_NUM);%[11.98,6.703,13.62,16.47];

       
%% train
for i = 1:USER_NUM
    test_id = i;
    train_array = 1:USER_NUM;
    train_array(test_id) = [];
    
    num = 0;
    x_array = zeros(1,WINDOW);
    y_array = zeros(1,WINDOW);
    for k = 1:USER_NUM-1
        id = train_array(k);
        for j = 1:length(all_data{id})
            shot_type = all_data_label{id}{j}(1);
            incoming_speed = all_data_label{id}{j}(4);
            outgoing_speed = all_data_label{id}{j}(2);
             if (shot_type == 1 || shot_type == 2) && outgoing_speed ~= 0 
                ax = all_data{id}{j}(:,1);
                ay = all_data{id}{j}(:,2);
                az = all_data{id}{j}(:,3);
                gx = all_data{id}{j}(:,4);
                gy = all_data{id}{j}(:,5);
                gz = all_data{id}{j}(:,6);
                gy = two_side_interpolation_gy(gy);
                [hit_index, end_index, flag] = find_begin_and_end_index(gy);
                if flag == 0
                    continue;
                end
                num = num + 1;
                x_array(num,:) = abs(gy(hit_index)*Radius);
                y_array(num,:) = all_data_label{id}{j}(2);
            end
        end
    end
    param = polyfit(x_array,y_array,1);
    k_array(i) = param(1);
    b_array(i) = param(2);
end


%% test
results = cell(USER_NUM,1);
for id = 1:USER_NUM
    num = 0;
    predicted_array = zeros(1,1);
    real_array = zeros(1,1);
    for j = 1:length(all_data{id})
        shot_type = all_data_label{id}{j}(1);
        incoming_speed = all_data_label{id}{j}(4);
        outgoing_speed = all_data_label{id}{j}(2);
        if (shot_type == 1 || shot_type == 2) && outgoing_speed ~= 0 %&& flag == 2
            
            ax = all_data{id}{j}(:,1);
            ay = all_data{id}{j}(:,2);
            az = all_data{id}{j}(:,3);
            gx = all_data{id}{j}(:,4);
            gy = all_data{id}{j}(:,5);
            gz = all_data{id}{j}(:,6);
            gy = two_side_interpolation_gy(gy);
            [hit_index, end_index, flag] = find_begin_and_end_index(gy);
            if flag == 0
                continue;
            end
            
            num = num + 1;
            predicted_array(num) = k_array(id)*abs(gy(hit_index)*Radius) + b_array(id);
            real_array(num) = all_data_label{id}{j}(2);
        end
    end
    results{id} = [predicted_array;real_array];
end



A = [results{1}(1,:),results{2}(1,:),results{3}(1,:),results{4}(1,:),results{5}(1,:)];
B = [results{1}(2,:),results{2}(2,:),results{3}(2,:),results{4}(2,:),results{5}(2,:)];
error = mean(abs(A-B))
error_std = std(abs(A-B))
accuracy = mean(1 - abs(A - B)./B)
