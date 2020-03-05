clear all

experiment_list = [1 :60];

confusion_mat = zeros(3,3,10);

complete_data = [];
complete_gt = [];
complete_user = [];

for experiment_cntr = 1:length(experiment_list)
    experiment_num = experiment_list(experiment_cntr);
    if(experiment_num < 21)
        user_num = ceil(experiment_num/2);
    else
        user_num = floor(experiment_num/2);
    end
    %activity =2;
    
    clearvars -except complete_user experiment_list confusion_mat num_epochs trial_num final_error_individual train_ratio train_list experiment_list experiment_cntr train_ratio_cntr final_error final_error_percent redo_cntr user_num experiment_num err_percent_overall activity error_percent complete_data complete_gt
    %The Walking Data
    
    label_file = fopen('HAPT_Data_Set\RawData\labels.txt');
    label_orig = textscan(label_file,'%f %f %f %f %f');
    
    fclose(label_file);
    
    label = [label_orig{1} label_orig{2} label_orig{3} label_orig{4} label_orig{5}];
    
    
    for i = 1:size(label,1)
        
        ground_truth(label(i,1),label(i,4):label(i,5)) = label(i,3);
    end
    
    
    
   
    file_string = ['HAPT_Data_Set\RawData\acc_exp' num2str(experiment_num,'%.2d') '_user' num2str(user_num,'%.2d') '.txt'];
    
    data_file = fopen(file_string);
    %Read in dimensions to text file
    data_orig = textscan(data_file,'%f %f %f');
    
    fclose(data_file);
    
    
    raw_data_1=data_orig{1:end,3};
    raw_data = raw_data_1(1:min(length(raw_data_1),size(ground_truth,2)));
    raw_data_all_ch(:,1) = data_orig{1:min(length(raw_data_1),size(ground_truth,2)),1};
    raw_data_all_ch(:,2) = data_orig{1:min(length(raw_data_1),size(ground_truth,2)),2};
    raw_data_all_ch(:,3) = data_orig{1:min(length(raw_data_1),size(ground_truth,2)),3};
    %%%%% VAriance based data removal
    for i = 1:length(raw_data)/100;
        v1(i) = var(raw_data((i-1)*100+1:i*100));
    end
    
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
    
    for i = 1:length(raw_data)
        if(raw_data(i)~=0)
            raw_data(i) = raw_data(i) - avg_data_val;
        end
    end
    
    
    
    raw_data_peaks = raw_data;
    for i = 1:length(raw_data_peaks)
        if(raw_data_peaks(i)<0.15)
            raw_data_peaks(i) = 0;
        end
    end
    
    [val,pos] = findpeaks(raw_data_peaks);
    
    j= 0;
    k=0;
    
    k =1;
    temp_pos(k) = pos(1);
    temp_val(k) = val(1);
    for i = 2:length(val)
        
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
    
    
%             plot(raw_data_orig)
%             hold on
%             stem(pos2,ones(size(pos2)))
%             hold off
    
    
    
    
    
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


kfolds = 5;
l1 = length(complete_gt);
extra_l1 = kfolds*( l1/kfolds - floor(l1/kfolds));
complete_gt(end-extra_l1+1:end) = [];
complete_data(end-extra_l1+1:end,:) = [];


ind_cntr = zeros(3,1);
ind_loc = zeros(3,length(complete_gt));
cntr1 = zeros(3,1);

for i = 1:length(complete_gt)
    
    activity = complete_gt(i);
    cntr1(activity) = cntr1(activity)+1;
    ind_cntr(activity) = ind_cntr(activity)+1;
    ind_loc(activity,cntr1(activity)) = i;
end


    rand_array = randperm(length(complete_gt));




for trials = 1:kfolds      
    
    clearvars -except tr_percent complete_user experiment_list final_error_percent final_error_individual rand_array complete_data complete_gt confusion_mat trials kfolds ind_cntr ind_loc


    sig_train = zeros(3,length(complete_gt));
    sig_val = ones(1,length(complete_gt));

   
    kf_size = length(complete_gt)/kfolds;
    for kf1 = 1:(kfolds)
        folds_array(kf1,:) = rand_array( (kf1-1)*kf_size+1:(kf1)*kf_size ); 
    end

    trial_train_array = [];

    for i = 1:kfolds
        if i ~=trials
            trial_train_array = [trial_train_array folds_array(i,:)];
        end
    end
    
    
    activity = complete_gt(trial_train_array);
    for i = 1:length(trial_train_array)
        sig_train(activity(i),trial_train_array(i)) = 1;
    end
    sig_val(trial_train_array) = 0;
    
    final_ground_truth = complete_gt;
    final_ground_truth(trial_train_array) = 0;
    

    fgt_pos = find(final_ground_truth~=0);
    final_ground_truth = final_ground_truth(fgt_pos);




%
%         act_cntr= 0;
%         train_signal = zeros(size(raw_data));
%         validation_ground_truth = zeros(size(raw_data));
%         for i = 1:length(raw_data)
%
%             if (ground_truth(experiment_num,i) == activity)
%                 if (act_cntr < 500)
%                         train_signal(i) =1;
%                         act_cntr = act_cntr+1;
%                 end
%                 validation_ground_truth(i) =1;
%             end
%         end



xcorr_size = size(complete_data,2);
num_users = length(experiment_list);
num_class =3;
%%% Training Stage
train_cntr = zeros(num_class,num_users,1);
num_pca_sets = zeros(num_class);
for j = 1:num_class
    clear c
    for i = 1 : length(sig_train(j,:))
        if(sig_train(j,i) == 1)
            k = complete_user(i);
            train_cntr(j,k) = train_cntr(j,k) +1;
            x = complete_data(i,:);
            m_x = mean(x);
            x = x- m_x;
            %x_str(train_cntr,:) = x;
            c(k,train_cntr(j,k),:,:) = x'*x;
        end
    end
    for k = 1:num_users
        if(train_cntr(j,k) >= 4)
            temp = sum(c(k,:,:,:),2)/train_cntr(j,k);
            avg_c(1:xcorr_size,1:xcorr_size) = temp(1,1,:,:);
            [vec,val] = eig(avg_c);
            
            num_pca_sets(j) = num_pca_sets(j)+1;


            [val_sorted,pos_sorted] = sort(diag(val),'ascend');
            for  i =1:xcorr_size
                vec_sorted_overall(j,num_pca_sets(j),:,i) = vec(:,pos_sorted(i));
            end
        end
    end
    
end




% %%% PRE Validation Stage
% sig_val_temp = sum(sig_train,1);
% temp_ground_truth = sig_train(1,:)+2*sig_train(2,:)+3*sig_train(3,:);
% 
% cntr_val = zeros(3,1);
% sum_err = zeros(3,length(sig_val_temp(1,:)) );
% for j = 1:3
%     for i = 1 : length(sig_val_temp(1,:))
%         if(sig_val_temp(i) == 1)
%             cntr_val(j) = cntr_val(j) +1;
%             x = complete_data(i,:);
%             m_x = mean(x);
%             x = x- m_x;
%             vec_sorted(:,:) = vec_sorted_overall(j,:,:);
%             projection(cntr_val(j),:) = x*vec_sorted;
%             num_comp_used = 8;
%             compressed_pr = projection(cntr_val(j),1:xcorr_size).*[zeros(1,xcorr_size-num_comp_used) ones(1,num_comp_used)];
%             
%             error = x-compressed_pr*vec_sorted';
%             %sum_p(cntr_val) = sum(projection(cntr_val,99:100));
%             sum_err(j,i) = sum(error.^2);
%             
%         end
%     end
% end
% [fv,final_decision_temp] = min(sum_err)  ;
% 
% retrain_cntr = zeros(3,3);
% for j= 1:length(temp_ground_truth)
%     tgt_strain(j) = temp_ground_truth(j);
%     td_strain(j) = final_decision_temp(j);
%     if (tgt_strain(j)> 0)&&(td_strain(j)> 0) 
%         retrain_cntr(tgt_strain(j),td_strain(j)) = retrain_cntr(tgt_strain(j),td_strain(j))+1;
%         c_train_ind(tgt_strain(j),td_strain(j),retrain_cntr(tgt_strain(j),td_strain(j))) = j;
%     end
% end
% 
% 
% %%% Training Stage 2
% train_cntr = zeros(3,3);
% xcorr_size = size(complete_data,2);
% vec_sorted_overall_1 = vec_sorted_overall;
% clear c avg_c vec_sorted_overall projection sum_err
% for j = 1:3
%     for k = 1:3
%         clear c
%         nz_ind = length(find (c_train_ind(j,k,:) ~= 0 ));
%         for i = 1 : nz_ind
%             ind = c_train_ind(j,k,i);
%             train_cntr(j,k) = train_cntr(j,k) +1;
%             x = complete_data(ind,:);
%             m_x = mean(x);
%             x = x- m_x;
%             %x_str(train_cntr,:) = x;
%             c(train_cntr(j,k),:,:) = x'*x;
%          end
%     
% 
%         temp = sum(c,1)/train_cntr(j,k);
%         avg_c(1:xcorr_size,1:xcorr_size) = temp(1,:,:);
%         [vec,val] = eig(avg_c);
% 
% 
%         [val_sorted,pos_sorted] = sort(diag(val),'ascend');
%         for  i =1:xcorr_size
%             vec_sorted_overall(j,k,:,i) = vec(:,pos_sorted(i));
%         end
%     end
% end
% 
%             


%%%%% ACTUAL VALIDATION

clear sum_err i j k      
cntr_val = 0;%zeros(num_class,num_users,1);

for i = 1 : length(sig_val(1,:))
    if(sig_val(i) == 1)
    
    x = complete_data(i,:);
    m_x = mean(x);
    x = x- m_x;
    cntr_val = cntr_val +1;
    for j = 1:num_class
        
        
        for k = 1: num_pca_sets(j)
            

            vec_sorted(:,:) = vec_sorted_overall(j,k,:,:); 
            projection(cntr_val,:) = x*vec_sorted;
            num_comp_used = 15;
            compressed_pr(j,k,cntr_val,:) = projection(cntr_val,1:xcorr_size).*[zeros(1,xcorr_size-num_comp_used) ones(1,num_comp_used)];
            cmp_pr(1:xcorr_size) = compressed_pr(j,k,cntr_val,:);
            error = x-cmp_pr*vec_sorted';
            %sum_p(cntr_val) = sum(projection(cntr_val,99:100));
            sum_err(j,k) = sum(error.^2);
        
        end
        min_j_err(j,cntr_val) = min(sum_err(j,:));
        clear sum_err
    end
    end
end

[fv,final_decision] = min(min_j_err)  ;

final_error = length( find(final_decision - final_ground_truth ~= 0) );
final_error_percent(trials) = final_error/length(final_decision);


err_array = final_decision - final_ground_truth;
for i = 1:3
    err_position = find(final_ground_truth == i);
    temp_err_array = err_array(err_position);
    final_error_individual(i,trials) = length(find(temp_err_array ~= 0))/length(err_position);
end

%%%% Confusion Matrix


for j = 1:length(final_ground_truth)
    i1 = final_ground_truth(j);
    i2 = final_decision(j);
    confusion_mat(i1,i2,trials) = confusion_mat(i1,i2,trials) +1;
end

end

% final_error_individual_mult_trial = mean(final_error_individual,4);
% final_error_percent_mult_trial = mean(final_error_percent,3);
% 
%      
%         
% plot(mean(100*final_error_percent_mult_trial,2))
% hold on
% for i = 1:3
%     plot(mean(100*final_error_individual_mult_trial(:,:,i),2))
% end
% hold off
% xlim([0.5 7.5])
% %ylim([0 40])
%  xlabel('Percentage of Training Data')
% ylabel('Error %')
% legend('Error Overall','Walking','Climbing-Down','Climbing-Up')
