function [ G ] = buildGridNetworkRouters(N, parameters)
    
    A = zeros(N);
    
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            A(i,j) = N*(i-1)+j;
        end
    end
    
    s = [];
    t = [];
    
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            
            % up
            if( i > 1 )
                s = [s A(i,j)];
                t = [t A(i-1,j)];
            end
            
            % down
            if( i < N )
                s = [s A(i,j)];
                t = [t A(i+1,j)];
            end
            
            % left
            if( j > 1)
                s = [s A(i,j)];
                t = [t A(i,j-1)];
            end
            
            % right
            if( j < N)
                s = [s A(i,j)];
                t = [t A(i,j+1)];
            end
            
        end
    end
    
    %*********** network parameters*************
    minNumOfRouters = parameters('minNumOfRouters');  
    maxNumOfRouters = parameters('maxNumOfRouters');  
    minBw = parameters('minBw');  
    maxBw = parameters('maxBw');  
    minLatency = parameters('minLatency');  
    maxLatency = parameters('maxLatency');  
    minJitter = parameters('minJitter');  
    maxJitter = parameters('maxJitter');  
    
    % ******** add routers and links *****************
    
    % number of routers and links
    numOfRouters = randi([minNumOfRouters maxNumOfRouters],1,1);  
    numOfEdges = size(s,2);
   
    bw = randi([minBw maxBw],1,numOfEdges)';
    latency = randi([minLatency maxLatency],1,numOfEdges)';
    jitter = randi([minJitter maxJitter],1,numOfEdges)';
            
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
   
    % build graph from edge table
    G = digraph(EdgeTable);
    
    % add nodes types - 'router'
    types = cell(numOfRouters,1);
    types(:) = {'router'};
    G.Nodes.types = types;
    
end