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


v = VideoReader('Side_Shot_0.MP4');
nFrames = round(v.Duration*v.FrameRate);
width = v.Width; height = v. Height; 

frame_int = read(v,271);
frame_int = frame_int( TOP:BOTTOM,LEFT:RIGHT, :); 
figure, imshow(frame_int)
% THRES
gray_frame = rgb2gray(frame_int); 
figure, imshow(gray_frame)

mask = gray_frame(:,:) < 30; 
figure, imshow(mask)

% Close the BW mask first, then open it 
se = strel('disk', 5); 
opened_bw = imopen(mask, se); 
closed_bw = imclose(opened_bw, se); 
figure, imshow(closed_bw); 

% Get RP's

regions = regionprops(closed_bw, {'Centroid', 'Area', 'BoundingBox'});
pucks = struct(regions);
 
% Remove background regions (too large)
% Also check that the centroid is in the feasible region (y + 4x/5 > 200)
count = 1; 
for i = 1:length(regions)
    if(regions(i).Area > MAX_AREA || regions(i).Centroid*[4/5 1]' < 200)
        pucks(count) = []; 
    else
        count = count + 1; 
    end
end

figure, imshow(frame_int); 
rectangle('Position', pucks(1).BoundingBox,...
        'EdgeColor','r','LineWidth',2 )


stop

frame_int = imcomplement(frame_int); 
level = graythresh(frame_int); 
BW = im2bw(frame_int,level);
figure, imshow(BW)
se = strel('disk',15); 
background = erode(BW,se);
figure, imshow(background)

stop

figure, imshow(frame_gb); 
[center, radius] = imfindcircles(frame_gb,[R_MIN R_MAX],...
    'ObjectPolarity','bright','Sensitivity', SENS);
viscircles(center, radius,'LineStyle','--');


figure, imshow(frame_gb_); 

[center, radius] = imfindcircles(frame_gb_,[R_MIN R_MAX],...
    'ObjectPolarity','bright','Sensitivity', SENS);
viscircles(center, radius,'LineStyle','--');

figure, imshow(imfilter(frame_int, [-1 0 1]),[]); 
figure, imshow(imfilter(frame_int, [-1 0 1]'),[]); 

stop

c = makecform('srgb2lab');
frame_lab = rgb2lab(frame_int); 

se = strel('disk',15); 
background = imclose(frame_int,se);
figure, imshow(background)
back_gray = rgb2gray(background); 
J = imadjust(back_gray,stretchlim(back_gray),[]);
figure, imshow(J)

inv = imcomplement(J); 
figure, imshow(inv)




bw = im2bw(inv); 
figure, imshow(bw);



% K means from the lab
% for K = [4,4]
% %     if (K == 2)
% %         row = [55 200];
% %         col = [155 400];
% %     elseif (K == 4)
% %         row = [55 130 200 280];
% %         col = [155 110 400 470];
% %     end
%         
%     if (K == 2)
%         row = [55 150];
%         col = [90 400];
%     elseif (K == 4)
%         row = [25 65 100 190];
%         col = [155 110 400 470];
%     end
% 
%     % Convert (r,c) indexing to 1D linear indexing.
%     idx = sub2ind([size(frame_int,1) size(frame_int,2)], row, col);
% 
%     % Reshape the a* and b* channels
%     ab = double(frame_lab(:,:,2:3));
%     m = size(ab,1);
%     n = size(ab,2);
%     ab = reshape(ab,m*n,2);
%     mu = zeros(K, 2);
% 
%     % Vectorize starting coordinates
%     for k = 1:K
%         mu(k,:) = ab(idx(k),:);
%     end
% 
%     cluster_idx = kmeans(ab, K, 'Start', mu);
% 
%     % Label each pixel according to k-means
%     pixel_labels = reshape(cluster_idx, m, n);
%     figure
%     h = imshow(pixel_labels, []);
%     title(['Peppers Segmented With K-Means and K = ', num2str(K)]);
%     colormap('jet')
%     saveas(gcf, ['peppers_k_means_', num2str(K),'.png']);
% end

