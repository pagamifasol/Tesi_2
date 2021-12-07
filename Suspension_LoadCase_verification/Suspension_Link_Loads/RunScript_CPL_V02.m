% Input file
    D = SuspFrontV01;
    def_scale = 100000; %Scale deformation in the drawing

% Replace loads (Optional)
    LoadcaseN = 2;

    TCP_Loadcases = [	14851   0       9682;   %1 Brake
                        0       0       20002;  %2 Bump
                        10832   0       16722;  %3 Brake+Bump
                        0       14959   12154;  %4 Lateral (Outer)
                        0       -3740   3984;   %5 Lateral (Inner)
                        0       12466   17937;  %6 Lateral+Bump (Outer)
                        0       -7791   11129;  %7 Lateral+Bump (Inner)
                        10198   11687   13003;  %8 Lateral+Brake (Outer)
                        10198   -3896   6195;   %9 Lateral+Brake (Inner)
                        -9739   0       14036;  %10 Reverse Brake
                        0       0       3040;   %11 Acceleration
                        0       0       15258;  %12 Acceleration+Bump
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