close all
clear all

addpath(genpath('sdn'));

% global variables - number of layers per content
setGlobal_numOfLayersPerContent(3);
setGlobal_decodableLatencyThreshold(30);

test = 2;

if(test == 0)
    [G] = buildNetwork();  
    firstContent = getGlobal_firstContent();
    save('network','G', 'firstContent');
end

if(test == 1)
    load('network','G', 'firstContent');
    setGlobal_firstContent(firstContent);    
end

if(test == 2)
    %[ totalRunTime ] = gridSimulation( );
    [ gridSimulationResults ] = gridSimulation( );
    save(gridSimulationResults);
    return;
end

plotNetworkGraph( G );
simulation(G);


