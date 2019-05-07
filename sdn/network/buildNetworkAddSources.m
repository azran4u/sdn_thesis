function [ G ] = buildNetworkAddSources(G, parameters)
    
    %*********** network parameters*************
    minNumOfRouters = parameters('minNumOfRouters');  
    maxNumOfRouters = parameters('maxNumOfRouters');  
    minEdgeRoutersRatio = parameters('minEdgeRoutersRatio');  
    maxEdgeRoutersRatio = parameters('maxEdgeRoutersRatio');  
    minBw = parameters('minBw');  
    maxBw = parameters('maxBw');  
    minLatency = parameters('minLatency');  
    maxLatency = parameters('maxLatency');  
    minJitter = parameters('minJitter');  
    maxJitter = parameters('maxJitter');  
    minNumOfSources = parameters('minNumOfSources');  
    maxNumOfSources = parameters('maxNumOfSources');  
    contentSourceRatio = parameters('contentSourceRatio');  
    contentMinAcceptedLatency = parameters('contentMinAcceptedLatency');  
    contentMaxAcceptedLatency = parameters('contentMaxAcceptedLatency');  
    contentMinAcceptedJitter = parameters('contentMinAcceptedJitter');  
    contentMaxAcceptedJitter = parameters('contentMaxAcceptedJitter');  
    baseLayerMaxBW = parameters('baseLayerMaxBW');  
    baseLayerMinBW = parameters('baseLayerMinBW');  
    baseLayerIntervalBW = parameters('baseLayerIntervalBW');  
    enhancementLayer1MaxBW = parameters('enhancementLayer1MaxBW');  
    enhancementLayer1MinBW = parameters('enhancementLayer1MinBW');  
    enhancementLayer1IntervalBW = parameters('enhancementLayer1IntervalBW');  
    enhancementLayer2MaxBW = parameters('enhancementLayer2MaxBW');  
    enhancementLayer2MinBW = parameters('enhancementLayer2MinBW');  
    enhancementLayer2IntervalBW = parameters('enhancementLayer2IntervalBW');  
    numOfTotalLayersPerContent = parameters('numOfTotalLayersPerContent');  
    numOfActiveLayersPerContent = parameters('numOfActiveLayersPerContent');   

    numOfRouters = randi([minNumOfRouters maxNumOfRouters],1,1);  

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
    
    % add for each content it's priority (Critical=1, Regular=2, Low = 3) 
    numOfNodes = size(G.Nodes,1); 
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




    
    

   
    
    

    






