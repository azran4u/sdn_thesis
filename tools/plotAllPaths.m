function plotAllPaths( G, allPathCell )

    % plot all paths
    [allPathCellRow, allPathCellCol] = size(allPathCell);
    for i=1:allPathCellRow
        for j=1:allPathCellCol

            % check if empty cell
            if( not( isempty(allPathCell{i,j}) ) )
                pth = allPathCell{i,j};
            else
                continue
            end

            [pthSizeRow, pthSizeCol] = size(pth);
            numberOfPaths = pthSizeRow * pthSizeCol;

            for isr = 1:pthSizeRow
                for jsc = 1:pthSizeCol
                    figure;
                    H = plot(G,'Layout','force');
                    highlight(H,pth{isr,jsc}, 'EdgeColor','r');
                end
            end

        end
    end


end

