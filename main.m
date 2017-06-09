close all
clc


%[G, sourcesAndRecieversCell] = network.buildNetworkModel();
[G, sourcesAndRecieversCell] = sdn.network.buildNetworkModel('simple', 10, 2, 3, 4, 100, 150, 30);

p = plotNetworkGraph( G );

bins = centralityApp(G);

p.MarkerSize = bins;

%allPathCell = findAllPathsFromSourcesToRcv( G, sourcesAndRecieversCell );

%plotAllPaths( G, allPathCell );

%fminconsolver( G, allPathCell );
