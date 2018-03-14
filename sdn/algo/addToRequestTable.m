function [ requestTableUpdated ] = addToRequestTable( requestTable, row, G, P, path )

    requestTableUpdated = requestTable;
    table = pathsToTable( G, P );
    requestTableUpdated.allPathsFound(row) = {P};
    requestTableUpdated.allPathsFoundLatencies(row) = {table.latency};
    requestTableUpdated.allPathsFoundJitters(row) = {table.jitter};
    requestTableUpdated.selectedPath(row) = {path};
    requestTableUpdated.selectedPathLatency(row) = pathLatency(G, path);
    requestTableUpdated.selectedPathJitter(row) = pathJitter(G, path);
    
end

