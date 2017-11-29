function [T] = buildRequestTable(G)
    
    % build new table
    T = cell2table(cell(0,10), 'VariableNames', {'reciever', 'content', 'layer', 'valid', 'bw', 'duration', 'allPathsFound', 'allPathsFoundLatencies', 'selectedPath', 'selectedPathLatency'});

    % find all recierver nodes
    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    numOfRcv = size(recieverNodes, 1);
    
    % set default values
    duration = 1;
    valid = 1;
    allPathsFound = {};
    allPathsFoundLatencies = [];
    selectedPath = [];
    selectedPathLatency = 0;
    
    % run over each reciever node and read request parameters
    for dk = recieverNodes'
        ck = G.Nodes.requestedContent(dk);
        maxLayer = G.Nodes.requestedLayer(dk);
        for lk = [0:1:maxLayer]
            if lk == 0
                ck_bw = G.Nodes.baseLayerBW(ck);
            elseif lk == 1
                ck_bw = G.Nodes.enhancementLayer1BW(ck);
            elseif lk ==2
                ck_bw = G.Nodes.enhancementLayer2BW(ck);
            end
                         
            % add request to table
            
            rcvCell = {dk, ck, lk, valid, ck_bw, duration, allPathsFound, allPathsFoundLatencies, selectedPath, selectedPathLatency};
            T = [T ; rcvCell];
            
        end
    end
end
