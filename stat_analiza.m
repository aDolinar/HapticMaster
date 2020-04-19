
%% statisticna analiza
%minimalna, maksimalna,povprecna in standardna deviacija
clc; close all;

num_of_targets = 16; % stevilo tarc
sub_num = 16;
ime = fieldnames(haptic_data(sub_num).damping(3)); %imena vseh meritev v haptic data


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
                %za statisticno analizo anova (one way)
                varianca(sub_num,seg_num,itr, i-2) = var(vrednosti_meritve);
                
                %struktura - izbira: meritev/oseba/iteracija/statistika(analiza) po tarcah
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).povprecna_vrednost = mean(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).maksimalna_vrednost = max(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).minimalna_vrednost = min(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).standardna_deviacija = std(vrednosti_meritve);
                meritev(i).oseba(sub_num).iteracija(itr).tarca(seg_num).varianca = var(vrednosti_meritve);
                
             end
         end    
    end
end

%% test one way anova

%razdelitev v primerjalne skupine (1.del, le evine meritve)

%izris za vse parametre v haptic data
% 1. hand speed path
% 2. force left hand path
% 3. force right hand path
% 4. common force path path
% 5. angle handle 1. path
% 6. angle handle 2. path
% 7. position x path
% 8. position y path
% 9. position z path

for ii = 1:9
    
    zdravi = povprecna_vrednost((10:12),:,1,ii);
    prizadeti_Dud = povprecna_vrednost((13:14),:,1,ii);
    prizadeti_Lud = povprecna_vrednost((15:16),:,1,ii);
    
    %za vsako skupino posebaj
%     [p_z,tbl_z,stats_z] = anova1(zdravi');
%     [p_D,tbl_D,stats_D] = anova1(prizadeti_Dud');
%     [p_L,tbl_L,stats_L] = anova1(prizadeti_Lud');
    
    %povprecim zdrave
    %izracuni vsakega bolnega z zdravim
    zdravi_pov = povprecna_vrednost((10:12),:,1,ii);
    prvo_povprecje = mean(zdravi_pov);
    matrika1 =  [prvo_povprecje; prizadeti_Dud];
    matrika2 =  [prvo_povprecje; prizadeti_Lud];
    
%     [p_1,tbl_1,stats_1] = anova1(matrika1');
%     [p_2,tbl_2,stats_2] = anova1(matrika2');
    
    

end


%%

%povprecje po tarcah za zdrave po povprecnih vrednostih
%hand speed path

zdravi_pov1 = povprecna_vrednost((10:12),:,1,1);
prvo_povprecje1 = mean(zdravi_pov1);
prva_std1 = std(zdravi_pov1);

% for ii = 13:16
%     for jj = 1:9 
%     test = [prvo_povprecje;povprecna_vrednost(ii,:,1,jj)]
%     [p,tbl,stats] = anova1(test');
%     multcompare(stats);
%     end
% end

%% nepovpreceni podatki
%poskus izrisa povprecne vrednosti + std za enega zdravega
%po vrhu izris se enega bolnika po vseh 9 parametrih

for ii = 1:9
    
    figure()
    plot(povprecna_vrednost(10,:,1,ii));
    hold on
    plot(povprecna_vrednost(10,:,1,ii) + standardna_deviacija(10,:,1,ii),'--');
    hold on
    plot(povprecna_vrednost(10,:,1,ii) - standardna_deviacija(10,:,1,ii),'--');
    hold on
    plot(povprecna_vrednost(13,:,1,ii), '-k');
    %title()

end

%% zdravi in povpreceni izris bolnih

for ii = 1:9
    
    % povprecje zdravih in njihova std za izris
    pov = povprecna_vrednost((10:12),:,1,ii);
    povprecje = mean(pov);
    stdd = std(pov);

    figure()
    plot(povprecje);
    hold on
    plot(povprecje + stdd, '--');
    hold on
    plot(povprecje - stdd, '--');
    hold on
    %lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
    plot(povprecna_vrednost(14,:,1,ii), '-k');
   
    
end

%% ttest

% x in y predstavljata nase podatke, ki jih primerjamo
% default ttest --> 5%
% Test the null hypothesis that the pairwise difference between data vectors x and y has a mean equal to zero at the 1% significance level.

% Hypothesis test result, returned as 1 or 0.
% - If h = 1, this indicates the rejection of the null hypothesis at the Alpha significance level.
% - If h = 0, this indicates a failure to reject the null hypothesis at the Alpha significance level.

% p-value of the test, returned as a scalar value in the range [0,1]. p is the probability of observing a test statistic as extreme as, or more extreme than, the observed value under the null hypothesis. Small values of p cast doubt on the validity of the null hypothesis.
% Confidence interval for the true population mean, returned as a two-element vector containing the lower and upper boundaries of the 100 × (1 – Alpha)% confidence interval.

% Test statistics, returned as a structure containing the following:
% - tstat — Value of the test statistic.
% - df — Degrees of freedom of the test.
% - sd — Estimated population standard deviation. For a paired t-test, sd is the standard deviation of x – y.

for jj = 13:14
    for  ii = 1:9
        
         povv = povprecna_vrednost((10:12),:,1,ii);
         x = mean(povv);
         % x = prvo_povprecje;
         y_D = povprecna_vrednost((jj),:,1,ii);
         [h_D(jj-12,ii),p_D(jj-12,ii)] = ttest(x,y_D, 'Alpha', 0.01);
%        [h_D(jj-12,ii),p_D(jj-12,ii),ci_D(jj-12,ii),stats_D(jj-12,ii)] = ttest(x,y);
         
         % za levi ud jj+2 ker 15 in 16 meritev
         y_L = povprecna_vrednost((jj+2),:,1,ii);
         [h_L(jj-12,ii),p_L(jj-12,ii)] = ttest(x,y_L, 'Alpha', 0.01);
%        [h_L(jj-12,ii),p_L(jj-12,ii),ci_L((jj-12:jj-11),ii),stats_L(jj-12,ii)] = ttest(x,y); 
        
    end
end




