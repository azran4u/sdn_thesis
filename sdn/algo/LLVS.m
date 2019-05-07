% implementation of LLVS algorithm
%function [ G, requestTable, runTime, details ] = lbsls( G, requestTableInput )
function [ results ] = llvs( G, requestTableInput )

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

        msg = ['t0 = 0 : start timer for request = ', num2str(row)];
%         disp(msg);

        % read request parameters
        [dk,ck,lk,valid,ck_bw,ck_maximumLatency,ck_maximumJitter] = readRequestParameters(G, requestTable , row);

        t1 = toc;
        t1d = t1-0;
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

        % for each node in tree (ck,lk) update the avialable bw so we don't count
        % it twice if we serve a request on the same links (edges)
        H = LLVSsetBwOfSckiEdges(G, ck, lk);

        % remove edges that don't meet the bandwidth requiremnt
        Htag = removeEdgesBelow( H, ck_bw );
        H = Htag;


        t2 = toc;
        t2d = t2-t1;
        msg = ['t2 = ', num2str(t2d), ' : removeEdgesBelow'];
%         disp(msg);

        % find shortest path from dk to ck in H
       [ path, delta_p, sigma_p ] = lowLatencyPathBetweenNodes( H, ck, dk );

       t3 = toc;
       t3d = t3-t2;
       msg = ['t3 = ', num2str(t3d), ' : lowLatencyPathBetweenNodes'];
%        disp(msg);

        % check if the path meets the delay and jitter requirements (max
        % threshold and decodable)
        if( LLVSisValidPath(dk, ck, lk, path, delta_p, sigma_p) )

            t4 = toc;
            t4d = t4-t3;
            msg = ['t4 = ', num2str(t4d), ' : LLVSisValidPath'];
%             disp(msg);

            % find intersection point
            newBranch = LLVSfindIntersection(G, ck, lk, path);

            t5 = toc;
            t5d = t5-t4;
            msg = ['t5 = ', num2str(t5d), ' : LLVSfindIntersection'];
%             disp(msg);

            % add found paths to request table
            newRequestTable = addToRequestTable(requestTable, row, G, {newBranch}, path);
            requestTable = newRequestTable;

            t6 = toc;
            t6d = t6-t5;
            msg = ['t6 = ', num2str(t6d), ' : addToRequestTable'];
%             disp(msg);

            % update the relevant tree in G with p
            newG = updateAvialableBW(G, treeIndex(ck, lk), newBranch, ck_bw);
            G = newG;

            t7 = toc;
            t7d = t7-t6;
            msg = ['t7 = ', num2str(t7d), ' : updateAvialableBW'];
%             disp(msg);

        else % no path found

        end

        % calc run time in [s]
        requestRunTime=t3d+t4d+t5d;
        msg = ['requestRunTime = ', num2str(requestRunTime)];
%         disp(msg);

        runTime = runTime + requestRunTime;

        detailsRow = {row, ck, lk, dk, requestRunTime};
        details = [details ; detailsRow];

    end

    resultsRow = {G, requestTable, runTime, details};
    results = [results ; resultsRow];

end
