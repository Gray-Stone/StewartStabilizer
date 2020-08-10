function [Param] = setupParam()
%SETUPPARAM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


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

