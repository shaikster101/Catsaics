function min_ssd_index = ssd(tile, tile_dim, image_cells, num_pics)
    
%image_dataset = cell(2,nfiles); 
image_ssd = zeros(1,num_pics); 

for i=1:num_pics
   image = image_cells{i}; 
   diff = tile - image;
   ssd = sum(diff(:).^2);
   image_ssd(i) = ssd; 
end

[val,idx]=min(image_ssd);
min_ssd_index = idx; 

end

