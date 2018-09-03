function [sortedRequestTable] = LLVSsortRequests(requestTable)
    % Gold=1, Silver=2, Bronze = 3
    % BL=0, EL1=1, EL2=2
    
    % request priorities
    % BL of GOLD
    % BL of SILVER
    % EL1 of GOLD
    % BL of BRONZE
    % EL2 of GOLD
    % EL1 of SILVER
    % EL1 of BRONZE
    % EL2 of SILVER
    % EL2 of BRONZE

    sorted = [];
    
    % BL of GOLD
    query=requestTable.recieverPriority==1 & requestTable.layer==0;
    sorted = [sorted requestTable(query, :)];

    % BL of SILVER
    query=requestTable.recieverPriority==2 & requestTable.layer==0;
    sorted = [sorted ; requestTable(query, :)];

    % EL1 of GOLD
    query=requestTable.recieverPriority==1 & requestTable.layer==1;
    sorted = [sorted ; requestTable(query, :)];

    % BL of BRONZE
    query=requestTable.recieverPriority==3 & requestTable.layer==0;
    sorted = [sorted ; requestTable(query, :)];
    
    % EL2 of GOLD
    query=requestTable.recieverPriority==1 & requestTable.layer==2;
    sorted = [sorted ; requestTable(query, :)];
    
    % EL1 of SILVER
    query=requestTable.recieverPriority==2 & requestTable.layer==1;
    sorted = [sorted ; requestTable(query, :)];
    
    % EL1 of BRONZE
    query=requestTable.recieverPriority==3 & requestTable.layer==1;
    sorted = [sorted ; requestTable(query, :)];
    
    % EL2 of SILVER
    query=requestTable.recieverPriority==2 & requestTable.layer==2;
    sorted = [sorted ; requestTable(query, :)];
    
    % EL2 of BRONZE
    query=requestTable.recieverPriority==3 & requestTable.layer==2;
   sorted = [sorted ; requestTable(query, :)];
    
   sortedRequestTable = sorted;
end

