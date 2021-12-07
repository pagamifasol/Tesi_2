% Consumption data analysis to refine Canopy bSFC map
Data    = load('ExampleStint_FuelCons_Refinement_ARA21T06.mat');
D.req50 = 1; % 1 if 50% throttle data is available

%% RPM ranges definition
RPM_step    = 4000:500:7500;

% D.interval    = 50;   % old value
D.interval    = 200;   % half bandwidth for RPM ranges identification

dmFuel = zeros(3,length(RPM_step)); %total map preallocation
PowerCurve = zeros(2,length(RPM_step));

for i = 1:length(RPM_step)
    name            = strcat('n',num2str(RPM_step(i)));
    D.RPM_high      = RPM_step(i)+D.interval;
    D.RPM_low       = RPM_step(i)-D.interval;
    
    D.(name).spots          = find(Data.nmotrpm >= D.RPM_low & Data.nmotrpm <= D.RPM_high);
    D.(name).triplet(:,1)   = Data.nmotrpm(D.(name).spots);
    D.(name).triplet(:,2)   = Data.me_request(D.(name).spots);
    D.(name).triplet(:,3)   = Data.dm_Fuel_FFM(D.(name).spots); % fuel mass flow rate [g/s]
    D.(name).triplet(:,4)   = Data.CLU_MPUMeasuredCAN_pos(D.(name).spots).*(Data.nmotrpm(D.(name).spots) * pi/30)/1000; % engine power [kW]
  
    % RPM maps construction
    D.(name).A          = find(D.(name).triplet(:,2)>-0.1 & D.(name).triplet(:,2)<=0.1);
    D.(name).B          = find(D.(name).triplet(:,2)>0.48 & D.(name).triplet(:,2)<=0.52);
    D.(name).C          = find(D.(name).triplet(:,2)>0.95 & D.(name).triplet(:,2)<=1.05);
    D.(name).dmFuel_0   = D.(name).triplet(D.(name).A,3);
    D.(name).dmFuel_50  = D.(name).triplet(D.(name).B,3);
    D.(name).dmFuel_100 = D.(name).triplet(D.(name).C,3);
    D.(name).ath100Power= D.(name).triplet(D.(name).C,4);
    
    D.(name).Map        = [mean(D.(name).dmFuel_0);mean(D.(name).dmFuel_50);mean(D.(name).dmFuel_100);mean(D.(name).ath100Power)];
    
    % total map
    
    dmFuel(:,i)         = D.(name).Map(1:3);
    PowerCurve(:,i)     = [RPM_step(i) ; D.(name).Map(4)];  % RPM vs Power [kW] curve (FULL LOAD)
    
end
clear name i

%% map adjust

nan0    = isnan(dmFuel(1,:)); % avoiding no data dmFuel0
fun0    = @(x)OLS(x,RPM_step(~nan0),dmFuel(1,~nan0));
nan100  = isnan(dmFuel(3,:)); % avoiding no data dmFuel100
fun100  = @(x)OLS(x,RPM_step(~nan100),dmFuel(3,~nan100));
x0      = fminsearch(fun0,[2 0 0]);
x100    = fminsearch(fun100,[20 0 0]);
dmFuel0     = x0(1)+x0(2)*RPM_step+x0(3)*RPM_step.^2;
dmFuel100   = x100(1)+x100(2)*RPM_step+x100(3)*RPM_step.^2;

if D.req50
    nan50   = isnan(dmFuel(2,:)); % avoiding no data dmFuel50
    fun50   = @(x)OLS(x,RPM_step(~nan50),dmFuel(2,~nan50));
    x50     = fminsearch(fun50,[10 0 0]);
    dmFuel50    = x50(1)+x50(2)*RPM_step+x50(3)*RPM_step.^2;
    dmFuelA     = [dmFuel0;dmFuel50;dmFuel100];
else
    dmFuelA     = [dmFuel0;(dmFuel0+dmFuel100)/2;dmFuel100];
end

clear fun0 fun50 fun100 x0 x50 x100 dmFuel0 dmFuel50 dmFuel100 nan0 nan50 nan100

%% canopy input map
dmFuelC     = zeros(3*length(RPM_step),3);
dmFuelCA    = zeros(3*length(RPM_step),3);
for i = 1:length(RPM_step)
    dmFuelC(3*(i-1)+1:3*i,:)    = [ones(3,1)*RPM_step(i)*pi()/30,[0;0.5;1],dmFuel(:,i)/1000];
    dmFuelCA(3*(i-1)+1:3*i,:)   = [ones(3,1)*RPM_step(i)*pi()/30,[0;0.5;1],dmFuelA(:,i)/1000];
end
clear i
%% plots

% base map
figure
contourf(RPM_step,[0 0.5 1],dmFuel, 'ShowText','on')
hold on
xlabel('RPM')
ylabel('TorqueRequest [me act/me nom]')
title('1st try of sorting out a fuel consumption map [g/s]')

% adjusted map
figure
contourf(RPM_step,[0 0.5 1],dmFuelA, 'ShowText','on')
hold on
xlabel('RPM')
ylabel('TorqueRequest [me act/me nom]')
title('adjusted fuel consumption map [g/s]')
