function [ revenue ] = lbsSingleRequestRevenue(duration, layer)    
    
    layerRevenue = [8,1,0];
    revenue = layerRevenue(layer+1) * duration / sum(layerRevenue);
    
end

