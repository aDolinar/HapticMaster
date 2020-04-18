clc;close all; 
load('haptic_data.mat');
damping_no=3;
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
%%
%porazdeljenost pospesevanja
clc
kernel=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
kernel=kernel.*(1/(length(kernel)));
kernel=kernel./(sum(kernel))
length(kernel)
for target_no=1:16
    close all
    for subject_no=1:16
        idxStart=1+(target_no-1)*200;
        idxEnd=idxStart+199;
        
        trajY1=haptic_data(subject_no).damping(damping_no).position_y_path(1).U(idxStart:idxEnd);
        trajZ1=haptic_data(subject_no).damping(damping_no).position_z_path(1).V(idxStart:idxEnd);
        velY1=diff(trajY1);
        velZ1=diff(trajZ1);
        accY1=diff(velY1);
        accZ1=diff(velZ1);
        
        trajY2=haptic_data(subject_no).damping(damping_no).position_y_path(2).U(idxStart:idxEnd);
        trajZ2=haptic_data(subject_no).damping(damping_no).position_z_path(2).V(idxStart:idxEnd);
        velY2=diff(trajY2);
        velZ2=diff(trajZ2);
        accY2=diff(velY2);
        accZ2=diff(velZ2);
        
        accY1f=zeros(1,length(accY1)-2*floor(length(kernel)/2));
        accZ1f=zeros(1,length(accZ1)-2*floor(length(kernel)/2));
        accY2f=zeros(1,length(accY2)-2*floor(length(kernel)/2));
        accZ2f=zeros(1,length(accZ2)-2*floor(length(kernel)/2));
        
        for i=[1+floor(length(kernel)/2):idxEnd-idxStart-floor(length(kernel)/2)-1]
            accY1f(i-floor(length(kernel)/2))=sum(accY1(i-floor(length(kernel)/2):i+floor(length(kernel)/2)).*kernel');
            accZ1f(i-floor(length(kernel)/2))=sum(accZ1(i-floor(length(kernel)/2):i+floor(length(kernel)/2)).*kernel');
            accY2f(i-floor(length(kernel)/2))=sum(accY2(i-floor(length(kernel)/2):i+floor(length(kernel)/2)).*kernel');
            accZ2f(i-floor(length(kernel)/2))=sum(accZ2(i-floor(length(kernel)/2):i+floor(length(kernel)/2)).*kernel');
        end
        
        figure()
        %hold on
        subplot(2,1,1);
        plot([1+floor(length(kernel)/2):idxEnd-idxStart-floor(length(kernel)/2)-1],accY1f,[1+floor(length(kernel)/2):idxEnd-idxStart-floor(length(kernel)/2)-1],accY2f);
        title("acc Y");
        legend('repetition 1','repetition 2')
        subplot(2,1,2);
        plot([1+floor(length(kernel)/2):idxEnd-idxStart-floor(length(kernel)/2)-1],accZ1f,[1+floor(length(kernel)/2):idxEnd-idxStart-floor(length(kernel)/2)-1],accZ2f);
        title("acc Z");
        legend('repetition 1','repetition 2')
        text=strcat("subject no: ",num2str(subject_no),", target no: ",num2str(target_no));
        %text=["subject no: ",num2str(subject_no),", target no: ",num2str(target_no)];
        sgtitle(text,'FontSize',14);
        set(gcf, 'Position', get(0, 'Screensize'));
        %hold off
    end
    pause
end
%%
%porazdeljenost pospesevanja putr
clc
Wn = 20/100;                   % Normalized cutoff frequency        
[Fb,Fa]=butter(4,Wn);


for target_no=1:16
    close all
    for subject_no=1:16
        idxStart=1+(target_no-1)*200;
        idxEnd=idxStart+199;
        
        trajY1=haptic_data(subject_no).damping(damping_no).position_y_path(1).U(idxStart:idxEnd);
        trajZ1=haptic_data(subject_no).damping(damping_no).position_z_path(1).V(idxStart:idxEnd);
        velY1=diff(trajY1);
        velZ1=diff(trajZ1);
        accY1=diff(velY1);
        accZ1=diff(velZ1);
        
        trajY2=haptic_data(subject_no).damping(damping_no).position_y_path(2).U(idxStart:idxEnd);
        trajZ2=haptic_data(subject_no).damping(damping_no).position_z_path(2).V(idxStart:idxEnd);
        velY2=diff(trajY2);
        velZ2=diff(trajZ2);
        accY2=diff(velY2);
        accZ2=diff(velZ2);
        
        accY1f=filter(Fb,Fa,accY1);
        accZ1f=filter(Fb,Fa,accZ1);
        accY2f=filter(Fb,Fa,accY2);
        accZ2f=filter(Fb,Fa,accZ2);
        
        figure()
        %hold on
        subplot(2,1,1);
        plot([1:length(accY1f)],accY1f,[1:length(accY2f)],accY2f);
        title("acc Y");
        legend('repetition 1','repetition 2')
        subplot(2,1,2);
        plot([1:length(accZ1f)],accZ1f,[1:length(accZ2f)],accZ2f);
        title("acc Z");
        legend('repetition 1','repetition 2')
        text=strcat("subject no: ",num2str(subject_no),", target no: ",num2str(target_no));
        %text=["subject no: ",num2str(subject_no),", target no: ",num2str(target_no)];
        sgtitle(text,'FontSize',14);
        set(gcf, 'Position', get(0, 'Screensize'));
        %hold off
    end
    pause
end