function [resempling_path,sequence] = path_profile(trajectory, path, resempling_trajectory)

% resempling_trajectory = hand_speed;
path_index = 1;
no_samples = size(trajectory,1);
no_samples_path = size(path,1);

sequence = zeros(size(trajectory,1),1);

for trajectory_index=1:no_samples
    delta = 0;
    if (trajectory_index+delta>no_samples)
        delta = no_samples - trajectory_index;
    end
    
    delta2 = 25;
    if (path_index+delta2>no_samples_path)
        delta2 = no_samples_path - path_index;
    end           
    [k,d] = dsearchn(path(path_index:path_index+delta2,:),trajectory(trajectory_index:trajectory_index+delta,:));  
    [~, i_d_min] = min(d);
    k = path_index - 1 + k(i_d_min);
          
    if (k>path_index)
        path_index = k;
    end
    
    sequence(trajectory_index) = path_index;
end


diff_sequence = diff(sequence);
kk = 1;
for jj=1:min(length(diff_sequence),length(resempling_trajectory)-1)
    for ii=1:diff_sequence(jj)
%         disp([int2str(ii), ' ', int2str(jj), ' ', int2str(kk)])
%         new_path(kk,:) = trajectory(jj,:) + (ii-1)*(trajectory(jj+1,:)-trajectory(jj,:))/diff_sequence(jj);
        resempling_path(kk,:) = resempling_trajectory(jj,:) + (ii-1)*(resempling_trajectory(jj+1,:)-resempling_trajectory(jj,:))/diff_sequence(jj);
        kk = kk + 1;
    end
end

% new_path(end+1,:) = new_path(end,:);
resempling_path(end+1,:) = resempling_path(end,:);

% close all
% figure
% plot(new_path)
% hold on
% plot(path,'--')

% figure
% plot(resempling_path)