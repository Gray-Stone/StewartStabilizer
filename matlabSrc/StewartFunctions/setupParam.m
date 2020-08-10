function [Param] = setupParam()
%SETUPPARAM 此处显示有关此函数的摘要
%   此处显示详细说明


% setup parameters
Param.baseR = 106;
Param.baseAlpha = 35 /180*pi;
Param.servoArmLength = 27;
Param.legLength = 47;
Param.plateR = 110;
Param.plateBeta = 66/180*pi;

% generate static frames. 
Param.uFrames = genMountFrame(Param.baseR,Param.baseAlpha);
Param.sFrames = genMountFrame(Param.plateR,Param.plateBeta);


end

