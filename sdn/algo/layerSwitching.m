% implementation of LBSLS algorithm
function [ G, requestTable ] = layerSwitching(G, requestTable, ck, dk, lk)

        return;
        
        % find maximum bandwidth path in G
        for v = scki'

            % find shortest latency path in G (original network)
            [ path, delta_p, sigma_p ] = maxBWPathBetweenNodes( G, v, dk );

            % add latency and jitter fron v to source
            delta_p = delta_p + nodeLatencyInTree(G, v, ck, lk);
            sigma_p = sigma_p + nodeJitterInTree(G, v, ck, lk);

            % check if the path meets the delay and jitter requirements
            if( (delta_p < ck_maximumLatency) &&  (sigma_p < ck_maximumJitter) )           
                P = [P; {path}];
            end

        end

        % we found more than one path
        if( ~isempty(P) )

            for k=1:length(P)
                path=P{k};
                requests = findInServiceELWeCanSwitchOutForBL(G,requestTable, path, ck_bw);
            end

            % select one path from P

            % if we can remove EL for this BL - do it and remove upper
            % layers

            % if we couldnt find any EL that can help this BL -
            % invalidate upper layers                              

        % if we couldnt serve EL
        else

            % invalidate upper layers

        end         
end

