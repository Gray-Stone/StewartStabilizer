function [servoAngle,Param,legError] = SteIK(Param,toolF)
    %STEIK Takes a 4*4 transformation matrix of the tool tip and return the
    %list of joint angles. 
    
    
    % go through each leg and solve for the joint angle. 
    servoAngle = zeros(6,1);
%     armTipFrames = zeros(4,4,6);
    legError = zeros(6,1);
    for ii = 1:6
        % extract variables
        uFrame = Param.uFrames(:,:,ii);
        Param.sBaseFrames(:,:,ii) = toolF * Param.sFrames(:,:,ii);
        sBase = Param.sBaseFrames(1:3,4,ii);
        % calculate inverse kinematic for this leg
        servoAngle(ii) = oneLegIK(uFrame,sBase,Param.legLength,Param.servoArmLength);
        
        % invert ever other leg.
        if( mod(ii+1,2))
            servoAngle(ii) = -servoAngle(ii);
        end

        % generate the transformation to reach tip of servo arm
        Param.armTipFrames(:,:,ii) =  uFrame * Rotx(servoAngle(ii)) * Transz(Param.servoArmLength);
        fL = sBase - Param.armTipFrames(1:3,4,ii);
        
        % output the error term for determent out of workspace. 
        legError(ii) = ( norm(fL) - Param.legLength);


    end

end

