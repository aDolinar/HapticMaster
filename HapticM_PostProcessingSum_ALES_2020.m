%% Spreminjamo za posamezno iteracijo%%
% [15] Pot do datoteke meritev: experiments_folder = dir('/*.mat'); % preberemo ?tevilo .mat datotek
% [28] Pot do FolderName = 'C:\Users\An?e\Desktop\Mag. naloga\02_Matlab_statistika_00\23_16_1\Measurements_14.1.19_extract';
% no_damp_iterations = 3; % 3 velja le v primeru, da imamo za vsak objekt vedno 3 razli?ne damping-e

%% Inicializacija
clc; close all; clear all;
% pot = 'C:\Users\ana\Desktop\FAKS\znanstveni seminar 2019_20\Ana\Meritve\haptic data - vsi skupaj[zdr,Dpar,Lpar]';
pot = '.\Meritve';%'E:\PHD\3_ROBOT\Znanstveni seminar 2019 Ana\SUROVI PODATKI\haptic data - vsi skupaj[zdr,Dpar,Lpar]';

% ?tevilo map v mapi --> subject_no_folder
% experiments_folder = dir('C:\Users\An?e\Desktop\Mag. naloga\02_Matlab_statistika_00\23_16_1\Measurements_14.1.19');
% sum_subfolder = sum([experiments_folder(~ismember({experiments_folder.name},{'.','..'})).isdir]);

% ?tevilo .mat datotek v mapi --> subject_no_folder
no_damp_iterations = 3; % !!!PAZI!!! 3 velja le v primeru, da imamo za vsak objekt vedno 3 razli?ne damping-e
no_subjects = 16;
experiments_folder = dir([pot,'/*.mat']); %dir([pot,'/*.mat'])CHANGE

sum_subfolder = numel(experiments_folder) / no_damp_iterations; 
%addpath('C:\Users\ana\Desktop\znanstveni seminar 2019_20\Ana\Tools\interparc')

% Po korakih polnimo strukturo haptic_data
% Ugotovimo ?tevilo objektov, ki smo jih merili (sum_subfolder)
% Privzamemo, da imamo le tri razli?ne Damping vrednosti (0, 20, 40): damping_no_folder
% Izvedemo algoritem za vsak objekt za vse tri Damping vrednosti
% !!PAZI!!: ?e se spremeni ?tevilo Damping vrednosti, popravi vrednost 3 v
% for zanki na pravo stevilo Damping vrednosti ter stevilo s katerim delis numel(experiments_folder)
for subject_no_folder = 1:no_subjects
    for damping_no_folder = 3:no_damp_iterations
        FileName = ['s', num2str(subject_no_folder), '_', num2str(damping_no_folder), 'd.mat'];
        FolderName = pot;
        File = fullfile(FolderName, FileName);
        sample = load(File); % Nalo?imo podatke
%         sample.data = data;
        
        %Nalo?imo strukturo haptic_data      
        if ~(subject_no_folder == 2 && damping_no_folder == 1)
            load('haptic_data.mat');
        end %this is usable if you use the proper naming scheme
        
        %% Definiranje spremenljivk in poti;
        dT = 1/200; % Definiramo za nizkopasovni filter
        subject_no = subject_no_folder % To spreminjas glede na stevilko merjenca
        damping_no = damping_no_folder; % To spreminjas glede na velikost dampinga
        no_samples = 200; % definiramo za interparc funkcijo              
        
        % Dodamo poti do funkcij
        addpath('.\EvaFunkcije\interparc')
        addpath('.\EvaFunkcije\Segmentacija')
        %% Filtriranje podatkov - nizkopasovni filter
        filter = designfilt('lowpassiir','FilterOrder',5, ...
            'HalfPowerFrequency',10, ...
            'SampleRate',1/dT);
        
        % Filtriramo samo meritve
        data = sample.data;
        for ii = [2:27 29:34]
            data(ii,:) = filtfilt(filter, sample.data(ii,:));
        end
        
        %% Odre?emo odve?ne meritve na za?etku in koncu (pred prvo in po zadnji tar?i) [36], [37]
        [row,col] = find(diff(data(36,:)));
        
        data = data(:,col(1):col(end)+1); % Dodana dodatna meritev, da se izri?e zadnji col_target
        
        %%  Matlab time [1] & Real time [28], odstranimo offset in postavimo za?etni ?as na 0
        offset_matlab = data(1,1);
        offset_robot = data(28,1);
        for j=1:1:size(data,2)
            data(1,j) = data(1,j) - offset_matlab;
            data(28,j) = data(28,j) - offset_robot;
        end
        
        %% Ustvarimo strukturo za data_all: vsi podatki - filtrirani, odstranjen offset ?asa, odrezani podatki na za?etku in koncu
        haptic_data(subject_no).damping(damping_no).data_all = data;
        
        %% Poi??emo odseke - col stolpce za repetition
        [row_repetition,col_repetition] = find(diff(data(37,:)));
        if length(col_repetition)<data(40,1) 
            col_repetition=[col_repetition (data(1,end)*200)];
        elseif length(col_repetition)>data(40,1)
            col_repetition=col_repetition(1:data(40,1));
        end
        %% Obdelujemo posamezne odseke ponovitev
        % Lo?evanje odsekov ponovitev(repetition_no), iskanje odsekov target triggerjev, iskanje minimuma znotraj odsekov target triggerjev
        for repetition_no = 1:data(40,1) % 40 vrstica, 1 stolpec - Number of repetitions
            startIndex = 0;
            if repetition_no == 1
                [row_target,col_target] = find(diff(data(36,1:col_repetition(repetition_no)+1))); % [36] - Trigger after 3s + hitting the target
                startIndex = 0;
                
                if length(col_target)== 33
                    col_target=[col_target col_repetition(repetition_no)];
                    error_col_target_1 = 1;
                end
                
            elseif repetition_no == data(40,1) % 40 vrstica, 1 stolpec - Number of repetitions
                [row_target,col_target] = find(diff(data(36,col_repetition(end-1)+1:col_repetition(repetition_no)+1)));
                startIndex = col_repetition(end-1);
                
                if length(col_target)== 33 %&& error_col_target_2 == 1
                    col_target=[1 col_target];
                elseif length(col_target)== 32
                    break
                end
                
            else
                [row_target,col_target] = find(diff(data(36,col_repetition(repetition_no-1)+1:col_repetition(repetition_no)+1)));
                startIndex = col_repetition(repetition_no-1);
                
                if length(col_target)== 33 && error_col_target_1 == 1
                    col_target=[1 col_target];
                elseif length(col_target)== 33 && error_col_target_1 ~= 1
                    col_target=[col_target col_repetition(repetition_no)-startIndex];
                    error_col_target_2 = 1;
                elseif length(col_target)== 32
                    col_target=[1 col_target col_repetition(repetition_no)-startIndex];
                    error_col_target_2 = 1;
                end
                
            end
            
            % Kreiramo prazno matriko: polnimo jo z col lokacijami minimumov posameznega odseka target intervala - gledano globalno - glede na podatke data
            StartEnd_idx = zeros((data(39,1)-1),2);
            
            for target_no = 1:data(39,1) % 39 vrstica, 1 stolpec - Number of targets
                target_vector = [1:2:length(col_target)]; % Pridobimo zaporedne ?tevilke s katerimi si pomagamo pri zapisu odseka Trigger after 3s + hitting the target
                target_interval = data(:,(startIndex+col_target(target_vector(target_no))):(startIndex+col_target(target_vector(target_no)+1))); % Pridobimo odsek signalov na posameznem odseku Trigger after 3s + hitting the target
                
                % hand_velocity & hand_speed na posameznem target_interval odseku
                hand_velocity = [target_interval(32,:)', target_interval(33,:)', target_interval(34,:)'];
                hand_speed = sqrt(hand_velocity(:,1).^2+hand_velocity(:,2).^2+hand_velocity(:,3).^2);
                
                % Uporabimo findpeaks funkcijo za iskanje minimuma
                % I??emo maximum inverza signala hitrosti na iskanem signalu - v resnici minimum
                inv_velocity = (1-hand_speed/max(hand_speed)).^3;
                inv_velocity = inv_velocity/max(inv_velocity);
                
                if length(inv_velocity) <= 3
                   idx = 0 + startIndex + col_target(target_vector(target_no));
                   %                    vel_locs =
                else
                    [vel_pks,vel_locs] = findpeaks(inv_velocity);
                    
                    % I??emo col lokacijo minimuma na posameznem target_intervalu - col lokacija je podana globalno glede na podatke data (gledano od prvega sampla naprej)
                    [min_vel_pks idx] = max(vel_pks); % Dobimo indeks minimuma
                    idx = vel_locs(idx) + startIndex + col_target(target_vector(target_no)); % Kon?ni indeks je sestavljen iz vsote: lokacija min na target_interval + vsi sampli od za?etka + lokacija col_taget
                    
                end
                
                % Kreiramo 'tabelo' parov indeksov - lokacij minimumov na target_interval za posamezno periodo
                if target_no == 1
                    StartEnd_idx(target_no,1) = idx;
                elseif target_no == (data(39,1))
                    StartEnd_idx(target_no-1,2) = idx;
                else
                    StartEnd_idx(target_no,1)=idx;
                    StartEnd_idx(target_no-1,2)=idx;
                end
                
            end
            
            haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx = StartEnd_idx;
            
            %% Remove time from trajectory - interparc %%
            
            % hand_trajectory
            hand_trajectory = [data(2,:)', data(3,:)', data(4,:)'];
%             figure
%             plot(hand_trajectory)
            % hand_velocity & hand_speed
            hand_velocity = [data(32,:)', data(33,:)', data(34,:)'];
            hand_speed = sqrt(hand_velocity(:,1).^2+hand_velocity(:,2).^2+hand_velocity(:,3).^2);
            hand_speed_basic = hand_velocity(:,1).^2+hand_velocity(:,2).^2+hand_velocity(:,3).^2; %%%
            
            % Force left hand
            force_left = [data(7,:)', data(8,:)', data(9,:)'];
            force_left_hand = sqrt(force_left(:,1).^2+force_left(:,2).^2+force_left(:,3).^2);
            
            % Force right hand
            force_right = [data(13,:)', data(14,:)', data(15,:)'];
            force_right_hand = sqrt(force_right(:,1).^2+force_right(:,2).^2+force_right(:,3).^2);
            
            % Common force
            c_force = [data(25,:)', data(26,:)', data(27,:)'];
            common_force = sqrt(c_force(:,1).^2+c_force(:,2).^2+c_force(:,3).^2);
            
            % Angle of the handle 1
            angle_handle_1 = [data(5,:)'];
            
            % Angle of the handle 2
            angle_handle_2 = [data(6,:)'];
            
            % Position x
            position_1x = [data(2,:)'];
            position_x = position_1x(:,1);
            
            % Position y
            position_1y = [data(3,:)'];
            position_y = position_1y(:,1);
            
            % Position z
            position_1z = [data(4,:)'];
            position_z = position_1z(:,1);
            
            % Real time from the robot
            real_time_robot = [data(28,:)'];
            
            M = [];  N = []; O = []; P = []; R = []; S = []; T = []; U = []; V = [];
            size_StartEnd_idx = size((haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx),1);
            
            for i = 1: size_StartEnd_idx
                if i == 1
                    hand_trajectory_reduced = hand_trajectory(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    hand_speed_reduced = hand_speed(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    hand_velocity_reduced = hand_velocity(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    hand_speed_basic_reduced = hand_speed_basic(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    real_time_robot_reduced = real_time_robot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    uuz1 = hand_velocity_reduced; %%%
                    zzu1 = hand_speed_basic_reduced; %%%
                    rrt1 = hand_trajectory_reduced; %%%
                    trr1 = hand_speed_reduced; %%%
                    rtr1 = real_time_robot_reduced; %%%
                    smooth_data(subject_no).damping(damping_no).hand_trajectory_smooth(repetition_no).RRT1 = rrt1; %%%
                    smooth_data(subject_no).damping(damping_no).hand_speed_smooth(repetition_no).TRR1 = trr1; %%%
                    smooth_data(subject_no).damping(damping_no).hand_velocity_smooth(repetition_no).UUZ1 = uuz1; %%%
                    smooth_data(subject_no).damping(damping_no).hand_speed_basic_smooth(repetition_no).ZZU1 = zzu1; %%%
                    smooth_data(subject_no).damping(damping_no).real_time_robot_smooth(repetition_no).RTR1 = rtr1; %%%

                    force_left_hand_reduced = force_left_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    force_right_hand_reduced = force_right_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    common_force_reduced = common_force(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_1_reduced = angle_handle_1(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_2_reduced = angle_handle_2(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_x_reduced = position_x(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_y_reduced = position_y(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_z_reduced = position_z(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);                    
                elseif i == size_StartEnd_idx
                    hand_trajectory_reduced = hand_trajectory(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    hand_speed_reduced = hand_speed(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    hand_velocity_reduced = hand_velocity(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    hand_speed_basic_reduced = hand_speed_basic(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    real_time_robot_reduced = real_time_robot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    rrt5 = hand_trajectory_reduced; %%%
                    trr5 = hand_speed_reduced; %%%
                    uuz5 = hand_velocity_reduced; %%%
                    zzu5 = hand_speed_basic_reduced; %%%
                    rtr5 = real_time_robot_reduced; %%%
                    smooth_data(subject_no).damping(damping_no).hand_trajectory_smooth(repetition_no).RRT5 = rrt5; %%%
                    smooth_data(subject_no).damping(damping_no).hand_speed_smooth(repetition_no).TRR5 = trr5; %%%
                    smooth_data(subject_no).damping(damping_no).hand_velocity_smooth(repetition_no).UUZ5 = uuz5; %%%
                    smooth_data(subject_no).damping(damping_no).hand_speed_basic_smooth(repetition_no).ZZU5 = zzu5; %%%
                    smooth_data(subject_no).damping(damping_no).real_time_robot_smooth(repetition_no).RTR5 = rtr5; %%%
                    
                    force_left_hand_reduced = force_left_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    force_right_hand_reduced = force_right_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    common_force_reduced = common_force(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_1_reduced = angle_handle_1(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_2_reduced = angle_handle_2(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_x_reduced = position_x(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_y_reduced = position_y(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_z_reduced = position_z(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                else
                    hand_trajectory_reduced = hand_trajectory(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    hand_speed_reduced = hand_speed(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    
                    hand_velocity_reduced = hand_velocity(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    hand_speed_basic_reduced = hand_speed_basic(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    real_time_robot_reduced = real_time_robot(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:); %%%
                    
                    force_left_hand_reduced = force_left_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    force_right_hand_reduced = force_right_hand(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    common_force_reduced = common_force(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_1_reduced = angle_handle_1(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    angle_handle_2_reduced = angle_handle_2(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_x_reduced = position_x(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_y_reduced = position_y(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                    position_z_reduced = position_z(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(i,2),:);
                
                    if i == 2%%%
                        rrt2 = hand_trajectory_reduced; %%%
                        trr2 = hand_speed_reduced; %%%
                        uuz2 = hand_velocity_reduced; %%%
                        zzu2 = hand_speed_basic_reduced; %%%
                        rtr2 = real_time_robot_reduced; %%%
                        smooth_data(subject_no).damping(damping_no).hand_trajectory_smooth(repetition_no).RRT2 = rrt2; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_smooth(repetition_no).TRR2 = trr2; %%%
                        smooth_data(subject_no).damping(damping_no).hand_velocity_smooth(repetition_no).UUZ2 = uuz2; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_basic_smooth(repetition_no).ZZU2 = zzu2; %%%
                        smooth_data(subject_no).damping(damping_no).real_time_robot_smooth(repetition_no).RTR2 = rtr2; %%%
                    elseif i == 3
                        rrt3 = hand_trajectory_reduced; %%%
                        trr3 = hand_speed_reduced; %%%
                        uuz3 = hand_velocity_reduced; %%%
                        zzu3 = hand_speed_basic_reduced; %%%
                        rtr3 = real_time_robot_reduced; %%%
                        smooth_data(subject_no).damping(damping_no).hand_trajectory_smooth(repetition_no).RRT3 = rrt3; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_smooth(repetition_no).TRR3 = trr3; %%%
                        smooth_data(subject_no).damping(damping_no).hand_velocity_smooth(repetition_no).UUZ3 = uuz3; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_basic_smooth(repetition_no).ZZU3 = zzu3; %%%
                        smooth_data(subject_no).damping(damping_no).real_time_robot_smooth(repetition_no).RTR3 = rtr3; %%%
                    elseif i == 4
                        rrt4 = hand_trajectory_reduced; %%%
                        trr4 = hand_speed_reduced; %%%
                        uuz4 = hand_velocity_reduced; %%%
                        zzu4 = hand_speed_basic_reduced; %%%
                        rtr4 = real_time_robot_reduced; %%%
                        smooth_data(subject_no).damping(damping_no).hand_trajectory_smooth(repetition_no).RRT4 = rrt4; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_smooth(repetition_no).TRR4 = trr4; %%%
                        smooth_data(subject_no).damping(damping_no).hand_velocity_smooth(repetition_no).UUZ4 = uuz4; %%%
                        smooth_data(subject_no).damping(damping_no).hand_speed_basic_smooth(repetition_no).ZZU4 = zzu4; %%%
                        smooth_data(subject_no).damping(damping_no).real_time_robot_smooth(repetition_no).RTR4 = rtr4; %%%
                    end
                    
                end
                          
                               
                hand_path_reduced = interparc(no_samples, hand_trajectory_reduced(:,1), hand_trajectory_reduced(:,2), hand_trajectory_reduced(:,3), 'linear');
                hand_trajectory_reduced_original = [hand_trajectory_reduced(:,1),  hand_trajectory_reduced(:,2),  hand_trajectory_reduced(:,3)];
                
                [hand_speed_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, hand_speed_reduced);
                [force_left_hand_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, force_left_hand_reduced);
                [force_right_hand_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, force_right_hand_reduced);
                [common_force_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, common_force_reduced);
                [angle_handle_1_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, angle_handle_1_reduced);
                [angle_handle_2_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, angle_handle_2_reduced);
                [position_x_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, position_x_reduced);
                [position_y_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, position_y_reduced);
                [position_z_path_reduced,sequence] = path_profile2(hand_trajectory_reduced_original, hand_path_reduced, position_z_reduced);
                
                M = [M; hand_speed_path_reduced];
                N = [N; force_left_hand_path_reduced];
                O = [O; force_right_hand_path_reduced];
                P = [P; common_force_path_reduced];
                R = [R; angle_handle_1_path_reduced];
                S = [S; angle_handle_2_path_reduced];
                T = [T; position_x_path_reduced];
                U = [U; position_y_path_reduced];
                V = [V; position_z_path_reduced];
                
            end
            
            haptic_data(subject_no).damping(damping_no).hand_speed_path(repetition_no).M = M;
            haptic_data(subject_no).damping(damping_no).force_left_hand_path(repetition_no).N = N;
            haptic_data(subject_no).damping(damping_no).force_right_hand_path(repetition_no).O = O;
            haptic_data(subject_no).damping(damping_no).common_force_path(repetition_no).P = P;
            haptic_data(subject_no).damping(damping_no).angle_handle_1_path(repetition_no).R = R;
            haptic_data(subject_no).damping(damping_no).angle_handle_2_path(repetition_no).S = S;
            haptic_data(subject_no).damping(damping_no).position_x_path(repetition_no).T = T;
            haptic_data(subject_no).damping(damping_no).position_y_path(repetition_no).U = U;
            haptic_data(subject_no).damping(damping_no).position_z_path(repetition_no).V = V;
            
        end        
        
        %% SAVE DATA
        save(['haptic_data.mat'], 'haptic_data'); %%%
        %% Save data
        save(['smooth_data.mat'], 'smooth_data'); %%%
        
    end
end