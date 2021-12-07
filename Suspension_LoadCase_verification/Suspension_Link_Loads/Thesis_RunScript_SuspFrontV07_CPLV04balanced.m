% Input file
    D = SuspFrontV07;
    def_scale = 2e4; %Scale deformation in the drawing

% Replace loads (Optional)
    LoadcaseN = 10;

    TCP_Loadcases = [	  10954   0        5940;  %1 Brake
                        0       0       18533;  %2 Bump
                        10464   0       15799;  %3 Brake+Bump
                        5361    18100   17100;  %4 Brake+Bump+Lateral (Outer)
                        5361    4525     8466;  %5 Brake+Bump+Lateral (Inner)
                        1841    17636   15423;  %6 Lateral (Outer)
                        1841    -4409    4486;  %7 Lateral (Inner)
                        9912    10878   12278;  %8 Lateral+Brake (Outer)
                        9912    -3626    5083;  %9 Lateral+Brake (Inner)
                        0       0       11901;  %10 Acceleration+Bump
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
