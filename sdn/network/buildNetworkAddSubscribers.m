function [ G ] = buildNetworkAddSubscribers(G, parameters)
    
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

    minNumOfRcvs = parameters('minNumOfRcvs');
    maxNumOfRcvs = parameters('maxNumOfRcvs');
    numOfActiveRcvs = parameters('numOfActiveRcvs');
    rcvContentRatio = parameters('rcvContentRatio');
        
    
        % ************** add recivers *****************    
    contentNodes = find(strcmp('content',G.Nodes.types));
    numOfContents = size(contentNodes, 1);
    numOfRcv = randi([minNumOfRcvs,maxNumOfRcvs],1,1);
    
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
    treeUsed = repmat([inf], numOfRcv, numOfContents * numOfTotalLayersPerContent);
    
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, treeUsed, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter', 'treeUsed'});
    G = addedge(G, EdgeTable);
    
    % set type as 'reciever'
    types = cell( numOfRcv ,1);
    types(:) = {'reciever'};
    G.Nodes.types(t) = types;

    % set latency and jitter for all trees to be infinity
    G.Nodes.treeLatency(t,:) = inf;
    G.Nodes.treeJitter(t,:) = inf;
    
    % add for each reciever the priority (Gold=1, Silver=2, Bronze = 3, NA=0) 
    numOfNodes = size(G.Nodes,1);    
    recieverPriority = zeros(numOfNodes,1);
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    recieverPriority(recieverNodes) = randsample([1:1:3],numOfRcv, true);
    G.Nodes.recieverPriority = recieverPriority;
  
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
    
end




    
    

   
    
    

    






