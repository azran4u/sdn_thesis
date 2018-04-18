function [T] = createEmptyRequestTable()
    
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

end
