function [ G ] = buildWanNetwork( )

    % network parameters
    minNumOfRouters = 10;    
    maxNumOfRouters = 10;
    numOfRouters = randi([minNumOfRouters maxNumOfRouters],1,1);
    disp(['numOfRouters: ', num2str(numOfRouters)]);
    
    minEdgeRoutersRatio = 3;
    maxEdgeRoutersRatio = 3;
    edgeRoutersRatio = randi([minEdgeRoutersRatio maxEdgeRoutersRatio],1,1);
    
    % prevents 
    if edgeRoutersRatio > numOfRouters
        edgeRoutersRatio = numOfRouters-1;
    end
    disp(['edgeRoutersRatio: ', num2str(edgeRoutersRatio)]);
    
    minBw = 100;
    maxBw = 100;
    
    minLatency = 150;
    maxLatency = 150;
    
    minJitter = 25;
    maxJitter = 25;
    
    %numOfRouters = 1+round(rand(1)*maxNumOfRouters);
    
    %edgeRoutersRatio = max(2+round(rand(1)*maxEdgeRoutersRatio), numOfRouters-1);
    numOfEdges = numOfRouters * edgeRoutersRatio;
   
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
    maxNumOfSources = maxNumOfRouters;
    numOfSources = 1+round(rand(1)*maxNumOfSources);
        
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
    
    % plot the routers and sources
    figure(1);   
    h = plot(G,'EdgeLabel',G.Edges.bw);
    highlight(h,find(strcmp('source',G.Nodes.types)),'NodeColor','g');
    highlight(h,find(strcmp('router',G.Nodes.types)),'NodeColor','r');
    title(['num of sources', num2str(numOfSources)]);
    
    % ********** add contents **************
    contentSourceRatio = 2;
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
    rcvContentRatio = 3;
    contentNodes = find(strcmp('content',G.Nodes.types));
    numOfContents = size(contentNodes, 1);
    numOfRcv = numOfContents * rcvContentRatio;
    
    % each reciever is connected to one router. same router may serve
    % multiple recievers
    routerNodes = find(strcmp('router',G.Nodes.types));
    lastHopRouetrs = randsample(routerNodes,numOfRcv, true)';
    s = [lastHopRouetrs];    
    t = [numnodes(G)+1:numnodes(G)+numOfRcv];
   
    % set links properties
    bw = randi([1 maxBw],1,numOfRcv)';
    latency = randi([1 maxLatency],1,numOfRcv)';
    jitter = randi([1 maxJitter],1,numOfRcv)';
    
    % add to graph
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    G = addedge(G, EdgeTable);
    
    % set type as 'content'
    types = cell( numOfRcv ,1);
    types(:) = {'reciever'};
    G.Nodes.types(t) = types;
    
    % plot the routers and sources
    figure(1);   
    h = plot(G,'EdgeLabel',G.Edges.bw);
    highlight(h,find(strcmp('source',G.Nodes.types)),'NodeColor','g');
    highlight(h,find(strcmp('router',G.Nodes.types)),'NodeColor','r');
    highlight(h,find(strcmp('content',G.Nodes.types)),'NodeColor','b');
    highlight(h,find(strcmp('reciever',G.Nodes.types)),'NodeColor','y');
    title(['num of rcv: ', num2str(numOfRcv)],'Color', 'y');    

end

