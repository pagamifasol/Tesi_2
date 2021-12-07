% Input file
    %clear
    D = SystemModel;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 1e7; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 10;

    TCP_LoadcasesLHS = [	9841	0       7204;   %1 Brake
                            0       0       22923;  %2 Parallel Bump
                            0       0       22923;  %3 One side Bump
                            8101	0       15589;  %4 Brake + Bump
                            0       13205	11766;  %5 Lateral
                            0       11004	17873;  %6 Lateral + Bump
                            7665	11004	9843;   %7 Lateral + Brake
                            -7321	0       18386;  %8 Reverse Brake + Bump
                            0       0       5635;   %9 Acceleration
                            0       0       19412;  %10 Acceleration + Bump
                    ];

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
