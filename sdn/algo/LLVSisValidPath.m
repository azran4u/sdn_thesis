function [ valid ] = LVSLSisValidPath( dk, ck, lk, path, delta_p, sigma_p )
    
    if isempty(path)
        valid = 0;
        return;
    end
    
    % TODO: check the delay difference from prev layer
    
    valid = 1;
       
end