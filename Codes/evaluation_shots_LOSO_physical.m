
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

%%
det_time = 0.01;
m = 0.05; % Ball mass
M = 0.3; % Racket mass
Radius = 0.8; % 1
ball_radius = 0.03;

%% parameter:
HF_k_array = zeros(1,USER_NUM);
HF_b_array = zeros(1,USER_NUM);
e_array = zeros(1,USER_NUM);%[0.1447,0.1307,0.1537,0.1503];


%% train
for i = 1:USER_NUM
    test_id = i;
    train_array = 1:USER_NUM;
    train_array(test_id) = [];
    
    num = 0;
    HF_input = zeros(1,1);
    HF_output = zeros(1,1);
    estimated_e = zeros(1,1);
    for k = 1:USER_NUM-1
        id = train_array(k);
        for j = 1:length(all_data{id})
            shot_type = all_data_label{id}{j}(1);
            incoming_speed = all_data_label{id}{j}(4);
            outgoing_speed = all_data_label{id}{j}(2);
            if  outgoing_speed ~= 0
                
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
                
                if gy(hit_index) < 0
                    gy = -gy;
                    az = -az;
                end
                
                HF = M * az(hit_index-1)*(end_index - hit_index + 1)*det_time;
                det_V_az = sum(az(hit_index:end_index))*det_time;
                Vr_start_x = Radius * gy(hit_index) / 180 * 3.14;
                Vr_end_x = Radius * gy(hit_index) / 180 * 3.14 + det_V_az;
                
                ball_in_speed = all_data_label{id}{j}(4)/2.24;
                ball_out_speed = all_data_label{id}{j}(2)/2.24;
                momentum_before = -m*ball_in_speed + M*Vr_start_x;
                momentum_after = m*ball_out_speed + M*Vr_end_x;
                
                num = num + 1;
                HF_input(num) = M * az(hit_index-1);
                HF_output(num) = (momentum_after - momentum_before)/((end_index - hit_index + 1)*det_time);
                estimated_e(num) = (ball_out_speed - Vr_end_x)/(Vr_start_x + ball_in_speed);
                
            end
        end
    end
    param = polyfit(HF_input,HF_output,1);
    HF_k_array(i) = param(1);
    HF_b_array(i) = param(2);
    e_array(i) = mean(estimated_e);
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
        if outgoing_speed ~= 0
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
            
            if gy(hit_index) < 0
                gy = -gy;
                az = -az;
            end
            
            HF = M * az(hit_index-1)*(end_index - hit_index + 1)*det_time;
            det_V_az = sum(az(hit_index:end_index))*det_time;
            Vr_start_x = Radius * gy(hit_index) / 180 * 3.14;
            Vr_end_x = Radius * gy(hit_index) / 180 * 3.14 + det_V_az;
            
            ball_in_speed = all_data_label{id}{j}(4)/2.24;
            ball_out_speed = all_data_label{id}{j}(2)/2.24;
            momentum_before = -m*ball_in_speed + M*Vr_start_x;
            momentum_after = m*ball_out_speed + M*Vr_end_x;
            
            HF_k = HF_k_array(id);
            HF_b = HF_b_array(id);
    
            HF_momentum = (HF_k * M * az(hit_index-1) + HF_b)*(end_index - hit_index + 1)*det_time;
            
            num = num + 1;
            predicted_array(num) = (e_array(id)/(1+e_array(id))*1/m*(m*Vr_start_x + m/e_array(id)*Vr_end_x + HF_momentum...
                - M*(Vr_end_x - Vr_start_x)))*2.24;
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

