function [ requests ] = findInServiceELWeCanSwitchOutForBL( G,requestTable, path, pathBW )

    % find all served EL's
    query = requestTable.layer>0 & requestTable.selectedPathLatency~=0;
    ElServed = requestTable(query,:);

    % if we found nothing - return
    if ( size(ElServed,1) == 0 )
        requests = [];
        return;
    end

    for k=1:length(ElServed)
        ElToRemove = ElServed{k};
        [newG, newRequestTable] = removeServedRequest(G, requestTable, ElToRemove);
        [delay, jitter] = checkIfPathIsFeasible(newG, path, pathBW);
    end
end

