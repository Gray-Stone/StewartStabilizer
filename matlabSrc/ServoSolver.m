syms sx sy sz sr11 sr12 sr13 sr21 sr22 sr23 sr31 sr32 sr33
S = [ sr11 , sr12 , sr13 , sx ;
    sr21 , sr22 , sr23 , sy;
    sr31 , sr23 , sr33 , sz; 
    0  ,   0    ,  0   , 1 ];

syms ux uy uz ur11 ur12 ur13 ur21 ur22 ur23 ur31 ur32 ur33
% U = [ ur11 , ur12 , 0 , ux ;
%     ur21 , ur22 , 0 , uy;
%     ur31 , 0 , 1 , uz; 
%     0  ,   0    ,  0   , 1 ];
syms angleM baseR 

U = Rotz(angleM) * Transx(baseR);
Utip = U(1:3,4);
syms q  armLength L ; 
arm = U * Rotx(q) * Transz(armLength);

Stip = S(1:3,4);
armTip = arm(1:3,4);
fixLeg = Stip - armTip;

% fixLegLength = fixLeg(1)^2 + fixLeg(2)^2 + fixLeg(3)^2 
% eqn = fixLegLength == L^2 
% solve(eqn,q)

planeN = U(1:3,1);
projStip = planeProject(Stip,planeN)
projArmTip = planeProject(armTip,planeN)

function [projV] = planeProject( V , N )

% scaleV = V(1)*N(1) + V(2)*N(2) + V(3)*N(3) ; 
projV = V - N*transpose(V)*N;

end 

