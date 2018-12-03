function [Cd, Cl, Cm] = calcAeroCoeffs(alpha)

% ALPHA IN RADS

% Using coefficients found in Baumback, 2010 (based on frisebee throw)
% Baumback, Kathleen (2010) "The Aerodynamics of Frisbee Flight," Undergraduate Journal of Mathematical Modeling: One + Two: Vol.3: Iss. 1, Article 19

% Cm from Hummel Thesis (1997)

% Consts 
Clo = 0.15; Cl_alpha = 1.4; 
Cdo = 0.08; Cd_alpha = 2.72; 
Cmo = -0.08; Cm_alpha = 0.43; 
alpha_o = -4*pi/180; % in rads 


Cd = Cdo + Cd_alpha*(alpha - alpha_o)^2; 
Cl = Clo + Cl_alpha*alpha; 
Cm = Cmo + Cm_alpha*alpha;

end