function [rotz] = Rotz(t)
%ROTZ output 4*4 rotation matrix along Z with t radious

rotz = [   cos(t),-sin(t),0,0 ;  sin(t),cos(t),0,0 ; 0,0,1,0 ; 0,0,0,1];
% rotz= zeros(4,4);
% rotz(1,:) = [ cos(t),-sin(t),0,0 ] ;
% rotz(2,:) = [ sin(t),cos(t),0,0 ] ;
% rotz(3,:) = [ 0,0,1,0 ] ;
% rotz(4,:) = [ 0,0,0,1 ] ;

end

