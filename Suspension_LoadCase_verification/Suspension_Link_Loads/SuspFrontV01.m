function D=SuspFrontV01
%  Definition of Data

%  Nodal Coordinates [mm]
Coord=[ -65 -385.425 397.241;       %1 UCA Front
        175 -406.422 364.012;       %2 UCA Rear
        25.2 -686.212 406.45;       %3 UCA Outer
        -200 -373.614 148.186;      %4 LCA Front
        175 -406.422 150.286;       %5 LCA Rear
        -1.877 -740.872 149.296;    %6 LCA Outer
        -125 -410 387;              %7 Tierod Inner
        -96.027 -706.516 409.374;   %8 Tierod Outer
        15.974 -319.555 489.986;    %9 Pushrod Upper
        4.429 -703.143 208.969;     %10 Pushrod Lower
        0 -825 -70;                 %11 TCP
        ];

%  Connectivity
Con=[1 3;    %1 UCA front link
     2 3;    %2 UCA rear link
     4 6;    %3 LCA front link
     5 6;    %4 LCA rear link
     7 8;    %5 Tierod
     9 10;    %6 Pushrod
     3 11;    %7 UCA to TCP
     6 11;    %8 LCA to TCP
     8 11;    %9 Tierod to TCP
     10 11;    %10 Pushrod to TCP
     % Connect all upright nodes between them
     3 6;
     3 10;
     6 10;
     3 8;
     6 8;
     8 10;
    ];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord)); %Default all free
Re(1,:)=[1 1 1];
Re(2,:)=[1 1 1];
Re(4,:)=[1 1 1];
Re(5,:)=[1 1 1];
Re(7,:)=[1 1 1];
Re(9,:)=[1 1 1];
% or:   Re=[0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;1 1 1;1 1 1;1 1 1;1 1 1];

% Definition of Nodal loads 
Load=zeros(size(Coord));
Load(11,:) = [0 0 20002];
% Load([1:3,6],:)=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0.6 0 0];
% or:   Load=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0 0 0;0 0 0;0.6 0 0;0 0 0;0 0 0;0 0 0;0 0 0];

% Definition of Modulus of Elasticity [MPa]
E=ones(1,size(Con,1))*210e6; %Steel 210Gpa
% or:   E=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*1e7;

% Definition of Area [mm^2]
% A=[.4 .1 .1 .1 .1 3.4 3.4 3.4 3.4 .4 .4 1.3 1.3 .9 .9 .9 .9 1 1 1 1 3.4 3.4 3.4 3.4];
A = ones(1,size(Con,1))*1256; %40mm solid circle - 20x20x3.14 = 1256 mm^2

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');