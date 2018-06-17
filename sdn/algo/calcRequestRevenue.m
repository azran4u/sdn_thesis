function [ revenue ] = calcRequestRevenue(recieverPriority, contentPriority, duration, layer)

    % for grid tests
    layerRevenue = [8,1,0];
    revenue = layerRevenue(layer+1) * duration / sum(layerRevenue);
    
    %layerRevenue = [30,20,10];
    %revenue = layerRevenue(layer+1) * recieverPriority * contentPriority * duration / sum(layerRevenue);
    
end

