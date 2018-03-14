function [ outputG, outputRequestTable ] = simulation( G )
    
    N = 1;
    
    [newRequestTable] = buildRequestTable(G);  
    allRevenues = [];
    
    for t = [1:N]
        [ newG, tempRequestTable ] = generateSimulation(G, newRequestTable);
        newRequestTable = tempRequestTable;
        [ outputG, outputRequestTable ] = lbsls( newG, newRequestTable );
        currentRevenue = revenue( outputRequestTable );
        allRevenues = [allRevenues currentRevenue];
    end
    
end