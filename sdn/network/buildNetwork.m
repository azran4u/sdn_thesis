% build network by parameters
function [ G ] = buildNetwork( )

    % network parameters
    minNumOfRouters = 10;    
    maxNumOfRouters = 10;
    minEdgeRoutersRatio = 2;
    maxEdgeRoutersRatio = 4;
    minBw = 3;
    maxBw = 10;
    minLatency = 5;
    maxLatency = 50;
    minJitter = 1;
    maxJitter = 5;
    minNumOfSources = 5;
    contentSourceRatio = 1;
    rcvContentRatio = 2;
    contentMinAcceptedLatency = 500;
    contentMaxAcceptedLatency = 1000;
    contentMinAcceptedJitter = 500;
    contentMaxAcceptedJitter = 1000;
    maxLayer = 2; % Base layer (=0), Enhancement layer 1, Enhanacement layer 2.
    baseLayerMaxBW = 2;
    baseLayerMinBW = 2;
    baseLayerIntervalBW = 0.5;
    enhancementLayer1MaxBW = 1;
    enhancementLayer1MinBW = 1;
    enhancementLayer1IntervalBW = 0.5;
    enhancementLayer2MaxBW = 1;
    enhancementLayer2MinBW = 1;
    enhancementLayer2IntervalBW = 0.5;
    numOfLayersPerContent = 3;
    
    % number of routers
    numOfRouters = randi([minNumOfRouters maxNumOfRouters],1,1);  
    edgeRoutersRatio = randi([minEdgeRoutersRatio maxEdgeRoutersRatio],1,1);
    
    % prevents multiple edges between same routers
    if ( edgeRoutersRatio >= numOfRouters)
        edgeRoutersRatio = numOfRouters-1;
    end
    
    numOfEdges = numOfRouters * edgeRoutersRatio;
   
    % input validation
    if( edgeRoutersRatio > numOfRouters )
        disp(['BuildNetwork : Input Error. edgeRoutersRatio (', num2str(edgeRoutersRatio),') is greater than  numOfRouters (',num2str(numOfRouters),')']);
    	exit;
    end
        
    % build edges
    s = [];
    t = [];
    for i=1:numOfRouters
        range = [1:numOfRouters];
        range = range(range~=i);        
        links = randsample(range,edgeRoutersRatio);
        s = [s repmat(i,1,edgeRoutersRatio)];
        t = [t links];
    end
   
    bw = randi([1 maxBw],1,numOfEdges)';
    latency = randi([1 maxLatency],1,numOfEdges)';
    jitter = randi([1 maxJitter],1,numOfEdges)';
            
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
   
    % build graph from edge table
    G = digraph(EdgeTable);
    
    % add nodes types - 'router'
    types = cell(numOfRouters,1);
    types(:) = {'router'};
    G.Nodes.types = types;
    
    % ******** add sources *****************
    maxNumOfSources = numOfRouters;
    numOfSources = randi([minNumOfSources,maxNumOfSources],1,1);
    
    %maxNumOfSources = min(minNumOfSources,maxNumOfRouters);
    %numOfSources = 1+round(rand(1)*maxNumOfSources);
        
    % each source is connected to one router only. same router may serve
    % multiple sources
    range = [1:numOfRouters];
    firstHopRouetrs = randsample(range,numOfSources, true);
    s = [(numOfRouters+1):(numOfRouters+numOfSources)];
    t = [firstHopRouetrs];
    
    % set links properties
    bw = randi([1 maxBw],1,numOfSources)';
    latency = randi([1 maxLatency],1,numOfSources)';
    jitter = randi([1 maxJitter],1,numOfSources)';
            
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
    
    % create t vector with each source multiple tymes (= as
    % contentSourceRatio)
    t = repmat(sourceNodes, contentSourceRatio, 1)';
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
    numOfRcv = numOfContents * rcvContentRatio;
    
    % each reciever is connected to one router. same router may serve
    % multiple recievers
    routerNodes = find(strcmp('router',G.Nodes.types));
    lastHopRoueters = randsample(routerNodes,numOfRcv, true)';
    s = [lastHopRoueters];    
    t = [numnodes(G)+1:numnodes(G)+numOfRcv];
   
    % set links properties
    bw = randi([1 maxBw],1,numOfRcv)';
    latency = randi([1 maxLatency],1,numOfRcv)';
    jitter = randi([1 maxJitter],1,numOfRcv)';
    
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
    %recieverPriority(recieverNodes) = randsample([1:1:3],numOfRcv, true);
    %G.Nodes.recieverPriority = recieverPriority;
       
    s = RandStream.getGlobalStream;
    recieverPriority(recieverNodes) = datasample(s,[0:1:3],numOfRcv,'Weights',[0.4 0.2 0.2 0.2]);
    G.Nodes.recieverPriority = recieverPriority;

    
    % add for each reciever the requested content (only one) 
    requestedContent = zeros(numOfNodes,1);
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    
    % handel the case which contentNodes is only one integer
    requestedContent(recieverNodes) = contentNodes(randsample(length(contentNodes),numOfRcv, true));
    
    G.Nodes.requestedContent = requestedContent;
    
    % add for each reciever the requested layer (max)
    requestedLayer = zeros(numOfNodes,1);
    requestedLayer(recieverNodes) = randsample([0:maxLayer],numOfRcv, true);    
    G.Nodes.requestedLayer = requestedLayer;

    % add for each content it's priority (Critical=1, Regular=2, Low = 3) 
    contentPriority = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    contentPriority(contentNodes) = randsample([1:1:3],numOfContents, true);
    G.Nodes.contentPriority = contentPriority;
    
    % add for each content it's maximum accepted latency
    contentMaximumLatency = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    contentMaximumLatency(contentNodes) = randsample([contentMinAcceptedLatency:1:contentMaxAcceptedLatency],numOfContents, true);
    G.Nodes.contentMaximumLatency = contentMaximumLatency;

    % add for each content it's maximum accepted jitter
    contentMaximumJitter = zeros(numOfNodes,1);
    contentNodes = find(strcmp('content',G.Nodes.types));
    contentMaximumJitter(contentNodes) = randsample([contentMinAcceptedJitter:1:contentMaxAcceptedJitter],numOfContents, true);
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
    G.Nodes.treeLatency = ones(G.numnodes,numOfContents*numOfLayersPerContent)*inf;
    G.Nodes.treeJitter = ones(G.numnodes,numOfContents*numOfLayersPerContent)*inf;
    G.Edges.treeUsed = ones(G.numedges,numOfContents*numOfLayersPerContent)*inf;
    
    % build distribution tree for each (content,layer) pair
     setGlobal_firstContent( contentNodes(1) );
            
    % run over all content nodes
    for content = contentNodes'
     
        % run over each layer
        for layer = 0:(getGlobal_numOfLayersPerContent() - 1)
            
            % calculate the index of the (content, layer) tree
            index = treeIndex(content , layer);
            
            % set the value to '0' becuase the content node is always part of every layer with latency/jitter zero 
            G.Nodes.treeLatency(content, index) = 0;
            G.Nodes.treeJitter(content, index) = 0;
            
        end
        
    end
    
end



