function [toolF] = euler2TransMatrix (q)
%EULER2TRANSFORM make XYZ position and XYZ euler angle into 4*4 transformation matrix 
%   input is a list of X Y Z A B C for position and xyz euler angle. 
    toolF = Transx(q(1)) * Transy(q(2)) * Transz(q(3)) * Rotx(q(4)) * Roty(q(5)) * Rotz(q(6));
end