
%% statisticna analiza
%minimalna, maksimalna,povprecna in standardna deviacija
clc; close all;

num_of_targets = 16; % stevilo tarc
sub_num = 16;
ime = fieldnames(haptic_data(sub_num).damping(3)); %imena vseh meritev v haptic data
no_subjects= 16;

for i = 3:length(ime) %zacnemo analizo sele pri tretji
    for sub_num = 1:no_subjects 
        for seg_num = 1:num_of_targets
            for itr = 1:2 % vsak ima dve tabeli po 3200 vzorcev
                
                tmp = getfield(haptic_data(sub_num).damping(3),ime{i}); %izberem meritev iz haptic data, z imenom na indeksu i v imenih
                tmp1 = fieldnames(tmp); % 'ime' nad iteracijami (ime nivoja pri iteracijah)
                vrednosti_meritve = getfield(tmp(itr),tmp1{1}); % iz izbranega nivoja stukture pobere vse meritve za iteracijo z indeksom itr
                celotna_dolzina = length(vrednosti_meritve); %3200 
                odsek = celotna_dolzina/num_of_targets; %200 ----> ker so tocke interpolirane to lahko
                
                % (oseba,tarca,iteracija,meritev(i-2)--npr. hand_speed_path)
                vrednosti_meritve = vrednosti_meritve(odsek*(seg_num-1) + 1:odsek*seg_num); % izlocimo meritev posamezne osebe, tarce, iteraciije
                povprecna_vrednost(sub_num,seg_num,itr,i-2) = mean(vrednosti_meritve); % izracun povprecne meritve 4D matrika
                maksimalna_vrednost(sub_num,seg_num,itr,i-2) = max(vrednosti_meritve); % izracun maksimalne meritve 4D matrika
                minimalna_vrednost(sub_num,seg_num,itr, i-2) = min(vrednosti_meritve); % izracun minimalne meritve 4D matrika
                standardna_deviacija(sub_num,seg_num,itr, i-2) = std(vrednosti_meritve); % izracun standardne deviacije 4D matrika
                
                %struktura - izbira: meritev/oseba/iteracija/statistika(analiza) po tarcah
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).povprecna_vrednost = mean(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).maksimalna_vrednost = max(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).minimalna_vrednost = min(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).standardna_deviacija = std(vrednosti_meritve);
                
             end
         end    
    end
end
