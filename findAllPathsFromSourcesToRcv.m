function allPathCell = findAllPathsFromSourcesToRcv( G, sourcesAndRecieversCell )

    adjG = adjacency(G);
    
    srcAndRecCell = sourcesAndRecieversCell;
    [numOfSources, temp] = size(srcAndRecCell);
    allPathCell = cell(0);

    for i=1:numOfSources
        % find number of rcv's of source i
        [numOfElements, na] = size(srcAndRecCell{i,1});

        % the first element is the source, find the source name and index
        srcName = srcAndRecCell{i,1}(1);   
        srcName = srcName{1}; % convert cell to string
        srcIndex = findnode(G,{srcName});

        for j=2:numOfElements
            rcvName = srcAndRecCell{i,1}(j);
            rcvName = rcvName{1}; % convert cell to string
            rcvIndex = findnode(G,{rcvName});

            % find all path's from src to dst
            pth = pathbetweennodes(adjG, srcIndex, rcvIndex);

            % save result
            allPathCell{i,j} = pth;

        end
    end

end

