%% load
filename = 'Monza_XYGrip';
load(strcat(filename,'.mat'));

% power
f = figure;
scatter(Sim_Results.INPT.INPT_X_m.Data,Sim_Results.INPT.INPT_Y_m.Data,20,Sim_Results.BTR.BTR_PPackEst_W.Data/1000,'fill')
axis equal
set(gca,'visible','off')
h = colorbar('YTick', [-310,-300:150:750,760]);
set(get(h,'label'),'string','HVBS power [kW]');
colormap cool
set(gcf,'position',[50,50,800,600])
saveas(f,strcat(filename,'_power.jpeg'))
close figure 1

% speed
f = figure;
scatter(X,Y,30,GripFactor,'fill')
axis equal
set(gca,'visible','off')
h = colorbar;
set(get(h,'label'),'string','Grip Scaling Factor');
colormap cool
set(gcf,'position',[50,50,800,600])
% saveas(f,strcat(filename,'_speed.jpeg'))
close figure 1