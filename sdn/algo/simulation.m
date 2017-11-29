function [ G, requestTable ] = simulation( G )
    
    % T=0, Generate network, run LBSLS#1
    
    % T=1, Add request
    
    % T=2, Network Failure
    
    % T=3, Background Traffic
    
    [ G, requestTable ] = lbs(G);
    plotAllTrees( G , requestTable );

end