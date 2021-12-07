% Input file
    D = SuspRearV06;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 0; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 12;

    TCP_Loadcases = [	9841    0       7204;   %1 Brake
                        0       0       22923;  %2 Bump
                        8101    0       15589;  %3 Brake+Bump
                        0       13205   11766;  %4 Lateral (Outer)
                        0       -7110   6995;   %5 Lateral (Inner)
                        0       11004   17873;  %6 Lateral+Bump (Outer)
                        0       -5925   13897;  %7 Lateral+Bump (Inner)
                        7665    11004   9843;   %8 Lateral+Brake (Outer)
                        7665    -5925   5867;   %9 Lateral+Brake (Inner)
                        -7321   0       18386;  %10 Reverse Brake
                        0       0       5635;   %11 Acceleration
                        0       0       19412;  %12 Acceleration+Bump
                    ];

    D.Load(:,11) = TCP_Loadcases(LoadcaseN,:);
    
    WC_Loadcases = [	0       0       0;      %1 Brake
                        -2333   0       0;      %2 Bump
                        0       0       0;      %3 Brake+Bump
                        -2333	0       0;      %4 Lateral (Outer)
                        -2333	0       0;      %5 Lateral (Inner)
                        -911	0       0;      %6 Lateral+Bump (Outer)
                        -911	0       0;      %7 Lateral+Bump (Inner)
                        0       0       0;      %8 Lateral+Brake (Outer)
                        0       0       0;      %9 Lateral+Brake (Inner)
                        0       0       0;      %10 Reverse Brake
                        -10273	0       0;      %11 Acceleration
                        -12714  0       0;      %12 Acceleration+Bump
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
