function [fiducial_centers] = trackFiducials(frame, radii, centers)
% function [fiducial_centers, r_idx, c_idx] = trackFiducials(frame, radii, centers)
    % close all;
    % v = VideoReader('Top_Shot0.MP4');
    %
    % frame = read(v, 367);
    % radii = 32.35;
    % centers = [305.96 187.08];

    % frame = read(v, 1);
    % radii = 29.3398;
    % centers = [154.46 172.30];

    LEFT = 125;
    TOP = 30;
    BOTTOM = 390;
    A_THRESH = 10; 
    % frame = frame(TOP:BOTTOM, LEFT:end,:);

    fiducial_centers = [];

    % Assumes only one set of centers and radii are passed in

    R_MIN = 40/2;
    R_MAX = 120/2;
    MIN_FID_AREA = R_MIN^2*pi;
    MAX_FID_AREA = R_MAX^2*pi;

    %Imresize = 8
    % R_MIN = 80/2;
    % R_MAX = 120/2;

    OFFSET = 0;
    SENS = 0.80;

    radii = radii + OFFSET;
    % Bounding box:
    cx = centers(1); cy = centers(2);
    left = round(cx - radii); width = round(radii*2);
    top = round(cy - radii); height = round(radii*2);

%     figure, imshow(frame);
%     rectangle('Position', [left, top, width, height],...
%             'EdgeColor','r','LineWidth',2 )
    if(left+width > size(frame,2))
        puck = frame(top:top+height, left:end,:);
    else
        puck = frame(top:top+height, left:left+width,:);
    end
    puck = imresize(puck, 4);
    puck_blur = imgaussfilt(puck, 3);
%     figure, imshow(puck_blur)
    [fid_centers, fid_radii] = imfindcircles(puck_blur,[R_MIN R_MAX],...
        'ObjectPolarity','bright','Sensitivity', SENS); %,'Method', 'twostage');
%     viscircles(fid_centers, fid_radii,'LineStyle','--');
    fiducial_centers = [fiducial_centers; fid_centers];

    if(size(fiducial_centers,1) > 1)
        %Choose one with highest yellow value (b in the LAB channel):
        lab = rgb2lab(puck_blur);
        b_channel = lab(:,:,3); 
        vals = [];
        for i =1:length(fiducial_centers)
            cx_mask = round(fiducial_centers(i,1)); 
            cy_mask = round(fiducial_centers(i,2)); 
            vals = [vals; mean(mean(b_channel( cy_mask-3:cy_mask+3, cx_mask-3:cx_mask+3)))];
        end
        
        [M,I] = max(vals); 
        
        fiducial_centers = fiducial_centers(I,:); 
    end
%     RGB = insertMarker(puck_blur,fiducial_centers);
%     figure, imshow(RGB)
    
    % convert to LAB space to get red (red usually fails):
% 
%     lab = rgb2lab(puck_blur);
%     %l_channel = lab(:,:,1);
%     %b_channel = lab(:,:,3);
% 
%     a_channel = lab(:,:,2);
%     mask = a_channel > A_THRESH; 
%     se = strel('disk', 7); 
%     opened_bw = imopen(mask, se); 
%     closed_bw = imclose(opened_bw, se); 
%     % figure, imshow(closed_bw);
%     FID = regionprops(closed_bw, {'Centroid', 'Area', 'BoundingBox'});
%     for i = 1:length(FID)
%         if(FID(i).Area > MIN_FID_AREA && FID(i).Area < MAX_FID_AREA  )
%             fiducial_centers = [fiducial_centers; FID(i).Centroid];
%         end
%     end
% % 
% %     RGB = insertMarker(puck_blur,fiducial_centers);
% %     figure, imshow(RGB)
%     
%     % Make sure only one type of fiducial is found
%     if(length(fiducial_centers ) > 3)
%         [idx,C] = kmeans(fiducial_centers,3);
%         ones_idx = find(idx == 1); %indices
%         twos_idx = find(idx == 2); 
%         threes_idx = find(idx == 3); 
% 
%         % Best one is closest to center px
%         if(length(ones_idx)>1)
%             dists = [];
%             for i = 1:length(ones_idx)
%                 dists = [dists; pdist([fiducial_centers(ones_idx(i),:); centers])];
%             end
%             [~,best_one] = min(dists); 
%             best_one = ones_idx(best_one); 
%         else
%             best_one = ones_idx;
%         end
% 
%         if(length(twos_idx)>1)
%             dists = [];
%             for i = 1:length(twos_idx)
%                 dists = [dists; pdist([fiducial_centers(twos_idx(i),:); centers])];
%             end
%             [~,best_two] = min(dists); 
%             best_two = twos_idx(best_two); 
%         else
%             best_two = twos_idx;
%         end
%         
% 
%         if(length(threes_idx)>1)
%             dists = [];
%             for i = 1:length(threes_idx)
%                 dists = [dists; pdist([fiducial_centers(threes_idx(i),:); centers])];
%             end
%             [~,best_three] = min(dists); 
%             best_three = threes_idx(best_three); 
%         else
%             best_three = threes_idx;
%         end
%         
%         fiducial_centers = [fiducial_centers(best_one,:);fiducial_centers(best_two,:); ...
%             fiducial_centers(best_three,:)];
%         
%     end
%     
%     r_idx = ones(length(fiducial_centers),1).*radii; 
%     c_idx = [ones(length(fiducial_centers),1).*centers(1) ones(length(fiducial_centers),1).*centers(2)];
   
end