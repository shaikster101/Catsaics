function image_index = rgb_average(tile, image_rgb_averages,num_images)
image_ssd = zeros(1,num_images); 

rgb_tile = mean(reshape(tile, size(tile,1) * size(tile,2), size(tile,3))); 

tile_r_mean = rgb_tile(1); 
tile_g_mean = rgb_tile(2); 
tile_b_mean = rgb_tile(3); 

for i=1:num_images
   image_r = image_rgb_averages{i}(1); 
   image_g = image_rgb_averages{i}(2); 
   image_b = image_rgb_averages{i}(3); 
   
   r_diff = tile_r_mean - image_r; 
   g_diff = tile_g_mean - image_g; 
   b_diff = tile_b_mean - image_b; 
   
   ssd_r = r_diff * r_diff; 
   ssd_g = g_diff * g_diff; 
   ssd_b = b_diff * b_diff; 
   
   
   sum = ssd_r + ssd_g + ssd_b; 
   image_ssd(i) = sum; 
end


[val,idx]=min(image_ssd);
image_index = idx; 

end

