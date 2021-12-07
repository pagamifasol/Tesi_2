% Input file
    D = SuspRearV05mod;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 0; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 12;

    TCP_Loadcases = [	11138   0       7607;   %1 Brake
                        0       0       24762;  %2 Bump
                        8124    0       16596;  %3 Brake+Bump
                        0       14180   13825;  %4 Lateral (Outer)
                        0       -7635   7694;   %5 Lateral (Inner)
                        0       11816   19967;  %6 Lateral+Bump (Outer)
                        0       -9090   14857;  %7 Lateral+Bump (Inner)
                        7649    11816   11600;  %8 Lateral+Brake (Outer)
                        7649    -6363   6490;   %9 Lateral+Brake (Inner)
                        -7304   0       19730;  %10 Reverse Brake
                        0       0       5988;   %11 Acceleration
                        0       0       20780;  %12 Acceleration+Bump
                    ];

    D.Load(:,11) = TCP_Loadcases(LoadcaseN,:);
    
    WC_Loadcases = [	0       0       0;      %1 Brake
                        -2481   0       0;      %2 Bump
                        0       0       0;      %3 Brake+Bump
                        -2481	0       0;      %4 Lateral (Outer)
                        -2481	0       0;      %5 Lateral (Inner)
                        -911	0       0;      %6 Lateral+Bump (Outer)
                        -911	0       0;      %7 Lateral+Bump (Inner)
                        0       0       0;      %8 Lateral+Brake (Outer)
                        0       0       0;      %9 Lateral+Brake (Inner)
                        0       0       0;      %10 Reverse Brake
                        -10901	0       0;      %11 Acceleration
                        -13498  0       0;      %12 Acceleration+Bump
                    ];
    
    D.Load(:,12) = WC_Loadcases(LoadcaseN,:);

% Run model
    [F,U,R]=ST(D);

% Check force sum to be zero
    FSum = sum(R,2) + sum(D.Load,2);
    disp('Forces equilibrium - should be near zero!')
    disp(FSum)

% Drawing
if drawing
    figure
    TP(D,U,def_scale);
end

% Custom output for excel sheet
UCA(:,LoadcaseN) = [R(:,1); R(:,2)];
LCA(:,LoadcaseN) = [R(:,4); R(:,5)];
Tie(:,LoadcaseN) = R(:,7);
Prod(:,LoadcaseN) = R(:,9);
