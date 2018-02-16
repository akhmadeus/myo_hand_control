function mapping_mav_pos(range_close,range_open)

%Defining the finger position range. Each row corresponds to a different
%motion, each column corresponds to an actuator.
motion_names = {'cylindrical grasp','lateral grasp','precision grip',...
                'open','rest'};
motor_names = {'thumb(ab/adduction)','thumb','index','middle','ring','little'};
finger_pos = [18000 13823 43000 43000 43000 43000;... %cylindrical grasp
               9200 19000 43000 43000 43000 43000;... %lateral grasp
              16300  6900 23000     0     0     0;... %precision grip
                  0     0     0     0     0     0;... %opening motion
               4800  9400  7400  9200  9300 11000];   %resting motion 
open = 4; rest = 5;



for motion = 1:size(finger_pos,1)
    f = figure;
    set(f,'name',motion_names{motion});
    if motion == open
        %Setting the width of the emav neighbourhood
        interval_width = 5/100; % percentual of the maximum range value
        n_levels = floor(1/interval_width);
        interval_width = interval_width*(range_open(2)-range_open(1));
        %defining the magnitude levels in which the magnitude range is divided
        mav_levels = (1:n_levels).*(interval_width);
        mav_levels = range_open(1) + mav_levels;
        range_pos = finger_pos(motion,:)-finger_pos(rest,:);
        width = floor((range_pos)./n_levels);
        pos_levels = zeros(n_levels,6);
        for i = 1:n_levels
            pos_levels(i,:) = finger_pos(motion,:) + width.*(n_levels-i);
        end
        for motor = 1:6
            mapping = [mav_levels',pos_levels(:,motor)];
            mapping = [[range_open(1) finger_pos(rest,motor)];mapping];
            h = subplot(3,2,motor);hold on;
            plot(mapping(:,1),mapping(:,2),'bo');hold on;
            stairs(mapping(:,1),mapping(:,2),'b');hold on;
            for i = 1:n_levels
%                 line1 = linspace(range_open(1),mapping(i,1));
%                 plot(line1,mapping(i,2),'m');hold on;
                line2 = linspace(finger_pos(rest,motor),finger_pos(motion,motor)); 
                hold on;plot(h,mav_levels(i),line2,'r-');
            end
            x_lim = [range_open(1) range_open(2)];
            y_lim = [finger_pos(motion,motor) finger_pos(rest,motor)];
            if finger_pos(rest,motor) == finger_pos(motion,motor)
                y_lim = [finger_pos(rest,motor)-1000, finger_pos(rest,motor)+1000];
            end
            axis([x_lim y_lim]);
            xlabel('mav');
            ylabel('position');
            title(motor_names{motor});
            hold off;
        end %motor
    else %if motion is not open
        %Setting the width of the emav neighbourhood
        interval_width = 8/100; % percentual of the maximum range value
        n_levels = floor(1/interval_width);
        interval_width = interval_width*(range_close(2)-range_close(1));
        %defining the magnitude levels in which the magnitude range is divided
        mav_levels = (1:n_levels).*(interval_width);
        mav_levels = range_close(1) + mav_levels;
        
        range_pos = finger_pos(motion,:)-finger_pos(rest,:);
        width = floor((range_pos)./n_levels);
        for i = 1:n_levels
            pos_levels(i,:) = finger_pos(rest,:) + width.*i;
        end
        for motor = 1:6
            mapping = [mav_levels',pos_levels(:,motor)];
            mapping = [[range_open(1) finger_pos(rest,motor)];mapping];
            h = subplot(3,2,motor);hold on;
            plot(mapping(:,1),mapping(:,2),'bo');hold on;
            stairs(mapping(:,1),mapping(:,2),'b');hold on;
            for i = 1:n_levels
%                 line1 = linspace(range_close(1),mapping(i,1));
%                 plot(line1,mapping(i,2),'m');hold on;
                line2 = linspace(finger_pos(rest,motor),finger_pos(motion,motor)); 
                hold on;plot(h,mav_levels(i),line2,'r-');
            end
            x_lim = [range_close(1) range_close(2)];
            y_lim = [min(finger_pos(rest,motor),finger_pos(motion,motor)) max(finger_pos(rest,motor),finger_pos(motion,motor))];
            if finger_pos(rest,motor) == finger_pos(motion,motor)
                y_lim = [finger_pos(rest,motor)-1000, finger_pos(rest,motor)+1000];
            end
            axis([x_lim y_lim]);
            xlabel('mav');
            ylabel('position');
            title(motor_names{motor});
            hold off;
        end %motor
    end %elseif
end %motion



end