function R = updateAvialableBW(G, index, path, bw)
% update G
        pred = 0;
        
        % path(1) is the node which the path joins the tree
        latency = G.Nodes.treeLatency(path(1),index);
        jitter = G.Nodes.treeJitter(path(1),index);
        
        for v = path
            
            if (pred ~= 0)    

                %update graph available bw
                edge = findedge(G,pred,v);
                
                latency = latency + G.Edges.latency(edge);
                jitter = jitter + G.Edges.jitter(edge);
                
                % update bandwidth
                G.Edges.bw(edge) = G.Edges.bw(edge) - bw;
                
                % set edge as used in tree index
                G.Edges.treeUsed(edge, index) = 1;
                
            end 
            
            % set G.Nodes.treeLatency to the actual latency
            G.Nodes.treeLatency(v,index) = latency;
            G.Nodes.treeJitter(v,index) =  jitter;
            
            % set pred to v after the first node is met
            pred = v;
            
        end
        R=G;
end