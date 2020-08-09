function [Param] = setupParam()
%SETUPPARAM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


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

