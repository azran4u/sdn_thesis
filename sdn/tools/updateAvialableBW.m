function R = updateAvialableBW(G, index, path, bw)
% update G
        pred = 0;
        for v = path
            
            % add nodes to G.Nodes.usedFor
            G.Nodes.usedFor(v,index) = 1;
            
            %update graph available bw
            if (pred ~= 0)    
                edge = findedge(G,pred,v);
                G.Edges.bw(edge) = G.Edges.bw(edge) - bw;
                G.Edges.usedFor(edge, index) = 1;
            end 
            
            % set pred to v after the first node is met
            pred = v;
            
        end
        R=G;
end