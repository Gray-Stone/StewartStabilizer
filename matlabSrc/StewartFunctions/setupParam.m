function [Param] = setupParam(Param)
%SETUPPARAM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


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

