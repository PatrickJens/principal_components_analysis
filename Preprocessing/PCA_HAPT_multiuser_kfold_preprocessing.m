
    

    %%%%% VAriance based data removal
    %%% added to custom preprocessing raw_data = fopen('gz.txt');
    % ADJUST window size
    %%P: Cutting stuff off from the sides
    %%window size is 100, when vaeriance gets 
    for i = 1:length(raw_data)/100;
        v1(i) = var(raw_data((i-1)*100+1:i*100));
    end
    plot(v1)
    
    %ADJUST threshold on variance on windowing, dont worry about if not
    %windowing

    v1_dec = v1>0.005;
    
    
    v2_dec = zeros(length(v1_dec),1) ;
    for  i = 2:length(v1_dec)-1
        if(v1_dec(i) == 1)
            if((v1_dec(i-1) == 1)||(v1_dec(i+1) == 1))
                v2_dec(i) = 1;
            end
        end
    end
    
    
    for i = 1:length(v2_dec)
        variance_dec(100*(i-1)+1:100*i,1) = v2_dec(i);
    end
    
    
    
    raw_data = raw_data(1:length(variance_dec)).*variance_dec;
    raw_data_orig = raw_data;
    
    
    %%%%%%%%%%%%%%%%%
    
    avg_data_val = sum(raw_data)/sum(variance_dec);
    
    % for i = 1:length(raw_data)
    %     if((S1Data{i,12} == 1)||(S1Data{i,12} == 2))
    %         raw_data(i) = 0;
    %     end
    % end
    %%remove DC offset if exists
    for i = 1:length(raw_data)
        if(raw_data(i)~=0)
            raw_data(i) = raw_data(i) - avg_data_val;
        end
    end
    
        %%%%%%%%%%%%%%
        % START HERE %
        %%%%%%%%%%%%%%
        
        % ADJUST this threshold to identify that what should be the
        % smallest magnitude of a peak. 
        %smallest magnitude a peak can have, add condition l
                                    %if less make zero
    
    raw_data_peaks = raw_data;
    for i = 1:length(raw_data_peaks)
        %Peak height
        if(raw_data_peaks(i)<0.15)
            raw_data_peaks(i) = 0;
        end
    end
    
    [val,pos] = findpeaks(raw_data_peaks); %local maxima, position and value of peaks
    
    j= 0;
    k=0;
    
    k =1;
    temp_pos(k) = pos(1);
    temp_val(k) = val(1);
    for i = 2:length(val)
        
        % ADJUST threshold on how close 2 peaks can  be
        if (pos(i)-pos(i-1))<20
            k= k+1;
            temp_pos(k) = pos(i);
            temp_val(k) = val(i);
            
        else
            j = j+1;
            [mv,mp] = max(temp_val);
            pos2(j) = temp_pos(mp);
            val2(j) = temp_val(mp);
            clear temp_pos temp_val
            k =1;
            temp_pos(k) = pos(i);
            temp_val(k) = val(i);
        end
    end
    
    
            plot(raw_data_orig)
            hold on
            stem(pos2,ones(size(pos2)))
            hold off
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%
    n_cntr = 0;
    ind_cntr = zeros(1,3);
    gt_ind = zeros(3,length(pos2));
    gt_pos_overall = [];
    for i = 1:length(pos2)
        for activity = 1:3
            if (ground_truth(experiment_num,pos2(i)) == activity)
                n_cntr = n_cntr+1;
                ind_cntr(activity) = ind_cntr(activity)+1;
                gt_pos_overall(n_cntr) = pos2(i);
                gt_ind(activity,ind_cntr(activity)) = n_cntr;
            end
        end
    end
    
    for i = 1:length(gt_pos_overall)
        data(i,: ) = [raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,1); raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,2); raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,3)];
    end
    if (length(gt_pos_overall) > 1)
    num_epochs(experiment_num) = length(gt_pos_overall);
    complete_data = [complete_data; data];
    complete_gt = [complete_gt ground_truth(experiment_num,gt_pos_overall)];
    user_set = ceil(experiment_cntr/60);
    complete_user = [complete_user user_set*ones(1,length(gt_pos_overall))];
    end
end


