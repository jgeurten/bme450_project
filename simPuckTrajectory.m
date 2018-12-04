function [x, final,t] = simPuckTrajectory(launch_params)

    global radius mass rho area inertia gravity wx wy wz Cd Cl Cm alpha
    
    GOAL_DIST = 4.60;     % dist from board to puck in m

    vx = launch_params(1); % m/s 
    vy = launch_params(2); % m/s 
    vz = launch_params(3); % m/s 
    
    
    wz = launch_params(4); % rad/s 
    alpha = launch_params(5); % rad
    
    % Neglect rotation about x and y axes
    wy = 0; 
    wx = 0; 
    
    [Cd, Cl, Cm] = calcAeroCoeffs(alpha); 

    gravity = 9.81; %m/s/s
    radius = 76/1000/2; % Puck diameter: 76mm
    mass = 165/1000;    % Puck mass: 165 g
    area = pi*radius^2;
    inertia = 0.5*mass*radius^2;
    rho = 1.225; % kg/m^3

    %  x(1)=Vx, x(2)=Vy, x(3)=Vz, x(4)=X, x(5)=Y, x(6)=Z, x(7)= wz, 
    %  x(8)= ws, x(9) = alpha
    t0 = 0;
    tf = 10;
    x0 = [vx, vy, vz, 0, 0, 0, wz, 0, alpha]';   % launch conditions

    options = odeset('RelTol',1e-5,'AbsTol',1e-6);
    [t,x] = ode45('puck_eqns', [t0,tf], x0, options);

    % find time when puck hits the board (4.60 m)
    fgh= 0;  % final ground height, in feet
    final = -1;
    [rows,cols] = size(x);
    for i=2:rows,
      if x(i,5) < fgh  % ball has impacted ground (check y_dot < 0)
        if final < 0  % then we are at first instant of impact.
            final = i;
            % use linear interpolation to get final values:
            t(i)= t(i-1) + (t(i)-t(i-1))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,1) = x(i-1,1) + (x(i,1)-x(i-1,1))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,2) = x(i-1,2) + (x(i,2)-x(i-1,2))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,3) = x(i-1,3) + (x(i,3)-x(i-1,3))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,4) = x(i-1,4) + (x(i,4)-x(i-1,4))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,6) = x(i-1,6) + (x(i,6)-x(i-1,6))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,7) = x(i-1,7) + (x(i,7)-x(i-1,7))*(fgh-x(i-1,5))/(x(i,5)-x(i-1,5));
            x(i,5) = fgh;  %final y value reset to fgh
        end
      end
    end
end
