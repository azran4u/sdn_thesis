function [ revenue ] = calcRequestRevenue(recieverPriority, contentPriority, duration, layer)

    layerRevenue = [30,20,10];

    revenue = layerRevenue(layer+1) * recieverPriority * contentPriority * duration;
    
end

