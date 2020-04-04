clc;close all; 
load('haptic_data.mat');

t_norm=1:200;
%GRAFI ZA POT
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        
        for target_no = 1:16
            close all
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
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
for damping_no = 3:3
%     close all
    
    for target_no = 1:16
        
        for subject_no = 1:16
            close all
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                figure(subject_no)
                hold on
                plot(t_norm,haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))
                plot(t_norm,haptic_data(subject_no).damping(damping_no).force_right_hand_path(repetition_no).O((target_no-1)*200+1:target_no*200))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('left handle force, rep1','right handle force, rep1','left handle force, rep2','right handle force, rep2')
                ylabel('Force [N]')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                %pause
                
            end
        end
    end
end

%GRAFI ZA RAZMERJE SIL
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        
        for target_no = 1:16
            close all
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                figure(subject_no)
                hold on
                plot(t_norm, 100*((haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))./((haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).force_right_hand_path(repetition_no).O((target_no-1)*200+1:target_no*200)))))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('rep 1','rep 2')
                ylabel('Force Ratio')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                %pause
                
            end
        end
    end
end

%GRAFI ZA HITROST
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        
        for target_no = 1:16
            close all
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                figure(subject_no)
                hold on
                plot(t_norm,haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no).M((target_no-1)*200+1:target_no*200))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
                ylabel('Distance @ handle [m]')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                %pause
                
            end
        end
    end
end

%GRAFI POVPRECNE HITROSTI
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        
        for target_no = 1:16
            avg_speed = ((haptic_data(subject_no).damping(damping_no).hand_speed_path(1).M((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).hand_speed_path(2).M((target_no-1)*200+1:target_no*200)))/2;
            
            close all
            figure(subject_no)
            hold on
            plot(t_norm,avg_speed)
            set(gcf, 'Position', get(0, 'Screensize'));
            legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
            ylabel('Distance @ handle [m]')
            xlabel('Normalised time')
            title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', target = ', int2str(target_no)])
            pause
        end
    end
end

%GRAFI POVPRECNE POTI
for damping_no = 3:3
%     close all
    
    for target_no = 1:16
        
        for subject_no = 1:16
            avg_x = ((haptic_data(subject_no).damping(damping_no).position_x_path(1).T((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).position_x_path(2).T((target_no-1)*200+1:target_no*200)))/2;
            avg_y = ((haptic_data(subject_no).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).position_y_path(2).U((target_no-1)*200+1:target_no*200)))/2;
            avg_z = ((haptic_data(subject_no).damping(damping_no).position_z_path(1).V((target_no-1)*200+1:target_no*200))+(haptic_data(subject_no).damping(damping_no).position_z_path(2).V((target_no-1)*200+1:target_no*200)))/2;
            
            close all
            figure(subject_no)
            hold on
            plot(t_norm,avg_x)
            plot(t_norm,avg_y)
            plot(t_norm,avg_z)
            set(gcf, 'Position', get(0, 'Screensize'));
            legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
            ylabel('Distance @ handle [m]')
            xlabel('Normalised time')
            title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
            pause
        end
    end
end

%GRAFI TRAJEKTORIJE Z(Y)
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        
        for target_no = 1:16
            close all
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                figure(subject_no)
                hold on
                plot(haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200),haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200))
                set(gcf, 'Position', get(0, 'Screensize'));
                legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
                ylabel('Distance @ handle [m]')
                xlabel('Normalised time')
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no), ', target = ', int2str(target_no)])
                %pause
                
            end
        end
    end
end

%GRAFI CELOTNE TRAJEKTORIJE Z(Y)
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        close all
        for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
            figure(subject_no)
            hold on
            plot(haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U,haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V)
            set(gcf, 'Position', get(0, 'Screensize'));
            legend('x path, rep1','y path, rep1','z path, rep1', 'x path, rep2', 'y path, rep2', 'z path, rep2')
            ylabel('Distance @ handle [m]')
            xlabel('Normalised time')
            title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', repetition = ', int2str(repetition_no)])
            pause

        end
    end
end


%GRAF POVPRECNE POTI zdravi vs ne-zdravi vs elastika
for damping_no = 3:3
%     close all
    
    for target_no = 1:16
        close all
        figure()
        ylabel('Distance @ handle [m]')
        xlabel('Normalised time')
        hold on
        for subject_no = 1:16
            %izracun povprecnih vredonsti
            sum_y = zeros(size((haptic_data(subject_no).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
            sum_z = sum_y;
            for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                sum_y = sum_y + (haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200));
                sum_z = sum_z + (haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200));
            end
            avg_y = sum_y/repetition_no;
            avg_z = sum_z/repetition_no;
            
            %plottanje
            if subject_no <= 5
                plot(t_norm,avg_y,'color','b')
                plot(t_norm,avg_z,'color','b')
            elseif subject_no <= 9
                plot(t_norm,avg_y,'color','g')
                plot(t_norm,avg_z,'color','g')
            elseif subject_no <= 12
                plot(t_norm,avg_y,'color','y')
                plot(t_norm,avg_z,'color','y')
            else
                plot(t_norm,avg_y,'color','r')
                plot(t_norm,avg_z,'color','r')
            end
                    
            set(gcf, 'Position', get(0, 'Screensize'));
            legend()
            title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', target = ', int2str(target_no)])
            pause
        end
    end
end