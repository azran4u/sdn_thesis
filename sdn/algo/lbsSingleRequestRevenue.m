function [ revenue ] = lbsSingleRequestRevenue(duration, layer, w)    
    
    layerRevenue = w;
    revenue = layerRevenue(layer+1) * duration / sum(layerRevenue);
    
end

