function D=SystemModel2
%  Definition of Data

%  Nodal Coordinates [mm]

Coord=[ 175         -125        28;         %1 Bushing FL
        175         125         28;         %2 Bushing FR
        425         -125        28;         %3 Bushing RL
        425         125         28;         %4 Bushing RR
        225         -125        -25;        %5 Load FL
        225         125         -25;        %6 Load FR
        375         -125        -25;        %7 Load RL
        375         125         -25;        %8 Load RR  
        175         -125        55;         %9 Bushing FL Upper
        175         125         55;         %10 Bushing FR Upper
        425         -125        55;         %11 Bushing RL Upper
        425         125         55;         %12 Bushing RR Upper
        ];

%  Connectivity

Con=[   1 2;    %Upper square
        2 3;
        3 4;
        4 1;
        
        5 6;    %Lower square
        6 7;
        7 8;
        8 5;
        
        1 5;    %Legs
        2 6;
        3 7;
        4 8;
        
        1 6;    %Front cross
        2 5;
        3 8;    %Rear cross
        4 7;
        1 7;    %Left cross
        3 5;
        2 8;    %Right cross
        4 6;
        
        1 10;    %Shear virtual links
        1 11;
        2 12;
        3 12;
        
        1 9;    %Bushings
        2 10;
        3 11;
        4 12;
    ];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord)); %Default all free
Re(9,:)=[1 1 1];
Re(10,:)=[1 1 1];
Re(11,:)=[1 1 1];
Re(12,:)=[1 1 1];
% or:   Re=[0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;1 1 1;1 1 1;1 1 1;1 1 1];

% Definition of Nodal loads 
Load=zeros(size(Coord));
%Load(5,:) = [0 0 0];
% Load([1:3,6],:)=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0.6 0 0];
% or:   Load=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0 0 0;0 0 0;0.6 0 0;0 0 0;0 0 0;0 0 0;0 0 0];

% Definition of Modulus of Elasticity [MPa]
E=ones(1,size(Con,1))*210e6; %Steel 210GPa *1000
E(25) = 1e6; %1GPa
E(26) = 1e6; %1GPa
E(27) = 1e6; %1GPa
%E(28) = 1e6; %1GPa, This leg is working in tension, make it rigid
% or:   E=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*1e7;

% Definition of Area [mm^2]
% A=[.4 .1 .1 .1 .1 3.4 3.4 3.4 3.4 .4 .4 1.3 1.3 .9 .9 .9 .9 1 1 1 1 3.4 3.4 3.4 3.4];
A = ones(1,size(Con,1))*1256; %40mm solid circle - 20x20x3.14 = 1256 mm^2

A(25) = 191/37*1e-3; %K/37  N/mm * 1e-9 m^2
A(26) = 199/37*1e-3; %1e-9 m^2
A(27) = 184/37*1e-3; %1e-9 m^2
% A(28) = 4.19*1e-3; %1e-9 m^2, This leg is working in tension, make it rigid

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');