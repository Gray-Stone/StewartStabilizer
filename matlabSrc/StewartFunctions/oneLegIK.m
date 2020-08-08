function [q] = oneLegIK(servoFrame,S,legLength,armLength)
%ONELEGIK 此处显示有关此函数的摘要
%   此处显示详细说明

    Xsf = servoFrame(1:3,1);
    Zsf = servoFrame(1:3,3);
    U = servoFrame(1:3,4);

    [Sbproj , Sbprep] = planeProject( S , Xsf );
    
%     vLproj = Sbproj ;
    fLproj2 = legLength^2 - (norm(U -Sbprep))^2;
    gamma = acos( ( transpose(Sbproj)*Zsf ) / (norm(Sbproj) ) );
    delta = acos( ( armLength^2 + norm(Sbproj)^2 - fLproj2  ) / (2 * norm(Sbproj) * armLength)  );
    q = gamma + delta;

end

