function [ G ] = buildGridNetwork( )

    row = 8;
    
    A = zeros(row);
    
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            A(i,j) = row*(i-1)+j;
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
            if( i < row )
                s = [s A(i,j)];
                t = [t A(i+1,j)];
            end
            
            % left
            if( j > 1)
                s = [s A(i,j)];
                t = [t A(i,j-1)];
            end
            
            % right
            if( j < row)
                s = [s A(i,j)];
                t = [t A(i,j+1)];
            end
            
        end
    end
    
    minBw = 2;
    maxBw = 10;
    
    minLatency = 5;
    maxLatency = 100;
    
    minJitter = 1;
    maxJitter = 5;
   
    numOfEdges = size(s,2);
   
    bw = randi([minBw maxBw],1,numOfEdges)';
    latency = randi([minLatency maxLatency],1,numOfEdges)';
    jitter = randi([minJitter maxJitter],1,numOfEdges)';
          
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
   
    % build graph from edge table
    G = digraph(EdgeTable);
    
    figure;   
    h = plot(G,'EdgeLabel',G.Edges.bw);
       
    % add nodes types - 'router'
    numOfRouters = row*row;
    types = cell(numOfRouters,1);
    types(:) = {'router'};
    G.Nodes.types = types;
    
    
    
    % ******** add sources *****************
    s = [1 5];
    numOfSources = size(s,2);    
    t = [(numOfRouters+1):(numOfRouters+numOfSources)];
    
    % set links properties
    bw = repmat([inf], numOfSources, 1);
    latency = repmat([0], numOfSources, 1);
    jitter = repmat([0], numOfSources, 1);
    
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    G = addedge(G, EdgeTable);
    
    % set type as 'source'
    types = cell( numOfSources ,1);
    types(:) = {'source'};
    G.Nodes.types((numOfRouters+1):(numOfRouters+numOfSources)) = types;
    
end



