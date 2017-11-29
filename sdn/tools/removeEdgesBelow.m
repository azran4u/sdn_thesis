function H = removeEdgesBelow( G, bw)
        % remove links that don't have enought bandwidth       
        % find indexes edges that don't have enought bw
        r = ( G.Edges.bw < bw ) .* [1:numedges(G)]';
        
        % removes zeros (indexes that do meet the bw requierment)
        r = r(r~=0);
        
        % remove edges that don't meet the bw requierment
        H = rmedge(G,r);
end
