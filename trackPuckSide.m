% Script to track the puck in the top camera frames
close all;
clear all;

global R_MIN R_MAX

% Constants
LEFT = 130;
TOP = 280;
RIGHT = 650;
BOTTOM = 480;
THRESH = 150;
R_MIN = 30/2;
R_MAX = 70/2;
SENS = 0.9;

MAX_AREA = R_MAX^2*pi; 
MIN_AREA = 100; 

centers = []; 
radii = []; 
alphas = [];

v = VideoReader('Cam_Side_Clipped/Shot_17.MP4');
nFrames = round(v.Duration*v.FrameRate);
width = v.Width; height = v. Height; 

for i = 1:nFrames - 10
   
    frame_int = read(v,i);
    frame_int = frame_int( TOP:BOTTOM,LEFT:RIGHT, :); 
%     figure, imshow(frame_int)
    % THRES
    gray_frame = rgb2gray(frame_int); 
%     figure, imshow(gray_frame)

    mask = gray_frame(:,:) < 30; 
%     figure, imshow(mask)

    % Close the BW mask first, then open it 
    se = strel('disk', 2); 
    opened_bw = imopen(mask, se); 
    closed_bw = imclose(opened_bw, se); 
%     figure, imshow(closed_bw); 

    % Get RP's

    regions = regionprops(closed_bw, {'Centroid', 'Area', 'BoundingBox', 'Orientation',...
        'MajorAxisLength', 'MinorAxisLength'});
    pucks = struct(regions);

    % Remove background regions (too large)
    % Also check that the centroid is in the feasible region (y + 4x/5 > 200)
    count = 1; 
    for j = 1:length(regions)
        if(regions(j).Area > MAX_AREA ||  regions(j).Area < MIN_AREA || ... 
                regions(j).Centroid*[.45 1]' < 120)
            pucks(count) = []; 
        else
            count = count + 1; 
        end
    end

%     figure, imshow(frame_int); 
%     rectangle('Position', pucks(1).BoundingBox,...
%             'EdgeColor','r','LineWidth',2 )
    
    if(size(pucks,2) > 1)
        [~, idx] = max(vertcat(pucks.Area)); 
        center = pucks(idx).Centroid; 
        alpha = pucks(idx).Orientation; 
    elseif(size(pucks,2) == 1)
        center = pucks(1).Centroid; 
        alpha = pucks(1).Orientation; 
    else
        center = [nan nan]; 
        alpha = nan; 
    end
    centers = [centers; center]; 
    alphas = [alphas; alpha*pi/180]; % angle of attack in rads
    
end

[~, vy_dt, range] = calc2DVelocity(centers, 'side');
vy_dt = -vy_dt % The positive image v axis is inverted

attackAngles = alphas(range(1): range(2))*180/pi;   %deg for visualization
attackAngle= mean(attackAngles); 
attackAngle*pi/180


figure, scatter(1:length(attackAngles),attackAngles, 'LineWidth', 2);
xlabel('Frame after Shot'); 
ylabel('Angle of Attack (deg)'); 
title('Angle of Attack vs Frame'); 

frame_int = read(v, range(1)); 
figure, imshow(frame_int( TOP:BOTTOM,LEFT:RIGHT, :));

centers_to_view = centers(range(1):range(2),:); 
radii_to_view = ones(length(centers_to_view),1)*15; 
viscircles(centers_to_view,radii_to_view,'LineStyle','--');


%  stop
% 
%     frame_int = imcomplement(frame_int); 
%     level = graythresh(frame_int); 
%     BW = im2bw(frame_int,level);
%     figure, imshow(BW)
%     se = strel('disk',15); 
%     background = erode(BW,se);
%     figure, imshow(background)
%     
%     figure
%     for i = range(1):range(2)
%               frame_int = read(v,i);
%         frame_int = frame_int( TOP:BOTTOM,LEFT:RIGHT, :); 
%     %     figure, imshow(frame_int)
%         % THRES
%         gray_frame = rgb2gray(frame_int); 
%     %     figure, imshow(gray_frame)
% 
%         mask = gray_frame(:,:) < 30; 
%     %     figure, imshow(mask)
% 
%         % Close the BW mask first, then open it 
%         se = strel('disk', 7); 
%         opened_bw = imopen(mask, se); 
%         closed_bw = imclose(opened_bw, se); 
%         imshow(closed_bw); 
%         
%     end
