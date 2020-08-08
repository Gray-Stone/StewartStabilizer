function [ Tdh] = DHTrans( t,d,r,a)
%DHTrans taks d, theta , a , alpha and return DH-transformation matrix
%   

Tdh = Rotz(t) * Transz(d)  * Rotx(r)* Transx (a) ;



end

