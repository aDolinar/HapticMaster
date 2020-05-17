
%% statisticna analiza
%minimalna, maksimalna,povprecna in standardna deviacija
clc; close all;
load haptic_data.mat


no_subjects = 20;
num_of_targets = 16; % stevilo tarc
sub_num = 20;
ime = fieldnames(haptic_data(sub_num).damping(3)); %imena vseh meritev v haptic data


for i = 3:length(ime) %zacnemo analizo sele pri tretji
    for sub_num = 1:no_subjects 
        for seg_num = 1:num_of_targets
            for itr = 1:2 % vsak ima dve tabeli po 3200 vzorcev
                
                tmp = getfield(haptic_data(sub_num+9).damping(3),ime{i}); %izberem meritev iz haptic data, z imenom na indeksu i v imenih
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
save('tinadata.mat','povprecna_vrednost','minimalna_vrednost','maksimalna_vrednost','standardna_deviacija','varianca','meritev');
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

for ii = 1
    
    zdravi = povprecna_vrednost((1:10),:,1,ii);
    prizadeti_Dud = povprecna_vrednost((14:20),:,1,ii);
    prizadeti_Lud = povprecna_vrednost((11:13),:,1,ii);
    
    %za vsako skupino posebaj
%     [p_z,tbl_z,stats_z] = anova1(zdravi');
%     [p_D,tbl_D,stats_D] = anova1(prizadeti_Dud');
%     [p_L,tbl_L,stats_L] = anova1(prizadeti_Lud');
    
    %povprecim zdrave
    %izracuni vsakega bolnega z zdravim
    zdravi_pov = povprecna_vrednost((1:10),:,1,ii);
    prvo_povprecje = mean(zdravi_pov);
    matrika1 =  [prvo_povprecje; prizadeti_Dud];
    matrika2 =  [prvo_povprecje; prizadeti_Lud];
    
    [p_1,tbl_1,stats_1] = anova1(matrika1');
    [p_2,tbl_2,stats_2] = anova1(matrika2');
end



%% zdravi in povpreceni izris bolnih

for jj = 14:15
    figure(1);
    for ii = 1:3
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);

            if jj == 14
                subplot(2,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}]);
                title('Oseba 14');
            else
                subplot(2,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 15');
            end
     end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(2);
    for ii = 4:6
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 14            
                subplot(2,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 14');
            else
                subplot(2,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 15');
            end
           
    end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(3);
    for ii = 7:9
           %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 13               
                subplot(2,3,ii-6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 14');
            else
                subplot(2,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 15');
            end
            
    end 
    legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
     
end

for jj = 16:17
    figure(4);
    for ii = 1:3
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);

            if jj == 16
                subplot(2,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}]);
                title('Oseba 16');
            else
                subplot(2,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 17');
            end
     end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(5);
    for ii = 4:6
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 16            
                subplot(2,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 16');
            else
                subplot(2,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 17');
            end
           
    end 
    legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(6);
    for ii = 7:9
           %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 16               
                subplot(2,3,ii-6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 16');
            else
                subplot(2,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 17');
            end
            
    end 
    legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
     
end

for jj = 18:20
    figure(7);
    
    for ii = 1:3
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);

            if jj == 18
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 18');
                
            elseif jj == 19
                subplot(3,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 19');
           
            else
                subplot(3,3,ii+6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 20');
            end
            
    end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(8);
    for ii = 4:6
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 18           
                subplot(3,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
               ylabel([ime{ii+2,1}])
                title('Oseba 18');
                
            elseif jj == 19           
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
               ylabel([ime{ii+2,1}])
                title('Oseba 19');
                
            else
                subplot(3,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 20');
            end
    end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(9);
    for ii = 7:9
           %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 18              
                subplot(3,3,ii-6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 18');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
                
            elseif jj == 19             
                subplot(3,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 19');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
            
            else
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 20');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
                
            end
           
    end 
    legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
end

%%
for jj = 11:13
    figure(10);
    
    for ii = 1:3
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);

            if jj == 11
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 11');
                
            elseif jj == 12
                subplot(3,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 12');
            else
                subplot(3,3,ii+6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 13');
            end
            
    end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(11);
    for ii = 4:6
            %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 11           
                subplot(3,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
               ylabel([ime{ii+2,1}])
                title('Oseba 11');
                
            elseif jj == 12           
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
               ylabel([ime{ii+2,1}])
                title('Oseba 12');
                
            else
                subplot(3,3,ii+3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 13');
            end
    end 
     legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
    
    figure(12);
    for ii = 7:9
           %povprecje zdravih in njihova std za izris
            pov = povprecna_vrednost((1:10),:,1,ii);
            povprecje = mean(pov);
            stdd = std(pov);
            
            if jj == 11              
                subplot(3,3,ii-6)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 11');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
                
            elseif jj == 12             
                subplot(3,3,ii-3)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 12');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
            else
                subplot(3,3,ii)
                plot(povprecje);
                hold on
                plot(povprecje + stdd, '--');
                hold on
                plot(povprecje - stdd, '--');
                hold on
        %       lahko tudi for zanka se za vse bolnike, a prevec grafov naenkrat
                plot(povprecna_vrednost(jj,:,1,ii), '-k');
                xlabel('tarca');
                ylabel([ime{ii+2,1}])
                title('Oseba 13');
                %legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
                
            end
           
    end 
    legend('povprecje zdravih oseb','+ std zdravih oseb','- std zdravih oseb','nepovpreceni podatki prizadetih oseb')
end

%% ttest

% x in y predstavljata nase podatke, ki jih primerjamo
% default ttest --> 5%
% Test the null hypothesis that the pairwise difference between data vectors x and y has a mean equal to zero at the 1% significance level.

% Hypothesis test result, returned as 1 or 0.
% - If h = 1, this indicates the rejection of the null hypothesis at the Alpha significance level.
% - If h = 0, this indicates a failure to reject the null hypothesis at the Alpha significance level.

% p-value of the test, returned as a scalar value in the range [0,1]. p is the probability of observing a test statistic as extreme as, or more extreme than, the observed value under the null hypothesis. Small values of p cast doubt on the validity of the null hypothesis.
% Confidence interval for the true population mean, returned as a two-element vector containing the lower and upper boundaries of the 100 ? (1 ? Alpha)% confidence interval.

% Test statistics, returned as a structure containing the following:
% - tstat ? Value of the test statistic.
% - df ? Degrees of freedom of the test.
% - sd ? Estimated population standard deviation. For a paired t-test, sd is the standard deviation of x ? y.

for jj = 11:13
    for  ii = 1:9
        
         povv = povprecna_vrednost((1:10),:,1,ii);
         x = mean(povv);
                  
         % za levi ud jj+2 ker 15 in 16 meritev
         y_L = povprecna_vrednost((jj+2),:,1,ii);
         [h_L(jj-10,ii),p_L(jj-10,ii)] = ttest(x,y_L, 'Alpha', 0.05);
%        [h_L(jj-12,ii),p_L(jj-12,ii),ci_L((jj-12:jj-11),ii),stats_L(jj-12,ii)] = ttest(x,y); 
        
    end
end

for jj = 14:20
    for  ii = 1:9
        
         povv = povprecna_vrednost((1:10),:,1,ii);
         x = mean(povv);
         % x = prvo_povprecje;
         y_D = povprecna_vrednost((jj),:,1,ii);
         [h_D(jj-13,ii),p_D(jj-13,ii)] = ttest(x,y_D, 'Alpha', 0.05);
%        [h_D(jj-12,ii),p_D(jj-12,ii),ci_D(jj-12,ii),stats_D(jj-12,ii)] = ttest(x,y);
        
                
    end
end
%% struktura 

for ii = 1:20
    Meritve(ii).oseba(1).signal = haptic_data(ii).damping(3).hand_speed_path(1).M;
    Meritve(ii).oseba(2).signal = haptic_data(ii).damping(3).force_left_hand_path(1).N;
    Meritve(ii).oseba(3).signal = haptic_data(ii).damping(3).force_right_hand_path(1).O;
    Meritve(ii).oseba(4).signal = haptic_data(ii).damping(3).common_force_path(1).P;
    Meritve(ii).oseba(5).signal = haptic_data(ii).damping(3).angle_handle_1_path(1).R;
    Meritve(ii).oseba(6).signal = haptic_data(ii).damping(3).angle_handle_2_path(1).S;
    Meritve(ii).oseba(7).signal = haptic_data(ii).damping(3).position_x_path(1).T;
    Meritve(ii).oseba(8).signal = haptic_data(ii).damping(3).position_y_path(1).U;
    Meritve(ii).oseba(9).signal = haptic_data(ii).damping(3).position_z_path(1).V;
end


%% ANALIZA STACIONARNOSTI SIGNALA


%Izris signalov:
n = 3200;
%izris vseh signalov
for ii=1:6
    figure(ii)
    plot(Meritve(ii).oseba(1).signal);
    xlabel('data');
    ylabel([ime{ii+2,1}]);
    grid on;
end


for ii = 1:6
    
figure(ii);
title(['Surovi podatki, oseba =', int2str(11)]);
end


%% KRIZNA KORELACIJA - primerjava dveh signalov
% primerjava po parametrih - zdravi z vsemi bolnimi

% krizna korelacija izracunana na zdravih osebah in primerjavi njunih podatkov 
[r11, tau11] = xcorr(Meritve(1).oseba(1).signal);
% figure('Name','Krizna korelacija, oseba 11');
% plot(tau11, r11)

[r12, tau12] = xcorr(Meritve(2).oseba(1).signal);
% figure('Name','Krizna korelacija, oseba 12')
% plot(tau12, r12)

[r11_12, tau11_12] = xcorr(Meritve(1).oseba(1).signal, Meritve(2).oseba(1).signal);
% figure('Name','Krizna korelacija med osebama 11 in 12')
% plot(tau11_12, r11_12)

%figure('Name', 'primerjava grafov');
figure(1)
title('primerjava grafov');
plot(tau11, r11)
hold on
plot(tau12, r12)
hold on
plot(tau11_12, r11_12)
hold off
legend('xcorr 11','xcorr 12','xcorr 11-12');
xlabel('tau')
ylabel('r')

%%

for jj = 1:9
    for ii = 11:13
    
       figure(jj)
       subplot(2,2,ii-10)
       [r111_12(ii-10,:), tau111_12(ii-10,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(2).oseba(jj).signal);
       plot(tau111_12(ii-10,:), r111_12(ii-10,:))
       hold on
       [r(ii-10,:), tau(ii-10,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(ii).oseba(jj).signal);

       subplot(2,2,ii-10)
       plot(tau(ii-10,:),r(ii-10,:))
       title(['oseba', num2str(ii)])

       %xlabel('data');
       ylabel([ime{jj+2,1}]);
       xlabel('sample');
   
    end
end

legend('kri?na korelacija zdravi - prizadeti ud','krizna korelacija oseb zdravih 11-12');
%%
for jj = 1:9
    for ii = 14:16
    
       figure(jj)
       subplot(2,2,ii-13)
       [r112_12(ii-13,:), tau112_12(ii-13,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(2).oseba(jj).signal);
       plot(tau112_12(ii-13,:), r112_12(ii-13,:))
       hold on
       [r(ii-10,:), tau(ii-10,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(ii).oseba(jj).signal);

       subplot(2,2,ii-13)
       plot(tau(ii-13,:),r(ii-13,:))
       title(['oseba', num2str(ii)])

       %xlabel('data');
       ylabel([ime{jj+2,1}]);
       xlabel('sample');
   
    end
end

%%
for jj = 1:9
    for ii = 17:20
    
       figure(jj)
       subplot(2,2,ii-16)
       [r113_12(ii-16,:), tau113_12(ii-16,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(2).oseba(jj).signal);
       plot(tau113_12(ii-16,:), r113_12(ii-16,:))
       hold on
       [r(ii-16,:), tau(ii-16,:)] = xcorr(Meritve(1).oseba(jj).signal, Meritve(ii).oseba(jj).signal);

       subplot(2,2,ii-16)
       plot(tau(ii-16,:),r(ii-16,:))
       title(['oseba', num2str(ii)])

       %xlabel('data');
       ylabel([ime{jj+2,1}]);
       xlabel('sample');
   
    end
end

legend('kri?na korelacija zdravi - prizadeti ud','krizna korelacija oseb zdravih 11-12');
%%
% [R,P,RL,RU] = corrcoef(___) includes matrices containing lower and upper bounds for a 95% confidence interval for each coefficient. This syntax is invalid if R contains complex elements.

for ii = 1:9
    tmp = corrcoef(Meritve(1).oseba(ii).signal, Meritve(2).oseba(ii).signal);
    RR(ii,1) = tmp(1,2);
end

for ii = 1:9
    for jj = 3:6
        tmp = corrcoef(Meritve(1).oseba(ii).signal, Meritve(jj).oseba(ii).signal)
        RR_med(ii,jj-2) = tmp(1,2)
    end 
end

