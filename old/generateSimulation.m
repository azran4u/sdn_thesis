function [ newG, newRequestTable ] = generateSimulation(G, requestTable)
    
    probability = rand;
    
    % event of link failure, same requests
    if probability < 0.2
        newG = eventLinkFailure(G);
        
    % event of node failure, same requests
    elseif probability > 0.8
        newG = eventNodeFailure(G);
                
    % same network, change in requests
    else       
        newG = G;
        
    end
  
    newRequestTable = buildRequestTable(newG);
    
end