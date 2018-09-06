% implementation of LLVS algorithm
%function [ G, requestTable, runTime, details ] = lbsls( G, requestTableInput )
function [ results ] = LLVS( G, requestTableInput )
   
    results = cell2table(cell(0,4), 'VariableNames', {
        'G', 
        'requestTable', 
        'runTime',
        'details'});
    
    details = cell2table(cell(0,5), 'VariableNames', {
        'row',
        'ck', 
        'lk', 
        'dk',
        'requestRunTime'});
    
    runTime = 0;
    
    % read request table
    requestTable = requestTableInput;
           
    % sort requests by user priority and layer
    sortedRequestTable = LLVSsortRequests(requestTable);
    requestTable =  sortedRequestTable;
    
    % run over all requests
    for row = 1:height(requestTable)
         % store start time
        tic
        
        % read request parameters
        [dk,ck,lk,valid,ck_bw,ck_maximumLatency,ck_maximumJitter] = readRequestParameters(G, requestTable , row);                                       
        
        % if the request isn't vaild skip it (Eg. don't supply EL1 if BL is not)
        if( valid ~= 1 )
            continue;
        end
        
        % if request already served - skip it
        selectedPathOfRow = requestTable.selectedPath(row);        
        if(~isempty(selectedPathOfRow{1}))
            continue;
        end
        
        % for each node in tree (ck,lk) update the avialable bw so we don't count
        % it twice if we serve a request on the same links (edges)        
        H = LLVSsetBwOfSckiEdges(G, ck, lk);
        
        % remove edges that don't meet the bandwidth requiremnt
        Htag = removeEdgesBelow( H, ck_bw );
        H = Htag;
        
        % find shortest path from dk to ck in H
       [ path, delta_p, sigma_p ] = lowLatencyPathBetweenNodes( H, ck, dk );
                   
        % check if the path meets the delay and jitter requirements (max
        % threshold and decodable)
        if( LLVSisValidPath(dk, ck, lk, path, delta_p, sigma_p) )
            
            % find intersection point
            newBranch = LLVSfindIntersection(G, ck, lk, path);
            
            % add found paths to request table                        
            newRequestTable = addToRequestTable(requestTable, row, G, {newBranch}, path);
            requestTable = newRequestTable;
            
            % update the relevant tree in G with p            
            newG = updateAvialableBW(G, treeIndex(ck, lk), newBranch, ck_bw);
            G = newG;

        else % no path found
            
        end                   
                        
        % calc run time in [s]        
        requestRunTime=toc;
        runTime = runTime + requestRunTime;
        
        detailsRow = {row, ck, lk, dk, requestRunTime};
        details = [details ; detailsRow];
        
    end

    resultsRow = {G, requestTable, runTime, details};
    results = [results ; resultsRow];
    %plotAllTrees( G, requestTable );
end