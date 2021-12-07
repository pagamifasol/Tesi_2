% Input file
    %clear
    D = Thesis_SuspRearV06_TwoSideAllDampers;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 1; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 1;

    TCP_LoadcasesLHS = [	  8480	  0     4307;  %1 Brake
                            0       0    23164;  %2 Bump
                            4151  21149  17687;  %3 Brake + Bump + Lateral
                            1425  20607  14803;  %4 Lateral
                            7674  12710   9793;  %5 Lateral + Brake
                            0       0    16768;  %6 Acceleration + Bump
                    ];
    D.Load(:,11) = TCP_LoadcasesLHS(LoadcaseN,:);
    
    WC_LoadcasesLHS = [	    0       0        0;  %1 Brake
                        -2333       0        0;  %2 Bump
                            0       0        0;  %3 Brake + Bump + Lateral
                            0       0        0;  %4 Lateral
                            0       0        0;  %5 Lateral + Brake
                       -12726       0        0;  %6 Acceleration + Bump
                    ];
    D.Load(:,12) = WC_LoadcasesLHS(LoadcaseN,:);
    
    TCP_LoadcasesRHS = [	  8480	  0     4307;  %1 Brake
                            0       0    23164;  %2 Bump
                            4151   5287   9053;  %3 Brake + Bump + Lateral
                            1425   5152   8914;  %4 Lateral
                            7674   4237   5919;  %5 Lateral + Brake
                            0       0    16768;  %6 Acceleration + Bump
                    ];
    D.Load(:,25) = TCP_LoadcasesRHS(LoadcaseN,:);
    
    WC_LoadcasesRHS = [	    0       0        0;  %1 Brake
                        -2333       0        0;  %2 Bump
                            0       0        0;  %3 Brake + Bump + Lateral
                            0       0        0;  %4 Lateral
                            0       0        0;  %5 Lateral + Brake
                       -12726       0        0;  %6 Acceleration + Bump
                    ];
    D.Load(:,26) = WC_LoadcasesRHS(LoadcaseN,:);
    
    if (LoadcaseN == 3)
        D.Load(:,37) = 21300 * [0.972826698 0.231045517	-0.015039415]; %Left damper load to rocker
        D.Load(:,38) = [0 0 0]; %Right damper load to rocker
    elseif (LoadcaseN == 11)
        D.Load(:,37) = 21300 * [0.972826698 0.231045517	-0.015039415] %Left damper load to rocker
        D.Load(:,38) = [0 0 0] %Right damper load to rocker (is it right to have 0 load on this point???
    elseif (LoadcaseN == 12)
        D.Load(:,37) = 21300 * [0.972826698 0.231045517	-0.015039415] %Left damper load to rocker
        D.Load(:,38) = [0 0 0] %Right damper load to rocker
    end

    
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
LHS_Dam(:,LoadcaseN) = D.Load(:,37);
LHS_Prod(:,LoadcaseN)= R(:,9);

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
RHS_Dam(:,LoadcaseN) = D.Load(:,38);
RHS_Prod(:,LoadcaseN)= R(:,23);

DF = R(:,27)-R(:,28);
b = (D.Coord(:,27)-D.Coord(:,28))./1000;
RHS_Rocker(:,LoadcaseN) = [R(:,27)+R(:,28);
                           DF(2)*b(3) + DF(3)*b(2);
                           DF(1)*b(3) + DF(3)*b(1);
                           DF(2)*b(1) + DF(1)*b(2);
                           ]; %Forces and moments at axis midpoint
                       
CDamToBell(:,LoadcaseN) = R(:,36);

DF = R(:,34)-R(:,35);
b = (D.Coord(:,34)-D.Coord(:,35))./1000;
Tbar(:,LoadcaseN) = [R(:,34)+R(:,35);
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
                    CDamToBell;
                    Tbar;
                    ];

chassis_loads = -chassis_reactions;
