clc 
close all
clear all
load('haptic_data.mat');

levo_desno = [1,4,5,6,9,14]; % gibi levo desno
gor_dol = [2,8,10,11,13,15]; % gibi gor dol
odsek = 200;
no_subjects = 16;

elastika = [1,2,3,4,5]; % zaporedna stevilka meritve, ki predstavlja osebo z elastiko
zdravi = [6,7,8,9,10,11,12]; % zaporedna stevilka meritve, ki predstavlja zdravo (vsaj telesno) osebo
bolni = [13,14,15,16]; % zaporedna stevilka meritve, ki predstavlja bolno osebo

%% levo - desno
for i = 1:length(levo_desno) % za vsako osebo pogledamo le gibe levo-desno
    gib = levo_desno(i);
    for no_itr = 1:2
        % elastika
        for n_el = 1:length(elastika)
            
            oseba_e = elastika(n_el);

            sile_leva = haptic_data(oseba_e).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_e).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_elastika(2*(n_el-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_elastika(2*(n_el-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_elastika = leve_sile_elastika + desne_sile_elastika;
           
            
         % zdravi 
         for n_zd = 1:length(zdravi)
            
            oseba_z = zdravi(n_zd);
            sile_leva = haptic_data(oseba_z).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_z).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_zdravi(2*(n_zd-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_zdravi(2*(n_zd-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_zdravi = leve_sile_zdravi + desne_sile_zdravi;
         end
         
         % bolni
            for n_b = 1:length(bolni)
            oseba_b = bolni(n_b);
            sile_leva = haptic_data(oseba_b).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_b).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_bolni(2*(n_b-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_bolni(2*(n_b-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_bolni = leve_sile_bolni + desne_sile_bolni;
 
         end

        end
    end
end


razmerje_elastika = desne_sile_elastika./vsota_elastika;            
razmerje_zdravi = leve_sile_zdravi./vsota_zdravi;
razmerje_zdravi(7:8,:) = desne_sile_zdravi(7:8,:)./vsota_zdravi(7:8,:);
razmerje_bolni = desne_sile_bolni./vsota_bolni;    
razmerje_bolni(5:8,:) = leve_sile_bolni(5:8,:)./vsota_bolni(5:8,:);

X = NaN(14,6,3);
X(1:10,:,1) = razmerje_elastika;
X(:,:,2) = razmerje_zdravi;
X(1:8,:,3) = razmerje_bolni;
Y = permute(X,[2,3,1]);
%   nx x ny x ndata array where nx indicates the number of
%   x-clusters, ny the number of boxes per cluster, and
%   ndata the number of points per boxplot.

figure()
%set(gcf, 'Position', get(0, 'Screensize'));
h = boxplot2(Y);
set(h.box(1,:),'color','r', 'linewidth',1.5);
set(h.box(2,:),'color','g', 'linewidth',1.5);
set(h.box(3,:),'color','b', 'linewidth',1.5);
set(gca,'xticklabels',{'',1,4,5,6,9,14,''})
xlabel('Številka giba')
ylabel('sila obolele (nedominantne) roke / vsota sil obeh rok')
legend('elastika','zdravi','bolni')
title('Razmerje nedominantna(obolela) / vstota obeh - levo/desno')

% figure()
% hold on
% for j = 1:6
%     subplot(2,3,j)
%     boxplot([X(:,j,1),X(:,j,2),X(:,j,3)],[1,2,3])
%     
% end

%% gor - dol
for i = 1:length(gor_dol) % za vsako osebo pogledamo le gibe levo-desno
    gib = gor_dol(i);
    for no_itr = 1:2
        % elastika
        for n_el = 1:length(elastika)
            
            oseba_e = elastika(n_el);

            sile_leva = haptic_data(oseba_e).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_e).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_elastika(2*(n_el-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_elastika(2*(n_el-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_elastika = leve_sile_elastika + desne_sile_elastika;
           
            
         % zdravi 
         for n_zd = 1:length(zdravi)
            
            oseba_z = zdravi(n_zd);
            sile_leva = haptic_data(oseba_z).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_z).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_zdravi(2*(n_zd-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_zdravi(2*(n_zd-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_zdravi = leve_sile_zdravi + desne_sile_zdravi;
         end
         
         % bolni
            for n_b = 1:length(bolni)
            oseba_b = bolni(n_b);
            sile_leva = haptic_data(oseba_b).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_b).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_bolni(2*(n_b-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_bolni(2*(n_b-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_bolni = leve_sile_bolni + desne_sile_bolni;
 
         end

        end
    end
end


razmerje_elastika = desne_sile_elastika./vsota_elastika;            
razmerje_zdravi = leve_sile_zdravi./vsota_zdravi;
razmerje_zdravi(7:8,:) = desne_sile_zdravi(7:8,:)./vsota_zdravi(7:8,:);
razmerje_bolni = desne_sile_bolni./vsota_bolni;    
razmerje_bolni(5:8,:) = leve_sile_bolni(5:8,:)./vsota_bolni(5:8,:);

X = NaN(14,6,3);
X(1:10,:,1) = razmerje_elastika;
X(:,:,2) = razmerje_zdravi;
X(1:8,:,3) = razmerje_bolni;
Y = permute(X,[2,3,1]);
%   nx x ny x ndata array where nx indicates the number of
%   x-clusters, ny the number of boxes per cluster, and
%   ndata the number of points per boxplot.

figure()
%set(gcf, 'Position', get(0, 'Screensize'));
h = boxplot2(Y);
set(h.box(1,:),'color','r', 'linewidth',1.5);
set(h.box(2,:),'color','g', 'linewidth',1.5);
set(h.box(3,:),'color','b', 'linewidth',1.5);
set(gca,'xticklabels',{'',2,8,10,11,13,15,''})
xlabel('Številka giba')
ylabel('sila obolele (nedominantne) roke / vsota sil obeh rok')
legend('elastika','zdravi','bolni')
title('Razmerje nedominantna(obolela) / vstota obeh - gor/dol')
