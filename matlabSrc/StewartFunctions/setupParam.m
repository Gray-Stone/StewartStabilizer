function [Param] = setupParam(Param)
%SETUPPARAM 此处显示有关此函数的摘要
%   此处显示详细说明


% setup parameters
Param.baseR = 80;
Param.baseAlpha = 15 /180*pi;
Param.servoArmLength = 40;
Param.legLength = 60;
Param.plateR = 60;
Param.plateBeta = 100/180*pi;

% generate static frames. 
Param.uFrames = genMountFrame(Param.baseR,Param.baseAlpha);
Param.sFrames = genMountFrame(Param.plateR,Param.plateBeta);


end

