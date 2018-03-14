function [GUpdated, requestTableUpdated] = servePath( requestTable, row, G, P, path, ck, lk, ck_bw )

    % add found paths to request table                        
    requestTableUpdated = addToRequestTable(requestTable, row, G, P, path);
    
    % update the relevant tree in G with p            
    GUpdated = updateAvialableBW(G, treeIndex(ck, lk), path, ck_bw);

end

