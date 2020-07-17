function [roty] = Roty(t)
%ROTX output 4*4 rotation matrix along Y with t radious

roty = [   cos(t),0,sin(t),0; 0,1,0,0 ;   -sin(t),0,cos(t),0 ;  0,0,0,1  ];

% roty= zeros(4,4);
% roty(1,:) = [ cos(t),0,sin(t),0 ] ;
% roty(2,:) = [ 0,1,0,0 ] ;
% roty(3,:) = [ -sin(t),0,cos(t),0 ] ;
% roty(4,:) = [ 0,0,0,1 ] ;

end

