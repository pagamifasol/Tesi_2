function D=SuspFrontV03
%  Definition of Data

%  Nodal Coordinates [mm]
Coord=[ -65	-404.674 398.668;       %1 UCA Front
        175 -425.672 365.439;       %2 UCA Rear
        24.972 -672.337 405.455;    %3 UCA Outer
        -200 -392.863 148.188;      %4 LCA Front
        175 -425.672 150.287;       %5 LCA Rear
        -1.951 -726.786 149.295;    %6 LCA Outer
        -125 -410 396;              %7 Tierod Inner
        -96.304 -707.649 413.381;   %8 Tierod Outer
        16 -349.068 489.371;        %9 Pushrod Upper
        4.335 -689.074 209.1;       %10 Pushrod Lower
        0 -818.398 -70;             %11 TCP
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