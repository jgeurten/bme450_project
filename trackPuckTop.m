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

OO_FRAME = 100; % when does the puck exit the frame? 
IN_FRAME = 0;   % when does the puck begin moving

v = VideoReader('Top_Shot0.MP4');
nFrames = round(v.Duration*v.FrameRate);
width = v.Width; height = v. Height; 
% 
% % Get the position of the plex-glass to bound the puck search algo
% r_frames = zeros(length(TOP:BOTTOM), width - LEFT + 1,nFrames-10); 
% % g_frames = zeros(TOP:BOTTOM, LEFT:end,nFrames-10); 
% % b_frames = zeros(TOP:BOTTOM, LEFT:end,nFrames-10); 
% 
% for i = 1:nFrames - 10
%     temp_frame = read(v,i); 
%     r_frames(:,:,i) = temp_frame(TOP:BOTTOM, LEFT:end, 1); 
% %     g_frames(i) = temp_frame(TOP:BOTTOM, LEFT:END, 2); 
% %     b_frames(i) = temp_frame(TOP:BOTTOM, LEFT:END, 3); 
% end

centers = []; 
radii = [];
%for i = 1:size(r_frames,3)
for i = 1:nFrames  - 10
    frame_int = read(v, i); 
    %[center, radius] = imfindcircles(r_frames(:,:,i),[R_MIN R_MAX],...
    [center, radius] = imfindcircles(frame_int,[R_MIN R_MAX],...
    'ObjectPolarity','dark');%,'Sensitivity', SENS);
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

stop

%viscircles(centers, radii,'LineStyle','--');

fiducial_centers = trackFiducials(first_frame(TOP:BOTTOM, LEFT:end,:), radii, centers);

