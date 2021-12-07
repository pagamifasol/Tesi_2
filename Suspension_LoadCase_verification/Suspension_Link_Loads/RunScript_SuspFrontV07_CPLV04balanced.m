% Input file
    D = SuspFrontV07;
    def_scale = 2e4; %Scale deformation in the drawing

% Replace loads (Optional)
    LoadcaseN = 3;

    TCP_Loadcases = [	12711   0       8923;   %1 Brake
                        0       0       18741;  %2 Bump
                        10464   0       15799;  %3 Brake+Bump
                        0       13909   11463;  %4 Lateral (Outer)
                        0       -3477   2837;   %5 Lateral (Inner)
                        0       11591   16846;  %6 Lateral+Bump (Outer)
                        0       -2898   9658;   %7 Lateral+Bump (Inner)
                        9901    10867   12270;  %8 Lateral+Brake (Outer)
                        9901    -3622   5082;   %9 Lateral+Brake (Inner)
                        -9456   0       13032;  %10 Reverse Brake
                        0       0       2900;   %11 Acceleration
                        0       0       14257;  %12 Acceleration+Bump
                    ];

    D.Load(:,11) = TCP_Loadcases(LoadcaseN,:);

% Run model
    [F,U,R]=ST(D);

% Check force sum to be zero
    FSum = sum(R,2) + sum(D.Load,2);
    disp('Forces equilibrium - should be near zero!')
    disp(FSum)

% Drawing
    figure
    TP(D,U,def_scale);

% Custom output for excel sheet
UCA(:,LoadcaseN) = [R(:,1); R(:,2)];
LCA(:,LoadcaseN) = [R(:,4); R(:,5)];
Tie(:,LoadcaseN) = R(:,7);
Prod(:,LoadcaseN) = R(:,9);
