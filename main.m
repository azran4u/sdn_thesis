close all
clear all

addpath(genpath('sdn'));

% global variables - number of layers per content
setGlobal_numOfLayersPerContent(3);
setGlobal_decodableLatencyThreshold(30);

test = 4;

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
    [ gridSimulationResults ] = LLVSgridSimulation( );
    %save(gridSimulationResults);
    return;
end

if(test == 3)
    [ results ] = gridSimulation( );
    save('grid4x4results3rep', 'results');
    return;
end

if(test == 4)
    load('grid4x4results3rep','results');
    grid4x4grpah(results);
end

if(test == 5)
    [ results ] = gridSimulation( );
    save('grid14x14results3rep', 'results');
    return;
end

if(test == 6)
    load('grid14x14results3rep','results');
    grid4x4grpah(results);
end

if(test == 7)
    [ results ] = gridSimulation( );
    save('grid6x6results3rep', 'results');
    return;
end

if(test == 8)
    load('grid6x6results3rep','results');
    grid4x4grpah(results);
end

if(test == 7)
    plotNetworkGraph( G );
    simulation(G);
end
