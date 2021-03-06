% Script to track the puck in the top camera frames
close all;
clear all;

global R_MIN R_MAX

% Constants
LEFT = 125;
TOP = 30;
BOTTOM = 390;
THRESH = 150;
R_MIN = 40/2;
R_MAX = 80/2;
SENS = 0.8;
FPS = 240; 

v = VideoReader('Cam_Top_Clipped/Shot_17.MP4');
nFrames = round(v.Duration*v.FrameRate);
width = v.Width; height = v. Height; 

centers = []; 
radii = [];
%for i = 1:size(r_frames,3)
for i = 1:nFrames  - 10
    frame_int = read(v, i); 
    frame_int = frame_int( TOP:BOTTOM,LEFT:end, :); 
%     figure, imshow(frame_int); 
    
    % Find puck through circle detection
    [center, radius] = imfindcircles(frame_int,[R_MIN R_MAX],...
    'ObjectPolarity','dark');%,'Sensitivity', SENS);
    viscircles(center, radius,'LineStyle','--');

    if(numel(radius) > 1)
        [radius, idx] = max(radius); 
        center = center(idx,:);
    end
    centers = [centers; center]; 
    radii = [radii; radius];  
end

figure, plot(centers(:,1)); 
title('X Centers'); 

figure, plot(centers(:,2)); 
title('Y Centers'); 

[vx_dt, vz_dt, range] = calc2DVelocity(centers, 'top')

%%
fiducialLocations = [];
radii_idx = []; 
centers_idx = [];
for i = range(1):range(2)
    frame_int = read(v, i); 
%     [fidLocs, r_idx, c_idx] = trackFiducials(frame_int(TOP:BOTTOM, LEFT:end,:), radii(i), centers(i,:));
%     fiducialLocations = [fiducialLocations; fidLocs];
%     radii_idx = [radii_idx; r_idx]; 
%     centers_idx = [centers_idx; c_idx];
    [fidLocs] = trackFiducials(frame_int(TOP:BOTTOM, LEFT:end,:), radii(i), centers(i,:));
     fiducialLocations = [fiducialLocations; fidLocs];

end
figure, imshow(frame_int)
angles = [];
for i = 1:length(fiducialLocations)
    
     % Scale fiducials back to global image frame
    cx = centers(i+range(1) - 1,1) + LEFT; 
    cy = centers(i+range(1) - 1,2) + TOP; 
    R = radii(i+range(1) - 1); 
    xpt = fiducialLocations(i,1) + cx - R; 
    ypt = fiducialLocations(i,2) + cy - R ;
    angle = atand((ypt-cy)/(xpt-cx)); 

    angles = [angles; angle];
    viscircles([xpt ypt], 10,'LineStyle','--');
end

angles = angles - angles(1); 
figure, plot(angles)
xlabel('Frames after impact')
ylabel('Angle of Rotation (deg)')
title('Rotational Position of Puck vs Frame')

% Get rotational velocity in units [rad/s]
if(mean(diff(angles)) < 0)
    sorted_theta = sort(angles); 
    final_theta = mean(sorted_theta(1:3)); 
else
    sorted_theta = sort(angles); 
    final_theta = mean(sorted_theta(length(sorted_theta) - 3:end));
end

angVel_deg_frame = (final_theta - angle(1))/length(angles);  % angle(1) always == 0
angVel = angVel_deg_frame*pi/180*FPS % in units rad/s

% Cluster the pixel locations to fiducials:
% 4 Classes: 3 fiducials, 1 zeros - tested by manual classification
% [idx,C] = kmeans(fiducialLocations,3);
% angles_1 = []; 
% angles_2 = []; 
% angles_3 = []; 
% 
% x1_pts = [];
% y1_pts = [];
% figure, imshow(frame_int)
% for i = 1:length(idx)
%     
%      % Scale fiducials back to global image frame
%     cx = centers_idx(i,1) + LEFT; 
%     cy = centers_idx(i,2)+ TOP; 
%     R = radii_idx(i); 
%     xpt = fiducialLocations(i,1) + cx - R; 
%     ypt = fiducialLocations(i,2) + cy - R ;
%     angle = atand((ypt-cy)/(xpt-cx)); 
% 
%     if(idx(i) == 1)
%         angles_1 = [angles_1; angle]; 
%         x1_pts = [x1_pts; xpt]; 
%         y1_pts = [y1_pts; ypt]; 
% 
% 
%     elseif(idx(i) == 2)
%         angles_2 = [angles_2;angle];
%         
% 
%     else
%         angles_3 = [angles_3;angle];
%         viscircles([xpt ypt], 10,'LineStyle','--');
%     end
% end
% angles_1 = angles_1 - angles_1(1); 
% angles_2 = angles_2 - angles_2(1); 
% angles_3 = angles_3 - angles_3(1); 
% figure, plot(angles_1)
% xlabel('Frames after impact')
% ylabel('Angle of Rotation (deg)')
% title('Rotational Position of Puck vs Frame')
% figure, plot(angles_2)
% xlabel('Frames after impact')
% ylabel('Angle of Rotation (deg)')
% title('Rotational Position of Puck vs Frame')
% figure, plot(angles_3)
% xlabel('Frames after impact')
% ylabel('Angle of Rotation (deg)')
% title('Rotational Position of Puck vs Frame')
