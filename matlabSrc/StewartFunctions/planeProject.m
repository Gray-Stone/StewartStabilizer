function [projV,perpV] = planeProject( V , N )
%PLANEPROJECT Project a vector V onto the plane with normal vector N 
%   return projV: projected vector, perpV: perpendicular vector component.

perpV = N*transpose(V)*N;
projV = V - perpV;

end 