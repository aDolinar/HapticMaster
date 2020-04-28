function [avg_y, avg_z] = pathYZ_healthyGroup(haptic_data, n_of_subjects,idxs_damping,idxs_healthy)
%GRAF POVPRECNE POTI vseh zdravih, treba zagnat za prikaz puscic v subplotu
    
    avg_y = zeros(200,16);
    avg_z = avg_y;
    for damping_no = idxs_damping

        for target_no = 1:16
            
            %izracun povprecnih vredonsti
            sum_y = zeros(size((haptic_data(n_of_subjects).damping(damping_no).position_y_path(1).U((target_no-1)*200+1:target_no*200))));
            sum_z = sum_y;
            n = 0;
            for subject_no = idxs_healthy
                for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
                    sum_y = sum_y + (haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U((target_no-1)*200+1:target_no*200));
                    sum_z = sum_z + (haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V((target_no-1)*200+1:target_no*200));
                    n = n+1;
                end
            end
            avg_y(:,target_no) = sum_y/n;
            avg_z(:,target_no) = sum_z/n;

        end
    end

end

