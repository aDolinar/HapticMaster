

clc;close all; 
load('haptic_data.mat');

% data_all
% min_index_table
% hand_speed_path
% force_left_hand_path
% force_right_hand_path
% common_force_path
% angle_handle_1_path
% angle_handle_2_path
% position_x_path
% position_y_path
% position_z_path

% haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no)


for damping_no = 1:3
%     close all
    
    for target_no = 1:16
        
        for subject_no = 1:26
            close all
            for repetition_no = 1:3
                figure(subject_no)
                hold on
                plot(haptic_data(subject_no).damping(damping_no).data_all(2:4,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2))')
                %            plot(haptic_data(subject_no).damping(damping_no).data_all(2:4,:)')
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('forward/backward','up/down','left/right')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                pause
                
            end
        end
    end
end

close all
subject_no = 1;
damping_no = 1;
repetition_no = 1;
figure
plot(haptic_data(subject_no).damping(damping_no).data_all(2:4,:)') 
set(gcf, 'Position', get(0, 'Screensize'));
hold on
for ii=1:size(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(:,1))
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1))','go')
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2))','r*')
    title(['ii=', int2str(ii)])
    pause
end
repetition_no = 2;

for ii=1:size(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(:,1))
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1))','go')
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2))','r*')
    title(['ii=', int2str(ii)])
    pause
end
repetition_no = 3;

for ii=1:size(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(:,1))
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,1))','go')
    plot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2),haptic_data(subject_no).damping(damping_no).data_all(3,haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(ii,2))','r*')
    title(['ii=', int2str(ii)])
    pause
end
