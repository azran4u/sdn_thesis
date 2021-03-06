% implementation of LBSLS algorithm
%function [ G, requestTable, runTime, details ] = lbsls( G, requestTableInput )
function [ results ] = lbs( G, requestTableInput )
   
   
    results = cell2table(cell(0,4), 'VariableNames', {
        'G', 
        'requestTable', 
        'runTime',        
        'details'});

    details = cell2table(cell(0,6), 'VariableNames', {
        'ck', 
        'lk', 
        'dk',
        'scki', 
        'P',
        'requestRunTime'});
    
    runTime = 0;
    
    % read request table
    requestTable = requestTableInput;
           
    % sort requests by layer
    requestTable = sortrows(requestTable,{'layer'},{'ascend'});
     
    % run over all requests, base layer first, EL1 second, and so on.
    for row = 1:height(requestTable)
         % store start time
        tic
        
        msg = ['t0 = 0 : start timer for request = ', num2str(row)];
%         disp(msg); 
        
        [dk,ck,lk,valid,ck_bw,ck_maximumLatency,ck_maximumJitter] = readRequestParameters(G, requestTable , row);                                       
        
        t1 = toc;
        t1d = t1 - 0;
        msg = ['t1 = ', num2str(t1d), ' : readRequestParameters'];
%         disp(msg); 
       
        % if the request isn't vaild skip it (Eg. don't supply EL1 if BL is not)
        if( valid ~= 1 )
            continue;
        end
        
        % if request already served - skip it
        selectedPathOfRow = requestTable.selectedPath(row);        
        if(~isempty(selectedPathOfRow{1}))
            continue;
        end
        
        % P holds all possible paths
        P = cell(0);
        %P = [];
        
        % remove edges that don't meet the bandwidth requiremnt
        H = removeEdgesBelow( G, ck_bw );
        
        t2 = toc;
        t2d = t2-t1;
        msg = ['t2 = ', num2str(t2d), ' : removeEdgesBelow'];
%         disp(msg); 
        
        % get all nodes that are part of (content,layer)
        scki = getTreeNodes(G, ck , lk);
        
        t3 = toc;
        t3d = t3-t2;
        msg = ['t3 = ', num2str(t3d), ' : getTreeNodes'];
%         disp(msg); 
        
        for v = scki'
            
            % find shortest latency path in H
            [ path, delta_p, sigma_p ] = lowLatencyPathBetweenNodes( H, v, dk );                    
        
            % add latency and jitter fron v to source
            totalDeltaP = delta_p;% + nodeLatencyInTree(H, v, ck, lk);
            totalSigmaP = sigma_p;% + nodeJitterInTree(H, v, ck, lk);
            
            % check if the path meets the delay and jitter requirements
            if( (totalDeltaP < ck_maximumLatency) &&  (totalSigmaP < ck_maximumJitter) )           
                P = [P; {path} delta_p sigma_p];
            end
                
        end
        
        t4 = toc;
        t4d = t4-t3;
        msg = ['t4 = ', num2str(t4d), ' : runOverAllShortestPathsToSCKI'];
%         disp(msg); 
            
        % we found more than one path
        if( ~isempty(P) )
            
            % select one path from P
            path = lbsPathSelectionAlgorithm(H, P);
               
            t5 = toc;
            t5d = t5-t4;
            msg = ['t5 = ', num2str(t5d), ' : lbsPathSelectionAlgorithm'];
%             disp(msg); 
            
            % serve path
            [newG, newRequestTable] = servePath(requestTable, row, G, P(:,1), path, ck, lk, ck_bw);
            G = newG;
            requestTable = newRequestTable;
            
            t6 = toc;
            t6d = t6-t5;
            msg = ['t6 = ', num2str(t6d), ' : servePath'];
%             disp(msg); 
        
        % we couldnt find any path
        else

            % if BL could not be served
            if( lk == 0 )
                
                % invalidate current request and upper layers                
                query=requestTable.reciever==dk & requestTable.content==ck;
                indices=[1:size(query,1)]'.*query;
                indices(indices==0) = [];
                requestTable.valid(indices) = 0;
                
                layerSwitching(G, requestTable, ck, dk, lk);                              
            
                t6 = toc;
                t6d = t6-t4;
                msg = ['t6 = ', num2str(t6d), ' : layerSwitching'];
%                 disp(msg); 
            end
            
        end       
        
        % re validate all request in the request table
        query=requestTable.valid==0;
        indices=[1:size(query,1)]'.*query;
        indices(indices==0) = [];
        requestTable.valid(indices) = 1;
  
        t7 = toc;
        t7d = t7-t6;
        msg = ['t7 = ', num2str(t7d), ' : revalidate all request in the request table'];
%         disp(msg); 
        
        % calc run time in [s]        
        requestRunTime=t4d+t5d;
        msg = ['requestRunTime = ', num2str(requestRunTime)];
%         disp(msg); 
        
        runTime = runTime + requestRunTime;
        
        detailsRow = {ck, lk, dk, size(scki,1), size(P,1), requestRunTime};
        details = [details ; detailsRow];
        
        %msg = ['LBSLS: ck= ', num2str(ck), ' lk= ', num2str(lk), ' dk= ', num2str(dk), ' sckiSize= ', num2str(size(scki,1)), ' Psize= ', num2str(size(P,1)), ' requestRunTime= ', num2str(requestRunTime)];
        %disp(msg);
                
    end
    
    resultsRow = {G, requestTable, runTime, details};
    results = [results ; resultsRow];
    
end