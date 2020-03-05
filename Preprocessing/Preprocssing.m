   clear all;
%Import Data
    load('DRIBBLE_GZ');
    load('DRIBBLE_PC');
    load('DRIBBLE_PC_26');load('DRIBBLE_PC_5');
    load('DRIBBLE_DATA_MATRIX');
    
    load('PASS_GZ');
    load('PASS_PC');
    load('PASS_PC_26');load('PASS_PC_5');
    load('PASS_DATA_MATRIX');
    load('RUN_Gz');     
    load('RUN_PC');
    load('RUN_PC_26');load('RUN_PC_5');
    load('RUN_DATA_MATRIX');
    load('WALK_GZ');
    load('WALK_PC');
    load('WALK_PC_26');
    load('WALK_PC_5');
    load('WALK_DATA_MATRIX');
    
    ax = importdata("ax.txt"); 
    ay = importdata("ay.txt");
    az = importdata("az.txt");
    gx = importdata("gx.txt");
    gy = importdata("gy.txt");
    gz = importdata("gz.txt");
    %Trim signal to remove start and stop segments, then mean adjust
    ax_raw_data = copyPartOfSignal(ax, 5000, 40000);
    ax = ax_raw_data - mean(ax_raw_data);
    ay_raw_data = copyPartOfSignal(ay, 5000, 40000);
    ay = ay_raw_data - mean(ay_raw_data);
    az_raw_data = copyPartOfSignal(az, 5000, 40000);
    az = az_raw_data - mean(az_raw_data);
    gx_raw_data = copyPartOfSignal(gx, 5000, 40000);
    gx = gx_raw_data - mean(gx_raw_data);
    gy_raw_data = copyPartOfSignal(gy, 5000, 40000);
    gy = gy_raw_data - mean(gy_raw_data);
    gz_raw_data = copyPartOfSignal(gz, 5000, 40000);
    gz = gz_raw_data - mean(gz_raw_data);
    raw_data = [ ax' , ay', az' , gx' , gy' , gz' ];
%     figure;
%     plot(raw_data); title('Mean Adjusted Patrick Walk');
%     plot(gz);
%     raw_data = DRIBBLE_GZ ;

    figure;
    subplot(4,1,1); plot(DRIBBLE_GZ); title('Dribble Gz');
    subplot(4,1,2); plot(PASS_GZ); title('Pass Gz');
    subplot(4,1,3); plot(RUN_GZ); title('Run Gz');
    subplot(4,1,4); plot(WALK_GZ); title('Walk Gz');
    %%%%%%%%%%%%%%%%%
    % Preprocessing %
    %%%%%%%%%%%%%%%%%
    
    % ADJUST this threshold to identify that what should be the smallest magnitude of a peak.    
    raw_data_peaks = raw_data;
    for i = 1:length(raw_data_peaks)
        if(raw_data_peaks(i)< 1)%was 0.15
            raw_data_peaks(i) = 0;
        end
    end
    
    %FIND ALL PEAKS
    [val,pos] = findpeaks(raw_data_peaks); 
    figure;
    plot(raw_data);
    title('Peak Identification');
    hold on;
    scatter(pos,val);
    hold off;
    
    %APPLY WINDOW
    j= 0;
    k=0;

    k =1;
    temp_pos(k) = pos(1);
    temp_val(k) = val(1);
    for i = 2:length(val)
        
        % ADJUST threshold on how close 2 peaks can  be
        %Distance
        if (pos(i)-pos(i-1))<150
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
    
            figure;
            plot(raw_data); %plot(raw_data_orig); 
            title('Windowed Peaks'); 
            hold on
            stem(pos2,ones(size(pos2))); 
            hold off
    
%     temp_vector = zeros(1,201);
    len = size(pos2); %returns 1x2 vector
    N = len(2);%the value stored in the second dimension of len is the number of peaks
    data_matrix= zeros(N, 201);
    for i = 1:N %for every peak
        if ( (pos2(i) - 100) > 0 ) && ((pos2(i) +100 < length(raw_data)))
        temp_vector = raw_data((pos2(i)-100):(pos2(i)+100));
         data_matrix(i,:) = temp_vector;
        end
         %clear temp_vector;
    end
    %Print all peak segments
%     for g = 1:81
%         figure;
%         plot(data_matrix(g,:))
%     end

%%%%%%%
% PCA %
%%%%%%%


cov_matrix = cov(data_matrix); 
[Eigenvectors, Eigenvalues] = eig(cov_matrix); 

%pick the greatest eigenvalues (examine the bottom right of matrix D)
%The columns of Eigenvectors correspond to the eigenvectors
%PrincipalCompnents:11 eigenvectors with 201 elements up/down the column
PrincipalComponents = zeros(201, 5);

%Get the principal components
numEigenvectors = size(Eigenvectors(1));
for i = 1:5
    temp_vector = Eigenvectors(:,196+i);
    PrincipalComponents(:,i) = temp_vector; 
end

%Compute the projection, aka dot product
Projections = zeros(1,5);
% DOES NOT WORK Projections = dot(data_matrix, PrincipalComponents');
for i=1:5
    Projections(1,i) = data_matrix(1,:) * PrincipalComponents(:,i);
end
Projections = data_matrix*PrincipalComponents;
%Compute the reconstructed vector
Reconstructed = zeros(5,201);
Reconstructed = Projections * PrincipalComponents';

% Error = norm(data_matrix - Reconstructed)
% ErrorPercentage=Error/norm(data_matrix)
% classificationError(data_matrix, DRIBBLE_PC);
% figure;
% plot(1:201,PrincipalComponents(:,11))
% figure;
% plot(1:201,data_matrix(1,:), 1:201,Reconstructed(1,:));title('Overlay of Data and Reconstructed Sigal');
% figure;
% plot(1:201,data_matrix(80,:), 1:201,Reconstructed(80,:));title('Overlay of Data and Reconstructed Sigal');    
% figure;
% plot(1:201,data_matrix(79,:), 1:201,Reconstructed(79,:));title('Overlay of Data and Reconstructed Sigal');    


classificationError(WALK_DATA_MATRIX, WALK_PC_5);

    
    
%     close all;
    
    
    %%%%%%%%%%%%%%%%%%%
%     n_cntr = 0;
%     ind_cntr = zeros(1,3);
%     gt_ind = zeros(3,length(pos2));
%     gt_pos_overall = [];
%     for i = 1:length(pos2)
%         for activity = 1:3
%             if (ground_truth(experiment_num,pos2(i)) == activity)
%                 n_cntr = n_cntr+1;
%                 ind_cntr(activity) = ind_cntr(activity)+1;
%                 gt_pos_overall(n_cntr) = pos2(i);
%                 gt_ind(activity,ind_cntr(activity)) = n_cntr;
%             end
%         end
%     end
%     
%     for i = 1:length(gt_pos_overall)
%         data(i,: ) = [raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,1); raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,2); raw_data_all_ch(gt_pos_overall(i)-20:gt_pos_overall(i)+50,3)];
%     end
%     if (length(gt_pos_overall) > 1)
%     num_epochs(experiment_num) = length(gt_pos_overall);
%     complete_data = [complete_data; data];
%     complete_gt = [complete_gt ground_truth(experiment_num,gt_pos_overall)];
%     user_set = ceil(experiment_cntr/60);
%     complete_user = [complete_user user_set*ones(1,length(gt_pos_overall))];
%     end



