load('DRIBBLE_GZ');
load('PASS_GZ');
load('RUN_Gz');
load('WALK_GZ');
figure;

raw_data = [ DRIBBLE_GZ, PASS_GZ, RUN_GZ, WALK_GZ ];
figure;
plot(raw_data); title('Dribble, Pass, Run, Walk');

    %%%%%%%%%%%%%%%%%
    % Preprocessing %
    %%%%%%%%%%%%%%%%%
    
    % ADJUST this threshold to identify that what should be the smallest magnitude of a peak.    
    raw_data_peaks = raw_data;
    threshold = 1;
    for i = 1:length(raw_data_peaks)
        if(raw_data_peaks(i)< threshold)%was 0.15
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
            refline(0, threshold);
            hline.Color = 'r';
            hold off
    

    data_matrix= zeros(length(pos2), 201);
    for i = 1:length(pos2) %was N %for every peak
        if (pos2(i) +100) < length(raw_data)
            temp_vector = raw_data((pos2(i)-100):(pos2(i)+100));
            data_matrix(i,:) = temp_vector;
        end
         clear temp_vector;
    end
%Print all peak segments
%     for g = 1:81
%         figure;
%         plot(data_matrix(g,:))
%     end

