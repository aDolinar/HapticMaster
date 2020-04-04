clc;close all; 
load('haptic_data.mat');

t_norm=1:200;
%GRAFI ZA POT
for damping_no = 1:1
%     close all
    
    for subject_no = 1:9
        
        for target_no = 1:16
            close all
            for repetition_no = 1:2
                figure(subject_no)
                hold on
                plot(t_norm,haptic_data(subject_no).damping(damping_no).position_x_path(repetition_no).T((target_no-1)*200+1:target_no*200))
                plot(t_norm,haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200))
                plot(t_norm,haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
                ylabel('Distance @ handle [m]')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                pause
                
            end
        end
    end
end

%GRAFI ZA SILO L IN R
%pazi vrstni red subject/target
for damping_no = 1:1
%     close all
    
    for target_no = 1:16
        
        for subject_no = 1:9
            close all
            for repetition_no = 1:2
                figure(subject_no)
                hold on
                plot(t_norm,haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))
                plot(t_norm,haptic_data(subject_no).damping(damping_no).force_right_hand_path(repetition_no).O((target_no-1)*200+1:target_no*200))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('left handle force, rep1','right handle force, rep1','left handle force, rep2','right handle force, rep2')
                ylabel('Force [N]')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                pause
                
            end
        end
    end
end

%GRAFI ZA RAZMERJE SIL
for damping_no = 1:1
%     close all
    
    for subject_no = 1:9
        
        for target_no = 1:16
            close all
            for repetition_no = 1:2
                figure(subject_no)
                hold on
                plot(t_norm, 100*((haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))./((haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).force_right_hand_path(repetition_no).O((target_no-1)*200+1:target_no*200)))))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('rep 1','rep 2')
                ylabel('Force Ratio')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                pause
                
            end
        end
    end
end
%t test
%a nova