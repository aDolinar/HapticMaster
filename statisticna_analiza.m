% izracun povprecne, maksimalne, minimalne in standardne deviacije hitrosti
% za vsako osebo, vsak segment in vsako iteracijo
clc;
close all;

num_of_targets = 16; % stevilo tarc
for sub_num = 1:no_subjects % stevilo oseb
    for itr = 1:2 % stevilo ponovitev (povsod sem vzela samo 2)
        for seg_num = 1:num_of_targets
            
            % damping = 3 
            hitrosti = haptic_data(sub_num).damping(3).hand_speed_path(itr).M; %preberemo vrednosti iz haptic_data
            cela_dolzina = length(hitrosti); % 3200
            odsek = cela_dolzina/num_of_targets; % 200
            hitrosti = hitrosti(odsek*(seg_num-1)+1:odsek*seg_num); % izlocimo hitrosti posamezne osebe, segmenta in ponovitve
            povprecna(sub_num,seg_num,itr) = mean(hitrosti); % izracun povprecne hitrosti 3D matrika
            maksimalna(sub_num,seg_num,itr) = max(hitrosti); % izracun maksimalne hitrosti 3D matrika
            minimalna(sub_num,seg_num,itr) = min(hitrosti); % izracun minimalne hitrosti 3D matrika
            deviacija(sub_num,seg_num,itr) = std(hitrosti); % izracun std 3D matrika
            
        end    
    end
end

elastika = [1,2,3,4,5]; % zaporedna stevilka meritve, ki predstavlja osebo z elastiko
zdravi = [6,7,8,9,10,11,12]; % zaporedna stevilka meritve, ki predstavlja zdravo (vsaj telesno) osebo
bolni = [13,14,15,16]; % zaporedna stevilka meritve, ki predstavlja bolno osebo


itr = 2;

%% grafi povpreènih,maksimalnih in std hitrosti za zdrave, bolne in elastiko

% for gib = 1:num_of_targets
%         
%         % graf povpreènih hitrosti za posamezen gib za skupine ljudi
%         figure()
%         hold on
%         for st_el = 1:length(bolni)
%             plot(1,povprecna(elastika(st_el),gib,itr),'o');
%             plot(2,povprecna(zdravi(st_el),gib,itr),'x');
%             plot(3,povprecna(bolni(st_el),gib,itr),'*');    
%         end    
%         set(gca,'xtick',1:4,'xticklabels',{'elastika','zdravi','bolni'})
%         title(['Povprecne hitrosti za segment ',num2str(gib),' oseb z elastiko, zdravih in obolelih oseb'])
%         legend('elastika', 'zdravi','bolni')
%         
%         % graf maksimalnih hitrosti za posamezen gib za skupine ljudi 
%         figure()
%         hold on
%         for st_el = 1:length(bolni)
%             plot(1,maksimalna(elastika(st_el),gib,itr),'o');
%             plot(2,maksimalna(zdravi(st_el),gib,itr),'x');
%             plot(3,maksimalna(bolni(st_el),gib,itr),'*');    
%         end    
%         set(gca,'xtick',1:4,'xticklabels',{'elastika','zdravi','bolni'})
%         title(['Maksimalne hitrosti za segment ',num2str(gib), ' oseb z elastiko, zdravih in obolelih oseb'])
%         legend('elastika', 'zdravi','bolni')
%         
%         % graf stadnardnih deviacij hitrosti za posamezen gib za skupine ljudi
%         figure()
%         hold on
%         for st_el = 1:length(bolni)
%             plot(1,deviacija(elastika(st_el),gib,itr),'o');
%             plot(2,deviacija(zdravi(st_el),gib,itr),'x');
%             plot(3,deviacija(bolni(st_el),gib,itr),'*');    
%         end    
%         set(gca,'xtick',1:4,'xticklabels',{'elastika','zdravi','bolni'})
%         title(['Standardne deviacije hitrosti za segment ',num2str(gib), ' oseb z elastiko, zdravih in obolelih oseb'])
%         legend('elastika', 'zdravi','bolni')
%         
% end


%% boxploti - vzamemo eno zdravo in eno bolno osebo in izrišemo boxplote za posamezne segmente poti
sub_num_bolni = round(3*rand() + 13);
sub_num_zdravi = round(3*rand() + 6);
itr = 2; 
for gib_boxplot = 1:num_of_targets
    
    hitrosti_bolni = haptic_data(sub_num_bolni).damping(3).hand_speed_path(itr).M; %preberemo vrednosti bolne osebe iz haptic_data
    cela_dolzina = length(hitrosti_bolni); % 3200
    odsek = cela_dolzina/num_of_targets; % 200
    hitrosti_bolni_gib(:,gib_boxplot) = hitrosti_bolni(odsek*(gib_boxplot-1)+1:odsek*gib_boxplot);  
    
    hitrosti_zdravi = haptic_data(sub_num_zdravi).damping(3).hand_speed_path(itr).M; %preberemo vrednosti bolne osebe iz haptic_data
    cela_dolzina = length(hitrosti_zdravi); % 3200
    odsek = cela_dolzina/num_of_targets; % 200
    hitrosti_zdravi_gib(:,gib_boxplot) = hitrosti_zdravi(odsek*(gib_boxplot-1)+1:odsek*gib_boxplot); 
    
end

figure()
set(gcf, 'Position', get(0, 'Screensize'));
hold on
subplot(2,1,1)
boxplot(hitrosti_zdravi_gib);
title('hitrosti za posamezen segment - zdravi')
subplot(2,1,2)
boxplot(hitrosti_bolni_gib);
title('hitrosti za posamezen segment - bolni')
