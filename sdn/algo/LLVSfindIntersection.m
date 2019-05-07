function [newBranch] = LLVSfindIntersection(G, ck, lk, path)
    
    index = treeIndex(ck , lk);    
    prevNode = 0;    
    pathLen=size(path,2);
    newBranch = [];
    for i = 1:pathLen                
        node = path(i);
        if G.Nodes.treeLatency(node,index) == inf
            newBranch = [prevNode path(i:pathLen)];    
            return;
        end        
        prevNode = node;       
    end
    disp('weired');
end
