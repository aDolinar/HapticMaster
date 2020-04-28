function speed_singleVShealthy(haptic_data,n_of_subjects,idxs_damping,idxs_healthy,avg_y,avg_z)
%GRAF POVPRECNE HITROSTI vseh zdravih
%   Detailed explanation goes here
    
    t_norm=1:200;

    for damping_no = idxs_damping

        for target_no = 1:16

            %izracun povprecnih vredonsti
            sum_speed = zeros(size((haptic_data(1).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
            n = 0;
            for subject_no = idxs_healthy
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    sum_speed = sum_speed + (haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no).M((target_no-1)*200+1:target_no*200));
                    n = n+1;
                end
            end
            avg = sum_speed/n;
            %izracun std. dev. od "avg", vzdolz casa
            var = sum((avg-(sum(avg)/length(avg))).^2)/(length(avg)-1);
            std_dev = sqrt(var);

            %izracun std. dev. "vertikalno"
            vsota = zeros(size((haptic_data(1).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
            n = 0;
            for subject_no = idxs_healthy
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    vsota = vsota + ((haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no).M((target_no-1)*200+1:target_no*200))-avg).^2;
                    n = n+1;
                end
            end
            var_v = vsota./(n-1);
            std_dev_v = sqrt(var_v);


            for subject_no = 1:n_of_subjects

                close all
                figure()
                set(gcf, 'Position', get(0, 'Screensize'));

                %subplot za main graf
                subplot('Position',[0.1 0.1 0.65 0.8])
                ylabel('Speed @ handle [m/s]')
                xlabel('Normalised time')
                axis([0 200 0 0.35])
                hold on
                title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', target = ', int2str(target_no)])

                %izracun povprecnih vredonsti
                sum_speed1 = zeros(size((haptic_data(subject_no).damping(damping_no).hand_speed_path(1).M((target_no-1)*200+1:target_no*200))));
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    sum_speed1 = sum_speed1 + (haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no).M((target_no-1)*200+1:target_no*200));
                end
                avg1 = sum_speed1/repetition_no;


                %plot "referencne" hitrosti
                plot(t_norm,avg,'color','b')
                %plot std. dev. od povprecja(casovno) "ref" hitrosti
                vector_of_scalar = zeros(size(t_norm));
                vector_of_scalar(:) = ((sum(avg)/length(avg)));
                plot(t_norm,vector_of_scalar,'color','g')
                plot(t_norm,vector_of_scalar-std_dev,'--','color','g')
                plot(t_norm,vector_of_scalar+std_dev,'--','color','g')
                %plot std. dev. "ref" hitrosti vertikalno
                plot(t_norm,(avg-std_dev_v),'--','color','r')
                plot(t_norm,(avg+std_dev_v),'--','color','r')


                %plottanje posameznih subjectov
                plot(t_norm,avg1,'color','m')
                legend('Avg. hitrost zdravih','Avg. (timewise) hitrost zdravih','1 Std. dev. (timewise) of reference speed','1 Std. dev. (timewise) of reference speed','1 Std. dev. vertically of reference speed','1 Std. dev. vertically of reference speed','Current subject')
                legend('Location', [0.82 0.36 0.12 0.2])

                %subplot za prikaz giba
                subplot('Position',[0.8 0.65 0.15 0.25])
                p1 = [avg_y(1,target_no) avg_z(1,target_no)];                         % First Point
                p2 = [avg_y(length(avg_y),target_no) avg_z(length(avg_z),target_no)]; % Second Point
                dp = p2-p1;                         % Difference
                figure(1)
                quiver(p1(1),p1(2),dp(1),dp(2),0)
                axis([-0.2 0.2 -0.2 0.2])
                title('Trenutni gib v z(y) ravnini')
                xlabel('y coordinate')
                ylabel('z coordinate')

                pause

            end

        end
    end

end

