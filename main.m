
close all
clear all

addpath(genpath('sdn'));

% global variables - number of layers per content
setGlobal_numOfLayersPerContent(3);
setGlobal_decodableLatencyThreshold(30);

test = 1;

if(test == 0)
    [G] = buildNetwork();  
    firstContent = getGlobal_firstContent();
    save('network','G', 'firstContent');
else
    load('network','G', 'firstContent');
    setGlobal_firstContent(firstContent);    
end

plotNetworkGraph( G );

simulation(G);


