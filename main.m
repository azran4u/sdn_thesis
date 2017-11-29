
addpath(genpath('sdn'));

close all
clc

[G] = buildNetwork();

%[G] = buildNetwork();
plotNetworkGraph( G );

simulation(G);

%kcentrality(G);
