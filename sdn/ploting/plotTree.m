function plotTree( G, requestTable, treeIndex )
     
    % find content
    a = idivide( cast(treeIndex, 'int8') , getGlobal_numOfLayersPerContent() );
    content = getGlobal_firstContent() + a;
    
    % find layer
    b = mod(treeIndex, getGlobal_numOfLayersPerContent() );
    layer = b - 1;
    
    % if treeIndex is a multiple of numOfLayersPerContent
    if( b== 0 )
        content = content -1;
        layer = 2;
    end
    
    % find number of requests to this layer
    allRequests = requestTable.content==content & requestTable.layer==layer;
    allRequests = find( allRequests == 1 );
    numOfRequests = size( allRequests, 1);   
    
    % find number of provided requests to this layer
    providedRequests = requestTable.content==content & requestTable.layer==layer & requestTable.valid==1;
    providedRequests = find( providedRequests == 1 );
    numOfRequestsProvided = size( providedRequests, 1);    
    
    % find bw of (content, layer)
    bw = requestTable.bw( providedRequests(1) );
    
    % remove non relevant recievers nodes from graph
    allRequestsNodes = requestTable.reciever( allRequests );
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    nonRelevantNodes = setdiff(recieverNodes, allRequestsNodes);    
    H=rmnode(G,nonRelevantNodes);
    
    % remove non relevant content nodes from graph
    contentNodes = find(strcmp('content',G.Nodes.types));
    nonRelevantNodes = setdiff(contentNodes, [content]);
    H=rmnode(H,nonRelevantNodes);
    
    % remove non relevant source nodes from graph
    sourceNodes = find(strcmp('source',G.Nodes.types));
    allEdges = G.Edges.EndNodes;      
    nonRelevantNodes = setdiff(sourceNodes, [allEdges( find(allEdges(:,1)==content), 2)]);
    H=rmnode(H,nonRelevantNodes);
    
    % plot the graph
    h = plotNetworkGraph( H );
     
    % set title
    title(['#content = ', num2str(content) ' #layer = ', num2str(layer) ' #bw = ', num2str(bw) ' #requests = ', num2str(numOfRequests) ' #numOfRequestsProvided = ', num2str(numOfRequestsProvided)]);    
    
    % highlight tree's edges
    edges = H.Edges.usedFor(:, treeIndex );
    edges = find(edges==1);
    s = H.Edges.EndNodes(edges,1);
    t = H.Edges.EndNodes(edges,2);
    highlight(h, s, t , 'EdgeColor','r');
    
    % highlight tree's nodes
    nodes = H.Nodes.usedFor(:, treeIndex );
    nodes = find(nodes == 1);
    highlight(h, nodes, 'NodeColor','r');
    
    % highlight tree's recievers that didn't get the content
    recieverNodes = find(strcmp('reciever',H.Nodes.types));
    highlight(h, recieverNodes, 'NodeColor','r');
    
end

