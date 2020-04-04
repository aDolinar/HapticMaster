clc;close all; 
load('haptic_data.mat');

t_norm=1:200;
%%
%GRAFI CELOTNE TRAJEKTORIJE Z(Y)
for damping_no = 3:3
%     close all
    
    for subject_no = 1:16
        close all
        %for repetition_no = 1:(haptic_data(subject_no).damping(damping_no).data_all(40,1))
            figure(subject_no)
            hold on
            plot(haptic_data(subject_no).damping(damping_no).position_y_path(1).U,haptic_data(subject_no).damping(damping_no).position_z_path(1).V,haptic_data(subject_no).damping(damping_no).position_y_path(2).U,haptic_data(subject_no).damping(damping_no).position_z_path(2).V)
            set(gcf, 'Position', get(0, 'Screensize'));
            legend('repetition 1','repetition 2','repetition 3')
            ylabel('Distance @ handle [m]')
            xlabel('Normalised time')
            title(['subject = ', int2str(subject_no),', damping = ', int2str(damping_no), ', 2 repetitions '])
            pause

        %end
    end
end
%%
%evklidska razdalja
%kar sem dodajal jaz
%podobnost dveh gibov
clc
close all
damping_no=3;
for subject_no1=1:16
    for subject_no2=1:16
        if subject_no1==subject_no2
            euclidDistance(subject_no1,subject_no2)=0;
        else
            trajY1=haptic_data(subject_no1).damping(damping_no).position_y_path(1).U;
            trajZ1=haptic_data(subject_no1).damping(damping_no).position_z_path(1).V;
            trajY2=haptic_data(subject_no2).damping(damping_no).position_y_path(1).U;
            trajZ2=haptic_data(subject_no2).damping(damping_no).position_z_path(1).V;
%             figure()
%             plot(trajY1,trajZ1,trajY2,trajZ2);
%             title(['trajektorije od subjectov ', num2str(subject_no1),' in ', num2str(subject_no2)]);
             deltaTrajZ=trajZ1-trajZ2;
             deltaTrajY=trajY1-trajY2;
             distanceTraj=sqrt(power(deltaTrajZ,2)+power(deltaTrajY,2));
%             figure()
%             plot([1:3200],distanceTraj);
%             title('odstopanje med potema');
            euclidDistance(subject_no1,subject_no2)=sqrt((1/3200)*sum(power(distanceTraj,2)));
            %pause
        end
    end
end
euclidDistance