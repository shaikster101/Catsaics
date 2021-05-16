function match = find_match_tile(tile_avg,dataset_averages)

[val,idx]=min(abs(dataset_averages-tile_avg));
minVal=dataset_averages(idx); 
match = minVal; 

end

