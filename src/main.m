source = im2double(imread("set3_original.jpg")); %The target image
tile_dim = 25; %tiling dimention

x = roundn(size(source, 2), 2); %scale to the nearest 100 -> to make it easier to use the tiling
y = roundn(size(source, 1), 2); %scale to the nearest 100 -> to make it easier to use the tiling
src = imresize(source, [y, x]); 

size(src)

src_copy = src; %store a copy to be for comparison
src_hist_matching = src; %copy to generate the histtogram matching


%Get dataset images and how many there are
imagefiles = dir('catdataset/CAT_00/*.jpg'); 
nfiles = length(imagefiles); 

%store image names and resized images
image_names = strings(1,nfiles); 
image_cells = {1,nfiles}; 

%store different average values
image_averages = zeros(1,nfiles); 
image_rgb_averages = {1,nfiles}; 

%Process the dataset
for i=1:nfiles
   image_name = "catdataset/CAT_00/" + imagefiles(i).name; %get name
   image = im2double(imread(image_name)); %read image
   image = imresize(image, [tile_dim,tile_dim]); %resize
   image_cells{i} = image; %store image
   image_names(i) = image_name; %store image name
   
   %average over channels individually
   rgb = mean(reshape(image, size(image,1) * size(image,2), size(image,3))); 
   image_rgb_averages{i} = rgb; 
    
   % average over all channels
   image_mean = mean(image(:)); 
   image_averages(i) = image_mean; 
end



for y=1:tile_dim:size(src, 1)
    for x=1:tile_dim:size(src, 2)
        image_tile = src(y:y+tile_dim-1, x:x+tile_dim-1, :); %current tile
%         index = rgb_average(image_tile, image_rgb_averages,nfiles); %get index

        index = ssd(image_tile,tile_dim, image_cells, nfiles); 

%       image_tile_average = mean(image_tile(:)); 
%       match = find_match_tile(image_tile_average,image_averages); 
%       index = find(image_averages == match); 

        if(size(index,2) > 1)
            index = randsample(index,1); 
            disp("Randomly Sampled Index"); 
        end
        image_name = image_names(index);  %get image name
        tile = im2double(imread(image_name)); %read src image
        tile = imresize(tile, [tile_dim, tile_dim]); %resize src image
        
        src(y:y+tile_dim-1, x:x+tile_dim-1, :) = tile; %apply to regular tile 
        
        hist_matched_tile = imhistmatch(tile,image_tile); %hist match the src to tile 
        
        src_hist_matching(y:y+tile_dim-1, x:x+tile_dim-1, :) = hist_matched_tile; % copy to new src
                 
        imshow(src)
    end
end

%write src
subplot(1,3,1); imshow(src_copy); 
subplot(1,3,2); imshow(src); 
subplot(1,3,3); imshow(src_hist_matching); 
imwrite(src, "set3_mosaic.jpg");  


