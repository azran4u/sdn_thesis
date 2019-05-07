function [ revenue ] = llvsSingleRequestRevenue(duration, layer, recieverPriority)    
    
    W = [8,1,1,1,1,1];
    
    % Gold=1, Silver=2, Bronze = 3
    if( recieverPriority == 1 && layer == 0)
        w = W(1);
    elseif ( recieverPriority == 2 && layer == 0)
        w = W(2);
    elseif ( recieverPriority == 1 && (layer == 1 || layer == 2))
        w = W(3);
    elseif ( recieverPriority == 3 && layer == 0)
        w = W(4);
    elseif ( recieverPriority == 2 && (layer == 1 || layer == 2))
        w = W(5);
    elseif ( recieverPriority == 3 && (layer == 1 || layer == 2))
        w = W(6);
    end
    revenue = w * duration;
    
end

