function [q] = IvKinematics(pos)
%IVRKINEMATICS take in pos (3*1)and return joint angle q (3*1)

% setup variables
q = zeros (3,1);
L1 = 169.28;
L2 = 175;
L3 = 169.28;

%%%%%%%%%%%%%%% checking to see if points are out side of reach  %%%%%%%%%%%%%%% 

%rotate the input if it is not the righte oriantation. 

%%%

f1 = [0;0;175];  %%% mark center of the limir sphere 

dis = sqrt( (pos(1) - f1(1))^2 + ( pos(2) - f1(2) )^2 +( pos(3) - f1(3) )^2 ); % calcualte the distance to the center 

if (dis >   344.28) % when the distance is greater than the whole arm span, return error 
    msg = sprintf("position given out of reach \n pos: %0.2f %0.2f %0.2f",pos(1),pos(2),pos(3) )'
    error(msg);
end

% center of the limit circuit f1 

%%%%%%%%%%
posx = pos(1);
posy = pos(2);
posz = pos(3);

% calculate first joint
posr = sqrt(posx^2+posy^2);
q(1) = ( atan2(posy,posx) )/pi*180;

% generating helper value
H = L1 - posz;
D = sqrt(H^2+posr^2);

% caluclate second joint 
beta = acos( (L2^2 + D^2 - L3^2) / (2*L2*D) );
gama = atan2(H,posr);
q(2) = (beta-gama)/pi *180 ;

% calculate last joint
q(3) = asin( (-L2^2-L3^2+D^2) / (2*L2*L3) );
q(3) = q(3)/pi*180;

end

