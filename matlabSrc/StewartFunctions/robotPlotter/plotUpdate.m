function [plotHandleList] = plotUpdate(plotHandleList ,gFrames,anis )
%PLOTUPDATE update the lnks in plots by gFrames and trace out tips path

    for subii = 1:4
        plotHandle = plotHandleList(subii);
        x= gFrames.uFrames(1,4,:); y= gFrames.uFrames(2,4,:); z= gFrames.uFrames(3,4,:);
        plotHandle.baseSurf.Vertices(:,:) = [x(:),y(:),z(:)];
        x= gFrames.sBaseFrames(1,4,:); y= gFrames.sBaseFrames(2,4,:); z= gFrames.sBaseFrames(3,4,:);
        plotHandle.plateSurf.Vertices(:,:) = [x(:),y(:),z(:)];

        for ii=1:6
            plotHandle.arm(ii) = plotVector(gFrames.uFrames(1:3,4,ii) , gFrames.armTipFrames(1:3,4,ii) ,plotHandle.arm(ii));
            plotHandle.leg(ii) = plotVector(gFrames.armTipFrames(1:3,4,ii) , gFrames.sBaseFrames(1:3,4,ii),plotHandle.leg(ii));
        end
      % plot arrow        
        x= gFrames.baseFrame(1,4);
        y= gFrames.baseFrame(2,4);
        z= gFrames.baseFrame(3,4);
        tipX= gFrames.toolF(1,4) - gFrames.baseFrame(1,4);
        tipY= gFrames.toolF(2,4) - gFrames.baseFrame(2,4);
        tipZ= gFrames.toolF(3,4) - gFrames.baseFrame(3,4); 
        
        set(plotHandle.baseArrow,'udata',x,'vdata',y,'wdata',z);
        set(plotHandle.toolArrow,'XData',x,'YData',y,'ZData',z,'udata',tipX,'vdata',tipY,'wdata',tipZ);
        if nargin==3
            addpoints( anis(ii),tipX,tipY,tipZ)
        end
        drawnow
    end
      
        
end

