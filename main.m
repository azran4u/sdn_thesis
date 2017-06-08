close all
clc

[G, sourcesAndRecieversCell] = buildNetworkModel();

p = plotNetworkGraph( G );

bins = centralityApp(G);

p.MarkerSize = bins;

%allPathCell = findAllPathsFromSourcesToRcv( G, sourcesAndRecieversCell );

%plotAllPaths( G, allPathCell );

%fminconsolver( G, allPathCell );
