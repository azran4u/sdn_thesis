close all
clear all

addpath(genpath('sdn'));

% global variables - number of layers per content
setGlobal_numOfLayersPerContent(3);
setGlobal_decodableLatencyThreshold(30);

simulationMainGrid4x4();
simulationMainGrid14x14();

