close all;
fig = openfig('grid14x14Revenue');
hmarker = findobj(gca, 'type', 'marker');
hline = findobj(gca, 'type', 'line');
set(hline(1),'LineStyle',':');
set(hmarker(1),'MarkerType','+');