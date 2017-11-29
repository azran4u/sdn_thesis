
addpath(genpath('sdn'));

close all
clc
clear all

% global variables - number of layers per content
setGlobal_numOfLayersPerContent(3);
    
[G] = buildNetwork();

plotNetworkGraph( G );

[requestTable] = buildRequestTable(G);

[ LBSLS_G, LBSLS_requestTable ] = lbsls( G, requestTable);

%simulation(G);
%kcentrality(G);
