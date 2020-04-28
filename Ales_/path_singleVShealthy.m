function path_singleVShealthy(haptic_data,n_of_subjects,idxs_damping,idxs_elastic,idxs_students,idxs_healthy,idxs_patient,avg_y,avg_z)
%GRAFA POVPRECNE POTI vseh zdravih in POTI 1 subjekta v Y in Z smereh
%   Detailed explanation goes here
    
    t_norm=1:200;
    avg_y_st = zeros(200,n_of_subjects,16);
    avg_z_st = avg_y_st;
    for damping_no = idxs_damping
    %     close all

        for target_no = 1:16

            %izracun std. dev. "vertikalno"
            vsota_y = zeros(size((haptic_data(1).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
            vsota_z = vsota_y;
            n = 0;
            for subject_no = idxs_healthy
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    vsota_y = vsota_y + ((haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200))-avg_y(:,target_no)).^2;
                    vsota_z = vsota_z + ((haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200))-avg_z(:,target_no)).^2;
                    n = n+1;
                end
            end
            var_vY = vsota_y./(n-1);
            var_vZ = vsota_z./(n-1);
            std_dev_vY = sqrt(var_vY);
            std_dev_vZ = sqrt(var_vZ);

            for subject_no = 1:n_of_subjects

                close all
                figure()
                set(gcf, 'Position', get(0, 'Screensize'));

                subplot('Position',[0.1 0.55 0.65 0.35])
                axis([0 200 -0.2 0.2])
                ylabel('Distance @ handle [m]')
                xlabel('Normalised time')
                title(['subject = 1->', int2str(n_of_subjects),', damping = ', int2str(damping_no), ', target = ', int2str(target_no), ', y axis'])
                hold on

                subplot('Position',[0.1 0.1 0.65 0.35])
                axis([0 200 -0.2 0.2])
                ylabel('Distance @ handle [m]')
                xlabel('Normalised time')
                title(['subject = 1->', int2str(n_of_subjects),', damping = ', int2str(damping_no), ', target = ', int2str(target_no), ', z axis'])
                hold on

                subplot('Position',[0.8 0.65 0.15 0.25])
                p1 = [avg_y(1,target_no) avg_z(1,target_no)];                         % First Point
                p2 = [avg_y(length(avg_y),target_no) avg_z(length(avg_z),target_no)];                         % Second Point
                dp = p2-p1;                         % Difference
                figure(1)
                quiver(p1(1),p1(2),dp(1),dp(2),0)
                axis([-0.2 0.2 -0.2 0.2])
                title('Trenutni gib v z(y) ravnini')
                xlabel('y coordinate')
                ylabel('z coordinate')

                %izracun povprecnih vredonsti
                sum_y = zeros(size((haptic_data(subject_no).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
                sum_z = sum_y;
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    sum_y = sum_y + (haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200));
                    sum_z = sum_z + (haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200));
                end
                avg_y_st(:,subject_no,target_no) = sum_y/repetition_no;
                avg_z_st(:,subject_no,target_no) = sum_z/repetition_no;

                %plot "referencne" poti
                subplot('Position',[0.1 0.55 0.65 0.35])
                plot(t_norm,avg_y(:,target_no),'color','b')
                subplot('Position',[0.1 0.1 0.65 0.35])
                plot(t_norm,avg_z(:,target_no),'color','b')
                %plot std. dev. "ref" poti vertikalno
                subplot('Position',[0.1 0.55 0.65 0.35])
                plot(t_norm,(avg_y(:,target_no)-std_dev_vY),'--','color','r')
                plot(t_norm,(avg_y(:,target_no)+std_dev_vY),'--','color','r')
                subplot('Position',[0.1 0.1 0.65 0.35])
                plot(t_norm,(avg_z(:,target_no)-std_dev_vZ),'--','color','r')
                plot(t_norm,(avg_z(:,target_no)+std_dev_vZ),'--','color','r')

                %plottanje
                if ismember(subject_no, idxs_elastic)
                    %elastike, blue
                    subplot('Position',[0.1 0.55 0.65 0.35])
                    plot(t_norm,avg_y_st(:,subject_no,target_no),'color','m')
                    subplot('Position',[0.1 0.1 0.65 0.35])
                    plot(t_norm,avg_z_st(:,subject_no,target_no),'color','m')
                elseif ismember(subject_no, idxs_students)
                    %zdravi (studenti), green
                    subplot('Position',[0.1 0.55 0.65 0.35])
                    plot(t_norm,avg_y_st(:,subject_no,target_no),'color','g')
                    subplot('Position',[0.1 0.1 0.65 0.35])
                    plot(t_norm,avg_z_st(:,subject_no,target_no),'color','g')
                elseif ismember(subject_no, idxs_healthy)
                    %zdravi, black
                    subplot('Position',[0.1 0.55 0.65 0.35])
                    plot(t_norm,avg_y_st(:,subject_no,target_no),'color','k')
                    subplot('Position',[0.1 0.1 0.65 0.35])
                    plot(t_norm,avg_z_st(:,subject_no,target_no),'color','k')
                elseif ismember(subject_no, idxs_patient)
                    %pacienti, red
                    subplot('Position',[0.1 0.55 0.65 0.35])
                    plot(t_norm,avg_y_st(:,subject_no,target_no),'color','r')
                    subplot('Position',[0.1 0.1 0.65 0.35])
                    plot(t_norm,avg_z_st(:,subject_no,target_no),'color','r')
                end

                legend('Reference path','-1 Std. dev. repetition-wise of reference path','+1 Std. dev. repetition-wise of reference path','Current subject');
                legend('Location', [0.82 0.25 0.12 0.2])
                pause
            end

            pause
        end
    end

end