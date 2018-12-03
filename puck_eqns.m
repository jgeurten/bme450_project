function xdot = puck_eqns(t,x)

%  Numerical integration of equations of
%  motion for golf ball using Schwiewagner, Bohm, Senner model
%
%  x(1)=Vx, x(2)=Vy, x(3)=Vz, x(4)=X, x(5)=Y, x(6)=Z, x(7)=omega

xdot = zeros(7,1);

global radius mass rho area inertia gravity wx wy wz Cd Cl Cm

speed = sqrt(x(1)*x(1)+x(2)*x(2)+x(3)*x(3));
Q = rho*speed^2*area/2; % Spin ratio


xdot(1) = (-Q*Cd*x(1)/speed + Q*Cl*(wy*x(3)-wz*x(2))/speed)/mass ;
xdot(2) = (-Q*Cd*x(2)/speed + Q*Cl*(wz*x(1)-wx*x(3))/speed)/mass - gravity;
xdot(3) = (-Q*Cd*x(3)/speed + Q*Cl*(wx*x(2)-wy*x(1))/speed)/mass;
xdot(4) = x(1);
xdot(5) = x(2);
xdot(6) = x(3);

xdot(7) = -Q*Cm*radius*2/inertia;

end

