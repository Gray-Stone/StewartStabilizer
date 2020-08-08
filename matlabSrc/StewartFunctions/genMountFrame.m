function [mountF] = genMountFrame(Radious,SpaceAngle)
%GENBASEPARAM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    base.r = 80/2; % radious of servo arm cricule center. (servo arm mounting point)
    base.a = 15 /180*pi ; % angle between one pair of servo arm center 

    mountAngle =  zeros(6,1);
    base.u = zeros(3,6); % the u vector from center to servo arm center. 

    for ii = [1,3,5]
        % for leg x. 
        mountAngle(ii,1)  = -SpaceAngle/2 + fix(ii/2)*(120/180*pi);
        mountAngle(ii+1) = SpaceAngle/2 + fix(ii/2)*(120/180*pi);
    end

    for ii = 1:6
        mountF(:,:,ii) = Rotz(mountAngle(ii))*Transx(Radious);
    end

end

