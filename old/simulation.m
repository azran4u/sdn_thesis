function [ outputG, outputRequestTable ] = simulation( G )
    
    N = 10;
    
    [newRequestTable] = buildRequestTable(G);  
    allRevenues = [];
    
    for t = [1:N]
        [ newG, newRequestTable ] = generateSimulation(G, newRequestTable);
        [ outputG, outputRequestTable ] = lbsls( newG, newRequestTable );
        currentRevenue = revenue( outputRequestTable );
        allRevenues = [allRevenues currentRevenue];
    end
    
end