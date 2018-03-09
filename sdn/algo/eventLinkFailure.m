function newG = eventLinkFailure(G)
    
    N = numedges(G);
    idx = randi([1 N],1,1);
    newG = rmedge(G,idx);

end