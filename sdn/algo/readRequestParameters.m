% implementation of LBSLS algorithm
function [dk,ck,lk,valid,ck_bw,ck_maximumLatency,ck_maximumJitter] = readRequestParameters( G, requestTable, row)

    % get request parameters
        gama_k_i = requestTable(row, :);
        
        % extract values from request
        dk = gama_k_i.reciever;
        ck = gama_k_i.content;
        lk = gama_k_i.layer;
        valid = gama_k_i.valid;
        ck_bw = gama_k_i.bw;
        ck_maximumLatency = G.Nodes.contentMaximumLatency(ck); % content's maximum accepted latency. set by admin, not the client
        ck_maximumJitter = G.Nodes.contentMaximumJitter(ck);  % content's maximum accepted jitter. set by admin, not the client
        
end

    