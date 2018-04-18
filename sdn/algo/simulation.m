function [ outputG, outputRequestTable ] = simulation( G )
    
    allRevenues = [];

    t=1;
    % build request table from G
    [requestTable] = createEmptyRequestTable();
    [tempRequestTable] = buildRequestTable(G, requestTable);  
    requestTable = tempRequestTable;
    
    % run LBSLS
    [ tempG, tempRequestTable ] = lbsls( G, requestTable );
    G = tempG;
    requestTable = tempRequestTable;
    
    % calc revenue
    currentRevenue = revenue( requestTable );
    allRevenues = [allRevenues currentRevenue];
    
    t=2;
    % add user
    table = find(strcmp('reciever',G.Nodes.types));
    notActiveRecievers = G.Nodes.recieverPriority(table)==0;
    if( sum(notActiveRecievers) == 0 )
        disp('cannot add user');
    else
        range = table(notActiveRecievers);
        newReciever = range(randsample(length(range),1, true));
        s = RandStream.getGlobalStream;
        G.Nodes.recieverPriority(newReciever) = datasample(s,[1:1:3],1,'Weights',[0.3 0.3 0.4]);
        
        % update request table
        [tempRequestTable] = buildRequestTable(G, requestTable);  
        requestTable = tempRequestTable;
        
        % run LBSLS
        [ tempG, tempRequestTable ] = lbsls( G, requestTable );
        G = tempG;
        requestTable = tempRequestTable;
        
        % calc revenue
        currentRevenue = revenue( outputRequestTable );
        allRevenues = [allRevenues currentRevenue];

    end
    
