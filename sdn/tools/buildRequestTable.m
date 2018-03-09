function [T] = buildRequestTable(G)
    
    % create all requests and store them in a table format
    T = cell2table(cell(0,14), 'VariableNames', {
        'reciever', 
        'recieverPriority', 
        'content', 
        'contentPriority', 
        'layer', 
        'valid', 
        'bw', 
        'duration', 
        'allPathsFound', 
        'allPathsFoundLatencies', 
        'allPathsFoundJitters', 
        'selectedPath', 
        'selectedPathLatency', 
        'selectedPathJitter'});

    % find all recierver nodes
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    numOfRcv = size(recieverNodes, 1);
    
    % set default values
    duration = 1; % for how long the request is valid
    valid = 1;
    allPathsFound = {}; % holds all the paths found for a given request
    allPathsFoundLatencies = []; % hold the latency of each above paths
    allPathsFoundJitters = []; % hold the jitter of each above paths
    selectedPath = []; % the selected path
    selectedPathLatency = 0; % the selected path latency
    selectedPathJitter = 0; % the selected path jitter
    
    % run over each reciever node and read request parameters
    for dk = recieverNodes' % 'd' for destination, 'k' for request number
        ck = G.Nodes.requestedContent(dk); % 'c' for content
        ck_priority = G.Nodes.contentPriority(ck); % the content's importance. set by network admin not by client. higher priority is better
        rcvPriority = G.Nodes.recieverPriority(dk); % the client priority, set by network admin not by client. higher priority is better
        maxLayer = G.Nodes.requestedLayer(dk); % the client sets the sufficient layer. above layers won't be delieverd even if there are available resources.
        
        % for each layer, starting from BASE to max - build a seperate request
        for lk = [0:1:maxLayer]
            
            % set the content's bandwidth by the layer
            if lk == 0
                ck_bw = G.Nodes.baseLayerBW(ck);
            elseif lk == 1
                ck_bw = G.Nodes.enhancementLayer1BW(ck);
            elseif lk ==2
                ck_bw = G.Nodes.enhancementLayer2BW(ck);
            end
                         
            % add request to table
            
            rcvCell = {dk, rcvPriority, ck, ck_priority, lk, valid, ck_bw, duration, allPathsFound, allPathsFoundLatencies, allPathsFoundJitters, selectedPath, selectedPathLatency, selectedPathJitter};
            T = [T ; rcvCell];
            
        end
    end
end
