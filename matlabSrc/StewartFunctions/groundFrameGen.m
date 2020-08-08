function [gFrames] =groundFrameGen(gFrames,Param,toolF)
%GROUNDFRAMEGEN generate all robot frames wrt ground. 
%   此处显示详细说明

    for ii = 1:6
        gFrames.uFrames(:,:,ii) = gFrames.baseFrame * Param.uFrames(:,:,ii);
        gFrames.armTipFrames(:,:,ii) = gFrames.baseFrame * Param.armTipFrames(:,:,ii);
        gFrames.sBaseFrames(:,:,ii) = gFrames.baseFrame * Param.sBaseFrames(:,:,ii);
    end

    gFrames.toolF = gFrames.baseFrame * toolF;
end