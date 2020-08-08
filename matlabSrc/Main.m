clear

p = genpath('Functions');
addpath(p)


% convert parameters into vector U S. 
% 
% syms a b baseR plateR sevR l;
% syms q1 q2 q3 q4 q5 q6;
% % syms px py pz pa pb pc;
% syms px py pz pr11 pr12 pr13 pr21 pr22 pr23 pr31 pr32 pr33
% endF = [ pr11 , pr12 , pr13 , px ;
%     pr21 , pr22 , pr23 , py;
%     pr31 , pr23 , pr33 , pz; 
%     0  ,   0    ,  0   , 1 ];

base.r = 80/2; % radious of servo arm cricule center. (servo arm mounting point)
base.a = 15 /180*pi ; % angle between one pair of servo arm center 

servo.r = 15 ; % the servo radious (arm length)
homeQ = 90/180*pi; % the servo arm angle. vertical as 0, home at 90

servo.q = [ homeQ , homeQ ,homeQ,homeQ,homeQ,homeQ  ];

plate.r = 60/2 ; % radious of plate mounting point
plate.b = 100/180*pi; % angle between plate mounting point. 


ee = [ 10; 10 ; 27 ; 0 ; 0 ; 0 ] ;
ee(4:6) = ee(4:6) /180*pi;
toolF = euler2Transform (ee)


% base.r = baseR;
% base.a = a ;
% servo.r = sevR ;
% servo.q = [ q1 ;q2 ;q3 ; q4 ; q5 ; q6 ] ;
% plate.r = plateR;
% plate.b = b ;

% empty defines used later
base.mountAngle =  zeros(6,1);
base.u = zeros(3,6); % the u vector from center to servo arm center. 
plate.mountAngle =  zeros(6,1);
plate.sBase = zeros(3,6); % vector s from center of plate to mounting point

% base.mountAngle =  sym(zeros(6,1));
% base.u = sym(zeros(3,6)) ; % the u vector from center to servo arm center. 
% 
% plate.mountAngle =  sym(zeros(6,1));
% plate.s = sym(zeros(3,6)); % vector s from center of plate to mounting point


leg.length = 40 ; % length of the fixed length leg. 
% leg.length = l;

for ii = [1,3,5]
    % for leg x. 
    base.mountAngle(ii,1)  = -base.a/2 + fix(ii/2)*(120/180*pi);
    base.mountAngle(ii+1) = base.a/2 + fix(ii/2)*(120/180*pi);

    plate.mountAngle(ii)  = -plate.b/2 + fix(ii/2)*(120/180*pi);
    plate.mountAngle(ii+1) = plate.b/2 + fix(ii/2)*(120/180*pi);
end

setupFigure(1);
plotVector([0,0,0],toolF(1:3,4),'k');

for ii = 1:6
    uF = Rotz(base.mountAngle(ii))*Transx(base.r);
    u = uF(1:3,4);
    base.uF(:,:,ii) = uF;
    base.u(:,ii) = uF(1:3,4);
       
    sBaseF =toolF * Rotz(plate.mountAngle(ii)) * Transx(plate.r);
    sBase = sBaseF(1:3,4);
    plate.sBase(:,ii) = sBaseF(1:3,4);
    
    
%     Xsf = uF(1:3,1);
%     Zsf = uF(1:3,3);
%     [Sbproj , Sbprep] = planeProject( sBase , Xsf );
%     
%     vLproj = Sbproj ;
%     
%     fLproj2 = leg.length^2 - (norm(u -Sbprep))^2;
%     
%     gamma = acos( ( transpose(vLproj)*Zsf ) / (norm(vLproj) ) );
%     delta = acos( ( servo.r^2 + norm(vLproj)^2 - fLproj2  ) / (2 * norm(vLproj) * servo.r)  );
%     
%     q = gamma + delta;
%     
%     servo.q(:,ii) = q; 

    q = oneLegIK(uF,sBase,leg.length,servo.r);

    if( mod(ii+1,2))
        q = -q;
    end
    
    armF =  uF * Rotx(q) * Transz(servo.r);
    armTip = armF(1:3,4);
    serovo.armTip(:,ii) = armTip;
    
    fL = sBase - armTip;
    leg.diff(ii) = norm(fL) - leg.length;
    
    plotVector([0;0;0],u,'r');    
    plotVector(toolF(1:3,4),sBase,'b');
    plotVector(u,armTip,'g');
    plotVector(armTip,armTip+fL,'c');
    
end

disp("result q")
disp(servo.q /pi *180)

disp("length check");
disp(leg.diff)

for ii=1:5
    plot3( [base.u(1,ii),base.u(1,ii+1)] ,  [base.u(2,ii),base.u(2,ii+1)] ,[base.u(3,ii),base.u(3,ii+1)] ,'r')
end
plot3( [base.u(1,1),base.u(1,ii+1)] ,  [base.u(2,1),base.u(2,ii+1)] ,[base.u(3,1),base.u(3,ii+1)] ,'r')

for ii=1:5
    plot3( [plate.sBase(1,ii),plate.sBase(1,ii+1)] ,  [plate.sBase(2,ii),plate.sBase(2,ii+1)] ,[plate.sBase(3,ii),plate.sBase(3,ii+1)] ,'b')
end
plot3( [plate.sBase(1,1),plate.sBase(1,ii+1)] ,  [plate.sBase(2,1),plate.sBase(2,ii+1)] ,[plate.sBase(3,1),plate.sBase(3,ii+1)] ,'b')


%%%%%%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%% 

function [toolF] = euler2Transform (q)

    toolF = Transx(q(1)) * Transy(q(2)) * Transz(q(3)) * Rotx(q(4)) * Roty(q(5)) * Rotz(q(6));
    
end

function [] = setupFigure(num)
    figure(num)
    clf
    hold on 
    max = 60;
%     xlim([-max max])
%     ylim([-max max ])
%     zlim([-max*0.5 max*1.5 ])
%     view([-150,30])
    pbaspect([1 1 1])
    rotate3d on
end

function [] = plotVector(base , tip ,color )
        plot3([base(1),tip(1)] , [base(2),tip(2)] ,[base(3),tip(3)] ,color)
%     plot3([base(:),tip(:)] ,color)

end

function [projV,perpV] = planeProject( V , N )

perpV = N*transpose(V)*N;
projV = V - perpV;

end 

