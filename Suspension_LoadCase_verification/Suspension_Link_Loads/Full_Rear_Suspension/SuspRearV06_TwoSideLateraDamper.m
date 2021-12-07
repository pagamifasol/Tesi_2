function D=SuspRearV06_TwoSideLateraDamper
%  Definition of Data

%  Nodal Coordinates [mm]

Coord=[ 2648        -310        289.077;    %1 UCA Front
        3005.1      -198.629	279.725;    %2 UCA Rear
        3070        -643.566	302.27;     %3 UCA Outer
        2725        -198        151.706;    %4 LCA Front
        3212.5      -132.88     124.346;    %5 LCA Rear
        3099.911    -686.918	109.391;    %6 LCA Outer
        3267.5      -136        238;        %7 Tierod Inner
        3300        -609.378	249.632;    %8 Tierod Outer
        3054.753	-161.722	359.461;	%9 Pushrod Upper
        3094.938	-632.717	64.014;     %10 Pushrod Lower
        3140        -805.532	-96;        %11 TCP
        3140        -799.501	249.948;    %12 Wheel Center
        
        2993.506	-134.946	336.088;    %13 Rocker axis 1
        3005.792	-181.715	412.312;    %14 Rocker axis 2
        
        2648        310         289.077;    %15 UCA Front
        3005.1      198.629     279.725;    %16 UCA Rear
        3070        643.566     302.27;     %17 UCA Outer
        2725        198         151.706;    %18 LCA Front
        3212.5      132.88      124.346;    %19 LCA Rear
        3099.911    686.918     109.391;    %20 LCA Outer
        3267.5      136         238;        %21 Tierod Inner
        3300        609.378     249.632;    %22 Tierod Outer
        3054.753	161.722     359.461;    %23 Pushrod Upper
        3094.938	632.717     64.014;     %24 Pushrod Lower
        3140        805.532     -96;        %25 TCP
        3140        799.501     249.948;    %26 Wheel Center
        
        2993.506	134.946     336.088;    %27 Rocker axis 1
        3005.792	181.715     412.312;    %28 Rocker axis 2
        
        2639.382	-156.125	434.42;     %29 Left damper to bell
        2639.382	156.125     434.42;     %30 Right damper to bell
        
        2978.979	-75.471     429.17;     %31 Left damper to rocker
        2978.979	75.471      429.17;     %32 Right damper to rocker
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
     
    15    17; %RHS suspension arms/upright/pushrod lower
    16    17;
    18    20;
    19    20;
    21    22;
    23    24;
    17    25;
    20    25;
    22    25;
    24    25;
    17    26;
    20    26;
    22    26;
    24    26;
    17    20;
    17    24;
    20    24;
    17    22;
    20    22;
    22    24;
    
    %Rocker left
    9 13; %pushrod to axis 1
    9 14; %pushrod to axis 2
    13 31; %damper to axis 1
    14 31; %damper to axis 2
    9 31; %pushrod to damper
    %13 14; %axis join
    
    %Rocker right
    23 27; %pushrod to axis 1
    23 28; %pushrod to axis 2
    27 32; %damper to axis 1
    28 32; %damper to axis 2
    23 32; %pushrod to damper
    %27 28; %axis join
    
    %Dampers
    29 31; %lhs
    30 32; %rhs
    ];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord)); %Default all free
Re(1,:)=[1 1 1];
Re(2,:)=[1 1 1];
Re(4,:)=[1 1 1];
Re(5,:)=[1 1 1];
Re(7,:)=[1 1 1];
Re(9,:)=[1 1 1];
Re(23,:)=[1 1 1];

%rhs arms
Re(15,:)=[1 1 1];
Re(16,:)=[1 1 1];
Re(18,:)=[1 1 1];
Re(19,:)=[1 1 1];
Re(21,:)=[1 1 1];

%rocker axes
Re(13,:)=[1 1 1];
Re(14,:)=[1 1 1];
Re(27,:)=[1 1 1];
Re(28,:)=[1 1 1];

%lateral dampers
Re(29,:)=[1 1 1]; %tbar left support
Re(30,:)=[1 1 1]; %tbar right support
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