clc 
close all
clear all
load('haptic_data.mat');

levo_desno = [1,4,5,6,9,14]; % gibi levo desno
gor_dol = [2,8,10,11,13,15]; % gibi gor dol
odsek = 200;
no_subjects = 29;

elastika = [1,2,3,4,5]; % zaporedna stevilka meritve, ki predstavlja osebo z elastiko
zdravi_mi = [6,7,8,9]; % zaporedna stevilka meritve, ki predstavlja zdravo (vsaj telesno) osebo
zdravi = [10,11,12,13,14,15,16,17,18,19];
bolni = [20,21,22,23,24,25,26,27,28,29]; % zaporedna stevilka meritve, ki predstavlja bolno osebo

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
           
        end   
        % zdravi mi
        for n_zdm = 1:length(zdravi_mi)
            
            oseba_zm = zdravi(n_zdm);
            sile_leva = haptic_data(oseba_zm).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_zm).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_zdravi_mi(2*(n_zdm-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_zdravi_mi(2*(n_zdm-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_zdravi_mi = leve_sile_zdravi_mi + desne_sile_zdravi_mi;
        end
         
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


razmerje_elastika = desne_sile_elastika./vsota_elastika;  % desna roka "paretièna"        
razmerje_zdravi_mi = leve_sile_zdravi_mi./vsota_zdravi_mi; % leva roka nedominantna
razmerje_zdravi_mi(7:8,:) = desne_sile_zdravi_mi(7:8,:)./vsota_zdravi_mi(7:8,:); % desna roka nedominantna
razmerje_zdravi = leve_sile_zdravi./vsota_zdravi; % zdravi - vsi desnièarji?
razmerje_bolni = desne_sile_bolni./vsota_bolni;    
razmerje_bolni(14:20,:) = leve_sile_bolni(14:20,:)./vsota_bolni(14:20,:); % zadnji trije imajo paretièno levo roko

X = NaN(20,6,4);
X(1:10,:,1) = razmerje_elastika;
X(1:8,:,2) = razmerje_zdravi_mi;
X(:,:,3) = razmerje_zdravi;
X(:,:,4) = razmerje_bolni;
Y = permute(X,[2,3,1]);
%   nx x ny x ndata array where nx indicates the number of
%   x-clusters, ny the number of boxes per cluster, and
%   ndata the number of points per boxplot.

figure()
subplot('Position',[0.05 0.05 0.9 0.6]);
set(gcf, 'Position', get(0, 'Screensize'));
h = boxplot2(Y);
set(h.box(1,:),'color','r', 'linewidth',1.5);
set(h.box(2,:),'color','g', 'linewidth',1.5);
set(h.box(3,:),'color','b', 'linewidth',1.5);
set(h.box(4,:),'color','m', 'linewidth',1.5);
set(gca,'xticklabels',{'',1,4,5,6,9,14,''})


xlabel('Številka giba')
ylabel('sila obolele (nedominantne) roke / vsota sil obeh rok')
legend('elastika','zdravi - študenti','zdravi','bolni')
title('Razmerje nedominantna(obolela) / vstota obeh - levo/desno')

for ld = 1:length(levo_desno) % = [1,4,5,6,9,14];
    width = 1 / (length(levo_desno)+1);
    height = 0.18;
    subplot('Position',[0.1+ width*(ld-1) 0.75, width-0.05, height]);
    [p1,dp] = plot_seg(levo_desno(ld));
    quiver(p1(1),p1(2),dp(1),dp(2),0);
    axis([-0.2 0.2 -0.2 0.2]);
    title(['Gib ' num2str(levo_desno(ld)),' v z(y) ravnini']);
    xlabel('y coordinate');
    ylabel('z coordinate');
end





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
        end 
          % zdravi mi
        for n_zdm = 1:length(zdravi_mi)
            
            oseba_zm = zdravi(n_zdm);
            sile_leva = haptic_data(oseba_zm).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
            sile_desna = haptic_data(oseba_zm).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

            sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
            sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

            leve_sile_zdravi_mi(2*(n_zdm-1)+no_itr,i) = mean(sile_leva_gib);
            desne_sile_zdravi_mi(2*(n_zdm-1)+no_itr,i) = mean(sile_desna_gib);
            
            vsota_zdravi_mi = leve_sile_zdravi_mi + desne_sile_zdravi_mi;
        end   
  
        % zdravi 
        for n_zd = 1:length(zdravi)

        oseba_z = zdravi(n_zd);
        sile_leva = haptic_data(oseba_z).damping(3).force_left_hand_path(no_itr).N; % vse sile leve roke neke osebe, doloèene iteracije
        sile_desna = haptic_data(oseba_z).damping(3).force_right_hand_path(no_itr).O; % vse sile desne roke neke osebe, doloèene iteracije

        sile_leva_gib = sile_leva(odsek*(gib-1)+1:odsek*gib);
        sile_desna_gib = sile_desna(odsek*(gib-1)+1:odsek*gib);

        leve_sile_zdravi_mi(2*(n_zd-1)+no_itr,i) = mean(sile_leva_gib);
        desne_sile_zdravi_mi(2*(n_zd-1)+no_itr,i) = mean(sile_desna_gib);

        vsota_zdravi_mi = leve_sile_zdravi_mi + desne_sile_zdravi_mi;
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


razmerje_elastika = desne_sile_elastika./vsota_elastika;            
razmerje_zdravi = leve_sile_zdravi_mi./vsota_zdravi_mi;
razmerje_zdravi(7:8,:) = desne_sile_zdravi_mi(7:8,:)./vsota_zdravi_mi(7:8,:);
razmerje_bolni = desne_sile_bolni./vsota_bolni;    
razmerje_bolni(5:8,:) = leve_sile_bolni(5:8,:)./vsota_bolni(5:8,:);

X = NaN(20,6,4);
X(1:10,:,1) = razmerje_elastika;
X(1:8,:,2) = razmerje_zdravi_mi;
X(:,:,3) = razmerje_zdravi;
X(:,:,4) = razmerje_bolni;
Y = permute(X,[2,3,1]);
%   nx x ny x ndata array where nx indicates the number of
%   x-clusters, ny the number of boxes per cluster, and
%   ndata the number of points per boxplot.

figure()
subplot('Position',[0.05 0.05 0.9 0.6]);
set(gcf, 'Position', get(0, 'Screensize'));
h = boxplot2(Y);
set(h.box(1,:),'color','r', 'linewidth',1.5);
set(h.box(2,:),'color','g', 'linewidth',1.5);
set(h.box(3,:),'color','b', 'linewidth',1.5);
set(h.box(4,:),'color','m', 'linewidth',1.5);
set(gca,'xticklabels',{'',2,8,10,11,13,15,''})
xlabel('Številka giba')
ylabel('sila obolele (nedominantne) roke / vsota sil obeh rok')
legend('elastika','zdravi - študenti','zdravi','bolni')
title('Razmerje nedominantna(obolela) / vstota obeh - gor/dol')

for gd = 1:length(gor_dol) % = [1,4,5,6,9,14];
    width = 1 / (length(gor_dol)+1);
    height = 0.18;
    subplot('Position',[0.1+ width*(gd-1) 0.75, width-0.05, height]);
    [p1,dp] = plot_seg(gor_dol(gd));
    quiver(p1(1),p1(2),dp(1),dp(2),0);
    axis([-0.2 0.2 -0.2 0.2]);
    title(['Gib ' num2str(gor_dol(gd)),' v z(y) ravnini']);
    xlabel('y coordinate');
    ylabel('z coordinate');
end


