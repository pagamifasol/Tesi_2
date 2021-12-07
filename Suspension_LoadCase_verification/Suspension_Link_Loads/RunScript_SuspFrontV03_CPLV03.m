% Input file
    D = SuspFrontV03_CenterDamper;
    def_scale = 1; %Scale deformation in the drawing

% Replace loads (Optional)
    LoadcaseN = 2;

    TCP_Loadcases = [	16088   0       9688;   %1 Brake
                        0       0       20001;  %2 Bump
                        11735   0       16726;  %3 Brake+Bump
                        0       14959   12153;  %4 Lateral (Outer)
                        0       -3740   3983;   %5 Lateral (Inner)
                        0       12466   17937;  %6 Lateral+Bump (Outer)
                        0       -7791   11128;  %7 Lateral+Bump (Inner)
                        11048   11687   13007;  %8 Lateral+Brake (Outer)
                        11048   -3896   6199;   %9 Lateral+Brake (Inner)
                        -10550  0       14031;  %10 Reverse Brake
                        0       0       3037;   %11 Acceleration
                        0       0       15254;  %12 Acceleration+Bump
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