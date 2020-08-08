% clear

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));


% setup parameters
Param = {};
[Param] = setupParam(Param);


homePos = [ 0; 0 ; 70 ; 0 ; 0 ; 0 ] ;
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

% move up
for ii=2:2:10
    newbPos = bPosList(:,end) + [0; 0 ; 2 ; 0 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end

% rotate x
for ii=0.02:0.02:0.08
    newbPos = bPosList(:,end) + [0; 0 ; 0 ; 0.02 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end

% move x
for ii=2:2:8
    newbPos = bPosList(:,end) + [ 2 ; 0 ; 0 ; 0 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end


% move y
for ii=2:2:4
    newbPos = bPosList(:,end) + [ 0 ; 2 ; 0 ; 0 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end

% rotate -x
for ii=0.02:0.02:0.08
    newbPos = bPosList(:,end) + [0; 0 ; 0 ; -0.02 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end

% move -x
for ii=2:2:8
    newbPos = bPosList(:,end) + [ -2 ; 0 ; 0 ; 0 ; 0 ; 0];
    bPosList = [bPosList newbPos];
end

% move -z
for ii=2:2:10
    newbPos = bPosList(:,end) + [ 0 ; 0 ; -2 ; 0 ; 0 ; 0];
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
    pause(0.1)
end



