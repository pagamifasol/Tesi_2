% Input file
    %clear
    D = SystemModel2;
    def_scale = 1; %Scale deformation in the drawing
    drawing = 1; %Enable drawing

% Replace loads (Optional)
    LoadcaseN = 1;

    LoadFL = [	0	0   2500;
                0   0   5500;
             ];
         
    Preload = 600*[ 0 0 -1 ];
         
    D.Load(:,5) = LoadFL(LoadcaseN,:);
    
    D.Load(:,1) = Preload;
    D.Load(:,2) = Preload;
    D.Load(:,3) = Preload;
    D.Load(:,4) = Preload;
    D.Load(:,9) =  -Preload;
    D.Load(:,10) = -Preload;
    D.Load(:,11) = -Preload;
    D.Load(:,12) = -Preload;

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
