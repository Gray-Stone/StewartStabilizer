clear
clc

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));


% setup parameters
[Param] = setupParam();


homePos = [ 0; 0 ; 50 ; 0 ; 0 ; 0 ] ;
homeToolF = euler2TransMatrix (homePos);

[servoAngle,Param,legError] = SteIK(Param,homeToolF);

homeBaseFrame = Rotz(0); % zero movement base frame
gFrames.homeToolF = homeBaseFrame * homeToolF ;

% tF = inv(gFrames.baseFrame)*gFrames.toolF 

% set up plots and plot the home position. 
fig = figure(100);
gFrames.baseFrame = homeBaseFrame;
[gFrames] =groundFrameGen(gFrames,Param,homeToolF);
[plotHandleList ,anis] = plotSetup(fig,gFrames,120);

bPosList = [zeros(6,1)];

%trajectory for robot to test with 
tStart = 0;
tEnd = 10;
tStep = 0.08;
for t=tStart:tStep:tEnd
    xrotValue = (0.014*sin(t/3))*sin(t*2.2) + (0.020-0.019*t)*cos(t*3);
    yrotValue = (0.01-0.016*t)*sin(t*3) + (0.015*t)*cos(t*3.5);
    zOffValue = 5 * sin(t*2) * sin(t*1.5)+6;
    xOffValue = 2.5 * sin(t*3) * cos(t*1.5);
    yOffValue = 2.5 * cos(t*3) * sin(t*1.5);

    newbPos =  [xOffValue; yOffValue ; zOffValue ; xrotValue ; yrotValue ; 0];
    
    bPosList = [bPosList newbPos];
end


 pause(0.5)
 uCount =1;
for ii = 1:size(bPosList,2)
    gFrames.baseFrame = euler2TransMatrix(bPosList(:,ii));
    toolF = inv(gFrames.baseFrame)*gFrames.homeToolF;
    [servoAngle,Param,legError] = SteIK(Param,toolF);
    
    if(isreal(servoAngle) ~= 1)
        disp("unreachable location! " +uCount)
%         disp(toolF);
        disp(bPosList(:,ii))
        uCount = uCount+1;
        continue
    end
    
    [gFrames] =groundFrameGen(gFrames,Param,toolF);

    [plotHandleList] = plotUpdate(plotHandleList ,gFrames,anis );
    pause(tStep)
end



