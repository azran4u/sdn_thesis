
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

allPaths  = allPathsBetweenNodes( G, 9, 10 );

simulation(G);




%[requestTable] = buildRequestTable(G);  
%[ LBSLS_G, LBSLS_requestTable ] = lbsls( G, requestTable);
%r = revenue( LBSLS_requestTable );
%save('LBSLS','LBSLS_G','LBSLS_requestTable');
%simulation(G);
%kcentrality(G);


