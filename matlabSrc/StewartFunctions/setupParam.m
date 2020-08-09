function [Param] = setupParam()
%SETUPPARAM 此处显示有关此函数的摘要
%   此处显示详细说明


% setup parameters
Param.baseR = 75;
Param.baseAlpha = 15 /180*pi;
Param.servoArmLength = 40;
Param.legLength = 80;
Param.plateR = 40;
Param.plateBeta = 100/180*pi;

% generate static frames. 
Param.uFrames = genMountFrame(Param.baseR,Param.baseAlpha);
Param.sFrames = genMountFrame(Param.plateR,Param.plateBeta);


end

