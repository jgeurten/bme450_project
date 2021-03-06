function [vx_dt, vy_dt, range] = calc2DVelocity(centers, cam_type)

% Constants
if(strcmp(cam_type,'top'))
    PUCK_SZ_PX = 70; % Diameter in pixels (empirically calc over multiple frames)
    DDT_THRES = 2;
else
    PUCK_SZ_PX = 55;
    DDT_THRES = 6;
end
PUCK_SZ_M = 76/1000; % Puck diameter: 76mm
FRAME_RATE = 240;    % FPS
PERIOD = 1/FRAME_RATE; % in seconds

x = centers(:,1); y = centers(:,2);
dx = diff(x); dy = diff(y); 
dxx = smooth(dx); 
dyy = smooth(dy); 

figure, hold on
plot(1:length(x),x, 'LineWidth', 3, 'Color', 'b',  'DisplayName', 'X Centroid' )
plot(1:length(y),y, 'LineWidth', 3, 'Color', 'r',  'DisplayName', 'Y Centroid')

legend('show')

xlabel('Frame Number');
ylabel('Position (px)'); 
title('Position Centroid vs Frame')


% Plot position data
figure, plot(1:length(x),x, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('Position (X pixel)'); 
title('Position of x Center')
saveas(gcf, 'Position_X_Center.png')
figure, plot(1:length(y),y, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('Position (Y pixel)'); 
title('Position of y Center')
saveas(gcf, 'Position_Y_Center.png')

% Plot velocity data
figure, plot(1:length(dxx),dxx, 'LineWidth', 3)
xlabel('Frame Number');
ylabel('dx/dt (pxs/frame)'); 
title('Derivative of x Center')
saveas(gcf, 'Derivative_X_Center.png')

figure, plot(1:length(dyy),dyy, 'LineWidth', 3)
title('Derivative of y Center')
xlabel('Frame Number');
ylabel('dy/dt (pxs/frame)'); 
saveas(gcf, 'Derivative_Y_Center.png')

% First instance of moving puck -- averaged from the dx and dy channel
% (+) dx --> left to right (global: forward); (+) dy --> top to bottom (global: right)

frame_idx = round((find(abs(dxx) > DDT_THRES, 1) + find(abs(dyy) > DDT_THRES, 1))/2) - 2; 

% Calculate derivative of center point of the puck [pixels/second]
vx = mean(dxx(frame_idx:end)); vy = mean(dyy(frame_idx:end)); 
non_x = ~isnan(x); non_y = ~isnan(y);

if(strcmp(cam_type,'top'))
    last_x_idx = length(x); 
    last_y_idx = length(y); 
else
    last_x_idx = find(isnan(x), 1)-1;
    last_y_idx = find(isnan(y), 1)-1;
end

if(last_y_idx < frame_idx | last_x_idx < frame_idx)
    last_x_idx = frame_idx + 20; 
    last_y_idx = frame_idx + 20; 
end

vxx =  (x(last_x_idx) - x(frame_idx))/(last_x_idx - frame_idx); 
vyy =  (y(last_y_idx) - y(frame_idx))/(last_y_idx - frame_idx); 

vx_dt = vxx*(PUCK_SZ_M/PUCK_SZ_PX)/PERIOD; % in m/s
vy_dt = vyy*(PUCK_SZ_M/PUCK_SZ_PX)/PERIOD; % in m/s

range = [frame_idx round(mean([last_x_idx last_y_idx],2))];

end