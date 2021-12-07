function D=SuspRearV03
%  Definition of Data

%  Nodal Coordinates [mm]

Coord=[ 2534.6 -231.5 286.1;        %1 UCA Front
        2993.4 -199.5 279.9;        %2 UCA Rear
        3070.0 -643.6 302.3;        %3 UCA Outer
        2755.8 -180.9 150.5;        %4 LCA Front
        3212.5 -132.9 124.3;        %5 LCA Rear
        3085.0 -686.9 110.4;        %6 LCA Outer
        3267.5 -136.0 238.0;        %7 Tierod Inner
        3300.0 -609.4 254.7;        %8 Tierod Outer
        3048.8 -157.3 363.0;        %9 Pushrod Upper
        3095.0 -632.7 64.1;         %10 Pushrod Lower
        3140.0 -805.4 -90.0;        %11 TCP
        3140.0 -799.5 250.0;        %12 Wheel Center          
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
     3 12;    %7 UCA to WC
     6 12;    %8 LCA to WC
     8 12;    %9 Tierod to WC
     10 12;    %10 Pushrod to WC
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
Load(11,:) = [0 0 1000];
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