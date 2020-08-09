
clear
clc
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

% setup parameters
[Param] = setupParam();


stepLimit = 0.1;

% platform is actually able to go all the way to inverse
lowerWorkingPos = [ 0; 0 ; 0 ; 0 ; 0 ; 0 ];
% test for the upper working position. 
startPos =lowerWorkingPos;
endPos =[ 0; 0 ; 250 ; 0 ; 0 ; 0 ];
[upperWorkingPos]=testBound(Param,startPos, endPos,stepLimit);
zMin = lowerWorkingPos(3);
zMax = upperWorkingPos(3);
midZ = ((zMax - zMin)/2 + zMin);

% test for X pos range at midZ
endPos =[ -100; 0 ; midZ ; 0 ; 0 ; 0 ];
startPos =[ 0; 0 ; midZ ; 0 ; 0 ; 0 ];
[xMinPos]=testBound(Param,startPos, endPos,stepLimit);
xMin = xMinPos(1);

endPos =[ 100; 0 ; midZ ; 0 ; 0 ; 0 ];
startPos =[ 0; 0 ; midZ ; 0 ; 0 ; 0 ];
[xMaxPos]=testBound(Param,startPos, endPos,stepLimit);
xMax = xMaxPos(1);

% test for Y pos range at midZ
endPos =[ 0; -100 ; midZ ; 0 ; 0 ; 0 ];
startPos =[ 0; 0 ; midZ ; 0 ; 0 ; 0 ];
[yMinPos]=testBound(Param,startPos, endPos,stepLimit);
yMin = yMinPos(2);

endPos =[ 0; 100 ; midZ ; 0 ; 0 ; 0 ];
startPos =[ 0; 0 ; midZ ; 0 ; 0 ; 0 ];
[yMaxPos]=testBound(Param,startPos, endPos,stepLimit);
yMax = yMaxPos(2);

xyRange = max( [ -xMin -yMin xMax yMax])+10;


% finding xy COW for different Z 
figure(1)
clf(1)
for ii = 1:1:9
    
    zRange = zMax - zMin;
    TestZ = zMin + zRange * (ii/10);
    subplot(3,3,ii)
    testXYworkSpace(Param,xyRange,TestZ);
    title("COW at Z = " + TestZ);
    
end

% finding xz COW for different Y 

figure(2)
clf(2)
for ii = 1:1:9
    
    yRange = -yMin - yMin; % this to ensure centered
    TestY = yMin + yRange * ((ii-1)/8);
    subplot(3,3,ii)
    testXZworkSpace(Param,xyRange,zMax+5,TestY);
    title("COW at Y = " + TestY);
    
end

% finding max rotation angle at every direction at center xyz.  

figure(3)
clf(3)

toolPos = [0;0;midZ];
edgeFList = testXYAngleLimit(Param,toolPos);

subplot(1,2,1)
hold on 
angleList = [];
for ii = 1:size(edgeFList,2)
    scaleUP = 10;
    x= edgeFList(1,ii);
    y= edgeFList(2,ii);
    z= edgeFList(3,ii);
    u= edgeFList(4,ii)*scaleUP;
    v= edgeFList(5,ii)*scaleUP;
    w= edgeFList(6,ii)*scaleUP;
    quiver3(x,y,z,u,v,w,'color',[0.3010 0.7450 0.9330]);
    angle = acos( ( transpose(edgeFList(4:6,ii))*[0;0;1] ) / (norm(edgeFList(4:6,ii)) ) );
    angleList = [angleList angle];
end
xlim([-15 15]);
ylim([-15 15]);
zlim([midZ-15 midZ+15]);
view(3);
rotate3d on;
title("edge case of rotation workspace at x:0 y:0 z:"+midZ)

% finding min of max rotation angle on all direction at different z height.  

figure(4)
clf(4)
zAngleList = [];
testRange = zMax*0.1;
for ii = -testRange: (testRange*2)/10 :testRange
    Z  = midZ+ii;
    edgeFList = testXYAngleLimit(Param,[0;0;Z]);
    minAngle = finMinAngle (edgeFList);
    zAngleList = [zAngleList [Z;minAngle]];
end
plot(zAngleList(1,:),zAngleList(2,:)./pi*180,'o--')
xlabel('Z Height')
ylabel('Min Angle (degree)');
title("min angle at x=0 y=0 and different z height")





function [] = testXYworkSpace(Param,xyRange,Z)
    inRangeList = [];
    outRangeList = [];
    step = 1;
    for ii = -xyRange:step:xyRange
        for jj = -xyRange:step:xyRange
            toolF = euler2TransMatrix([ii;jj;Z;0;0;0]);
            [servoAngle,Param,~] = SteIK(Param,toolF);
            if(isreal(servoAngle) ==1)
                inRangeList = [inRangeList [ii;jj] ];
            else
                outRangeList = [outRangeList [ii;jj] ];
            end
        end
    end
    hold on 
	scatter(inRangeList(1,:),inRangeList(2,:),1,'g');
%     scatter(outRangeList(1,:),outRangeList(2,:),1 ,'r');
    xlabel("x");
    ylabel("y");
    xlim([-xyRange xyRange]);
    ylim([-xyRange xyRange]);

end


function [] = testXZworkSpace(Param,xRange,zRange,Y)
    inRangeList = [];
    outRangeList = [];
    step = 1;
    for ii = -xRange:step:xRange
        for jj = 0:step:zRange
            toolF = euler2TransMatrix([ii;Y;jj;0;0;0]);
            [servoAngle,Param,~] = SteIK(Param,toolF);
            if(isreal(servoAngle) ==1)
                inRangeList = [inRangeList [ii;jj] ];
            else
                outRangeList = [outRangeList [ii;jj] ];
            end
        end
    end
    hold on 
	scatter(inRangeList(1,:),inRangeList(2,:),2,'g'	);
%     scatter(outRangeList(1,:),outRangeList(2,:),1 ,'r');
    xlabel("x");
    ylabel("z");
    xlim([-xRange xRange]);
    ylim([-0 zRange]);

end


function [edgeFList] = testXYAngleLimit(Param,toolPos)
    step = 0.01;
    edgeFList = [];
    for ii = -pi/2:step:pi/2
        initFlage = 0;
        lastF = euler2TransMatrix([toolPos(1);toolPos(2);toolPos(3);ii;-pi/2;0]);
        for jj = -pi/2:step:pi/2
    %         for kk = -pi/2:0.05:pi/2  % we actually don't care too much about Z twist, 
                toolF = euler2TransMatrix([toolPos(1);toolPos(2);toolPos(3);ii;jj;0]);
                [servoAngle,Param,~] = SteIK(Param,toolF);
                currentFlag = isreal(servoAngle);

                if( currentFlag ~= initFlage)
                    % this pose has changed the condition compare to pervious one. 
                    if (currentFlag ==1)
                        edgeFList = [edgeFList [lastF(1:3,4) ; lastF(1:3,3)]];
                    else
                        edgeFList = [edgeFList [lastF(1:3,4) ; lastF(1:3,3)]];
                    end
                 initFlage   = currentFlag;
                end
                lastF = toolF;      
        end
    end

end

function minAngle = finMinAngle (edgeFList)
    angleList = [];
    for ii = 1:size(edgeFList,2)
        angle = acos( ( transpose(edgeFList(4:6,ii))*[0;0;1] ) / (norm(edgeFList(4:6,ii)) ) );
        angleList = [angleList angle];
    end
    minAngle = min(angleList);
end

function [edgeWorkingPos]=testBound(Param,startPos, endPos,stepLimit)
    % test if lower point is within range. 
    toolF = euler2TransMatrix(startPos);
    [servoAngle,Param,~] = SteIK(Param,toolF);
    initFlage = isreal(servoAngle);

    % start with lower, step up. 
    lastPos = startPos;
    scaleSpace = 0.05;
    for ii = scaleSpace:scaleSpace:1
        posRange = (endPos - startPos );
        scale = norm(posRange);
        testPos = startPos + posRange*ii;
       
        % test the pos with IK
        toolF = euler2TransMatrix(testPos);
        [servoAngle,Param,~] = SteIK(Param,toolF);
        currentFlag = isreal(servoAngle);
        
        if( currentFlag ~= initFlage)
            % this pose has changed the condition compare to pervious one. 
            if (scale*scaleSpace <= stepLimit)
                % the resolution is enough
                if (currentFlag ==1)
                    edgeWorkingPos = testPos;
                else
                    edgeWorkingPos = lastPos;
                end
                return
            end
            % resolution is not enough, keep testing
            [edgeWorkingPos]=testBound(Param , lastPos, testPos , stepLimit);
            return
        end
        % nothing changed, next one, 
        lastPos = testPos;
    end
    % there isn't a position change, 
    edgeWorkingPos = startPos;
end

% homePos = [ 0; 0 ; 70 ; 0 ; 0 ; 0 ] ;
% homeToolF = euler2TransMatrix (homePos);
% 
% [servoAngle,Param,legError] = SteIK(Param,homeToolF);
% 
% homeBaseFrame = Rotz(0); % zero movement base frame
% gFrames.homeToolF = homeBaseFrame * homeToolF ;
% 
% % tF = inv(gFrames.baseFrame)*gFrames.toolF 
% 
% % set up plots and plot the home position. 
% fig = figure(100);
% gFrames.baseFrame = homeBaseFrame;
% [gFrames] =groundFrameGen(gFrames,Param,homeToolF);
% [plotHandleList ,anis] = plotSetup(fig,gFrames,120);
