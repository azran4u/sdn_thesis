function newG = eventNodeFailure(G)
    
       
    routerNodes = find(strcmp('router',G.Nodes.types));
    
    N = size(routerNodes,1);
    
    idx = randi([1 N],1,1);
    
    newG = rmnode(G,idx);

end