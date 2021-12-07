% Input file
    %clear
    D = SuspRearV05mod_TwoSideLateraDamper;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 0; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 10;

    TCP_LoadcasesLHS = [	11138   0       7607;   %1 Brake
                            0       0       24762;  %2 Parallel Bump
                            0       0       24762;  %3 One side Bump
                            8124    0       16596;  %4 Brake + Bump
                            0       14180   12743;  %5 Lateral
                            0       11816   19065;  %6 Lateral + Bump
                            7649    11816   11699;  %7 Lateral + Brake
                            -7304   0       19730;  %8 Reverse Brake + Bump
                            0       0       5988;   %9 Acceleration
                            0       0       20780;  %10 Acceleration + Bump
                    ];
    D.Load(:,11) = TCP_LoadcasesLHS(LoadcaseN,:);
    
    WC_LoadcasesLHS = [     0       0       0;      %1 Brake
                            -2481   0       0;      %2 Parallel Bump
                            -2481   0       0;      %3 One side Bump
                            0       0       0;      %4 Brake + Bump
                            -2481   0       0;      %4 Lateral
                            -911	0       0;      %6 Lateral + Bump
                            0       0       0;      %8 Lateral + Brake
                            0       0       0;      %10 Reverse Brake + Bump
                            -10901  0       0;      %11 Acceleration
                            -13498  0       0;      %12 Acceleration + Bump
                    ];
    D.Load(:,12) = WC_LoadcasesLHS(LoadcaseN,:);
    
    TCP_LoadcasesRHS = [	11138   0       7607;   %1 Brake
                            0       0       24762;  %2 Parallel Bump
                            0       0       0;      %3 One side Bump
                            8124    0       16596;  %4 Brake + Bump
                            0       7635    7694;   %5 Lateral
                            0       6363    14857;  %6 Lateral + Bump
                            7649    6363   11699;   %7 Lateral + Brake
                            -7304   0       19730;  %8 Reverse Brake + Bump
                            0       0       5988;   %9 Acceleration
                            0       0       20780;  %10 Acceleration + Bump
                    ];
    D.Load(:,25) = TCP_LoadcasesRHS(LoadcaseN,:);
    
    WC_LoadcasesRHS = [     0       0       0;      %1 Brake
                            -2481   0       0;      %2 Parallel Bump
                            0       0       0;      %3 One side Bump
                            0       0       0;      %4 Brake + Bump
                            -2481   0       0;      %4 Lateral
                            -911	0       0;      %6 Lateral + Bump
                            0       0       0;      %8 Lateral + Brake
                            0       0       0;      %10 Reverse Brake + Bump
                            -10901  0       0;      %11 Acceleration
                            -13498  0       0;      %12 Acceleration + Bump
                    ];
    D.Load(:,26) = WC_LoadcasesRHS(LoadcaseN,:);

% Run model
    [F,U,R]=ST(D);

% Check force sum to be zero
    FSum = sum(R,2) + sum(D.Load,2);
    disp('Forces equilibrium - should be near zero!')
    disp(FSum)
    
% Check maximum displacement
    disp('Maximum displacement')
    disp(max(sqrt(U(1,:).^2+U(2,:).^2+U(3,:).^2)))

% Drawing
close all
if drawing
    figure
    TP(D,U,def_scale);
end

% Custom output for excel sheet
LHS_UCA(:,LoadcaseN) = [R(:,1); R(:,2)];
LHS_LCA(:,LoadcaseN) = [R(:,4); R(:,5)];
LHS_Tie(:,LoadcaseN) = R(:,7);
LHS_Dam(:,LoadcaseN) = R(:,29);

DF = R(:,13)-R(:,14);
b = (D.Coord(:,13)-D.Coord(:,14))./1000;
LHS_Rocker(:,LoadcaseN) = [R(:,13)+R(:,14);
                           DF(2)*b(3) + DF(3)*b(2);
                           DF(1)*b(3) + DF(3)*b(1);
                           DF(2)*b(1) + DF(1)*b(2);
                           ]; %Forces and moments at axis midpoint

RHS_UCA(:,LoadcaseN) = [R(:,15); R(:,16)];
RHS_LCA(:,LoadcaseN) = [R(:,18); R(:,19)];
RHS_Tie(:,LoadcaseN) = R(:,21);
RHS_Dam(:,LoadcaseN) = R(:,30);

DF = R(:,27)-R(:,28);
b = (D.Coord(:,27)-D.Coord(:,28))./1000;
RHS_Rocker(:,LoadcaseN) = [R(:,27)+R(:,28);
                           DF(2)*b(3) + DF(3)*b(2);
                           DF(1)*b(3) + DF(3)*b(1);
                           DF(2)*b(1) + DF(1)*b(2);
                           ]; %Forces and moments at axis midpoint

chassis_reactions = [LHS_UCA;
                    LHS_LCA;
                    LHS_Tie;
                    LHS_Rocker;
                    LHS_Dam;
                    RHS_UCA;
                    RHS_LCA;
                    RHS_Tie;
                    RHS_Rocker;
                    RHS_Dam;
                    ];

chassis_loads = -chassis_reactions;
