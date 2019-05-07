function [ G ] = buildGridNetwork(N, InputNumOfRcv)
    
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
    minNumOfRouters = N*N;    
    maxNumOfRouters = N*N;
    %minEdgeRoutersRatio = 2;
    %maxEdgeRoutersRatio = 4;
    minBw = 60;
    maxBw = 120;
    minLatency = 2;
    maxLatency = 6;
    minJitter = 0;
    maxJitter = 0;
    minNumOfSources = 8;
    maxNumOfSources = 8;
    minNumOfRcvs = InputNumOfRcv;
    maxNumOfRcvs = InputNumOfRcv;
    numOfActiveRcvs = InputNumOfRcv;
    contentSourceRatio = 100/8;
    rcvContentRatio = 2;
    contentMinAcceptedLatency = 0;
    contentMaxAcceptedLatency = 130;
    contentMinAcceptedJitter = 0;
    contentMaxAcceptedJitter = 30;
    baseLayerMaxBW = 3;
    baseLayerMinBW = 1;
    baseLayerIntervalBW = 1;
    enhancementLayer1MaxBW = 6;
    enhancementLayer1MinBW = 4;
    enhancementLayer1IntervalBW = 1;
    enhancementLayer2MaxBW = 8;
    enhancementLayer2MinBW = 6;
    enhancementLayer2IntervalBW = 1;
    numOfTotalLayersPerContent = getGlobal_numOfLayersPerContent(); % Base layer (=0), Enhancement layer 1 (=1), Enhanacement layer 2 (=2).
    numOfActiveLayersPerContent = 2; % layers for rcv's
    
    
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
            
    % ******** add sources *****************
    numOfSources = randi([minNumOfSources,maxNumOfSources],1,1);
        
    % each source is connected to one router only. same router may serve
    % multiple sources
    range = [1:numOfRouters];
    firstHopRouetrs = randsample(range,numOfSources, true);
    s = [(numOfRouters+1):(numOfRouters+numOfSources)];
    t = [firstHopRouetrs];
    
    % set links properties
    bw = randi([minBw maxBw],1,numOfSources)';
    latency = randi([minLatency maxLatency],1,numOfSources)';
    jitter = randi([minJitter maxJitter],1,numOfSources)';
            
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    G = addedge(G, EdgeTable);
    
    % set type as 'source'
    types = cell( numOfSources ,1);
    types(:) = {'source'};
    G.Nodes.types((numOfRouters+1):(numOfRouters+numOfSources)) = types;
    
        % ********** add contents **************
    sourceNodes = find(strcmp('source',G.Nodes.types));
    numOfSources = size(sourceNodes, 1);
    numOfContents = numOfSources * contentSourceRatio;
    
    % create t vector with each source multiple times (= as
    % contentSourceRatio)
    %t = repmat(sourceNodes, contentSourceRatio, 1)';
    t = randsample(sourceNodes,numOfContents, true)';
    s = [numnodes(G)+1:numnodes(G)+numOfContents];
    
    % set links properties
    bw = repmat([inf], numOfContents, 1);
    latency = repmat([0], numOfContents, 1);
    jitter = repmat([0], numOfContents, 1);
    
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    G = addedge(G, EdgeTable);
    
    % set type as 'content'
    types = cell( numOfContents ,1);
    types(:) = {'content'};
    G.Nodes.types(s) = types; 
    
    % ************** add recivers *****************    
    contentNodes = find(strcmp('content',G.Nodes.types));
    numOfContents = size(contentNodes, 1);
    numOfRcv = randi([minNumOfRcvs,maxNumOfRcvs],1,1);
    %numOfRcv = InputNumOfRcv;
    %numOfRcv = numOfContents * rcvContentRatio;
    
    % each reciever is connected to one router. same router may serve
    % multiple recievers
    routerNodes = find(strcmp('router',G.Nodes.types));
    lastHopRouters = randsample(routerNodes,numOfRcv, false)';
    s = [lastHopRouters];    
    t = [numnodes(G)+1:numnodes(G)+numOfRcv];
   
    % set links properties    
    bw = repmat([inf], numOfRcv, 1);
    latency = repmat([0], numOfRcv, 1);
    jitter = repmat([0], numOfRcv, 1);
    
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    G = addedge(G, EdgeTable);
    
    % set type as 'reciever'
    types = cell( numOfRcv ,1);
    types(:) = {'reciever'};
    G.Nodes.types(t) = types;

    % add for each reciever the priority (Gold=1, Silver=2, Bronze = 3, NA=0) 
    numOfNodes = size(G.Nodes,1);    
    recieverPriority = zeros(numOfNodes,1);
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    recieverPriority(recieverNodes) = randsample([1:1:3],numOfRcv, true);
    G.Nodes.recieverPriority = recieverPriority;
       
%     s = RandStream.getGlobalStream;
%     activeRcvs = randsample(recieverNodes,numOfActiveRcvs, false)';
%     recieverPriority(activeRcvs) = 1;
%     %recieverPriority(recieverNodes) = datasample(s,[1:1:3],numOfRcv,'Weights',[1/3 1/3 1/3]);
%     G.Nodes.recieverPriority = recieverPriority;

    
    % add for each reciever the requested content (only one) 
    requestedContent = zeros(numOfNodes,1);
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    
    % handel the case which contentNodes is only one integer
    requestedContent(recieverNodes) = contentNodes(randsample(length(contentNodes),numOfRcv, true));
    
    G.Nodes.requestedContent = requestedContent;
    
    % add for each reciever the requested layer (max)
    requestedLayer = zeros(numOfNodes,1);
    requestedLayer(recieverNodes) = repmat([numOfActiveLayersPerContent], numOfRcv, 1);   
    G.Nodes.requestedLayer = requestedLayer;

    % add for each content it's priority (Critical=1, Regular=2, Low = 3) 
    contentPriority = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    contentPriority(contentNodes) = randsample([1:1:3],numOfContents, true);
    G.Nodes.contentPriority = contentPriority;
    
    % add for each content it's maximum accepted latency
    contentMaximumLatency = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));   
    contentMaximumLatency(contentNodes) = repmat([contentMaxAcceptedLatency], numOfContents, 1);  
    %contentMaximumLatency(contentNodes) = randsample([contentMinAcceptedLatency:1:contentMaxAcceptedLatency],contentMaxAcceptedLatency, true);
    G.Nodes.contentMaximumLatency = contentMaximumLatency;

    % add for each content it's maximum accepted jitter
    contentMaximumJitter = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));    
    contentMaximumJitter(contentNodes) = repmat([contentMaxAcceptedJitter], numOfContents, 1);  
    %contentMaximumJitter(contentNodes) = randsample([contentMinAcceptedJitter:1:contentMaxAcceptedJitter],numOfContents, true);
    G.Nodes.contentMaximumJitter = contentMaximumJitter;    
    
    % add for each content the desired bw for base layer 
    baseLayerBW = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    baseLayerBW(contentNodes) = randsample([baseLayerMinBW:baseLayerIntervalBW:baseLayerMaxBW],numOfContents, true);
    G.Nodes.baseLayerBW = baseLayerBW;
    
    % add for each content the desired bw for enhancement layer 1 
    enhancementLayer1BW = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    enhancementLayer1BW(contentNodes) = randsample([enhancementLayer1MinBW:enhancementLayer1IntervalBW:enhancementLayer1MaxBW],numOfContents, true);
    G.Nodes.enhancementLayer1BW = enhancementLayer1BW;
    
    % add for each content the desired bw for enhancement layer 2
    enhancementLayer2BW = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    enhancementLayer2BW(contentNodes) = randsample([enhancementLayer2MinBW:enhancementLayer2IntervalBW:enhancementLayer2MaxBW],numOfContents, true);
    G.Nodes.enhancementLayer2BW = enhancementLayer2BW;
   
    % create new field for each node and edge that represents the usage of the graph element in the tree (content, layer)
    G.Nodes.treeLatency = ones(G.numnodes,numOfContents*getGlobal_numOfLayersPerContent())*inf;
    G.Nodes.treeJitter = ones(G.numnodes,numOfContents*getGlobal_numOfLayersPerContent())*inf;
    G.Edges.treeUsed = ones(G.numedges,numOfContents*getGlobal_numOfLayersPerContent())*inf;
    
    % build distribution tree for each (content,layer) pair
     setGlobal_firstContent( contentNodes(1) );
            
    % run over all content nodes
    for content = contentNodes'
     
        % run over each layer
        for layer = 0:(numOfTotalLayersPerContent)
            
            % calculate the index of the (content, layer) tree
            index = treeIndex(content , layer);
            
            % set the value to '0' becuase the content node is always part of every layer with latency/jitter zero 
            G.Nodes.treeLatency(content, index) = 0;
            G.Nodes.treeJitter(content, index) = 0;
            
        end
        
    end
    
end




    
    

   
    
    

    






