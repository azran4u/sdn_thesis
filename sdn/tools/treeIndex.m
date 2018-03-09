% calc tree index for (content, layer) pair
function res = treeIndex(content , layer)
    firstContent=getGlobal_firstContent();
    numOfLayersPerContent=getGlobal_numOfLayersPerContent();
    res = 1 + (content-firstContent)*numOfLayersPerContent + layer;
end
