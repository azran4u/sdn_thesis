% calc tree index for (content, layer) pair
function res = treeIndex(firstContent,numOfLayersPerContent, content , layer)
    res = 1 + (content-firstContent)*numOfLayersPerContent + layer;
end
