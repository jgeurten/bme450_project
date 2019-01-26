function xdot = puck_eqns(t,x)

%  Numerical integration of equations of
%  motion for a hockey puck using Schwiewagner, Bohm, Senner model
%
%  x(1)=Vx, x(2)=Vy, x(3)=Vz, x(4)=X, x(5)=Y, x(6)=Z, x(7)= wz, 
%  x(8)= ws, x(9) = alpha
global radius mass rho area inertia gravity

xdot = zeros(8,1);
speed = sqrt(x(1)*x(1)+x(2)*x(2)+x(3)*x(3));
Q = rho*speed^2*area/2; % Spin ratio
vx = x(1)/speed; vy = x(2)/speed; vz = x(3)/speed; 
wz = x(7); 
alpha = x(9); 

[Cd, Cl, Cm] = calcAeroCoeffs(alpha); 


ev = [vx, vy, vz]; 
ez = [-sin(alpha) 0 cos(alpha)];  
es = cross(ev, ez); 
es = es/norm(es); 
en = cross(es, ev); 

Fd = -Q*Cd*ev;
Fl = Q*Cl*en; 
Fs = 0.4*rho*speed*pi*radius^2*wz*cos(alpha)*cross(en, ev); 
Tm = Q*Cm*radius; 
Tn = 1.8e-5*wz*radius;

xdot(1) = (Fd(1) + Fl(1) + Fs(1))/mass ;
xdot(2) = (Fd(2) + Fl(2) + Fs(2))/mass - gravity;
xdot(3) = (Fd(3) + Fl(3) + Fs(3))/mass;

xdot(4) = x(1);
xdot(5) = x(2);
xdot(6) = x(3);

xdot(7) = Tn/inertia; 
xdot(8) = Tm/inertia; 
xdot(9) = x(8); 

end

