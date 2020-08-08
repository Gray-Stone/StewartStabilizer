function [  plotHandleList ,anis ] = plotSetup( fig ,gFrames , limit  )
%PLOTSETUP setup four view and axies return (plot1-4)*(link1-3)

%%%%%%% define some peramter 
trackLength  = 30;

sc = get(0,'ScreenSize'); % get screen size 
clf(fig)
set(fig, 'Position', [sc(3)/15 sc(4)/15 sc(4)/10*8 sc(4)/10*8]); % setup figure base on screen size

%     plots  = [10,11,12;
%            20,21,22;
%            30,31,32;
%            40,41,42 ] ;
    
    
    function [plotHandle] = setupOnePlot()
        plotHandle = struct();
        
        %  plot base and top ring
        x= gFrames.uFrames(1,4,:);        y= gFrames.uFrames(2,4,:);        z= gFrames.uFrames(3,4,:);
        plotHandle.baseSurf = fill3( x(:) , y(:), z(:) ,[0 0 0]);
        %         plotHandle.baseSurf.Vertices(:,:) = [x(:),y(:),z(:)]
        x= gFrames.sBaseFrames(1,4,:);        y= gFrames.sBaseFrames(2,4,:);        z= gFrames.sBaseFrames(3,4,:);
        plotHandle.plateSurf = fill3( x(:) , y(:), z(:) ,[0 0 0]);

        % plot 6 legs.
        for ii=1:6
            plotHandle.arm(ii) = plotVector(gFrames.uFrames(1:3,4,ii) , gFrames.armTipFrames(1:3,4,ii));
            plotHandle.leg(ii) = plotVector(gFrames.armTipFrames(1:3,4,ii) , gFrames.sBaseFrames(1:3,4,ii));
        end

        % plot arrow        
        x= gFrames.baseFrame(1,4);
        y= gFrames.baseFrame(2,4);
        z= gFrames.baseFrame(3,4);
        tipX= gFrames.toolF(1,4) - gFrames.baseFrame(1,4);
        tipY= gFrames.toolF(2,4) - gFrames.baseFrame(2,4);
        tipZ= gFrames.toolF(3,4) - gFrames.baseFrame(3,4); 
        plotHandle.baseArrow = quiver3(0,0,0,x,y,z);
        plotHandle.toolArrow = quiver3(x,y,z,tipX,tipY,tipZ);

        %setup colors
        plateColor = [0.3010 0.7450 0.9330];
        baseColor = [0.56 0.53 0.55];
        set(plotHandle.baseSurf,'facealpha',.3,'LineWidth',2,'EdgeColor',baseColor,'FaceColor',baseColor);
        set(plotHandle.plateSurf,'facealpha',.3,'LineWidth',2,'EdgeColor',plateColor,'FaceColor',plateColor);
        for ii = 1:6
            set(plotHandle.arm(ii),'MarkerSize',4,'Marker','o','LineWidth',2,'color',[0.8500 0.3250 0.0980]);
            set(plotHandle.leg(ii),'MarkerSize',4,'Marker','o','LineWidth',2,'color',[0.4660 0.6740 0.1880]);
        end
        set(plotHandle.baseArrow,'LineWidth',3,'color',baseColor , 'MaxHeadSize',6,'AutoScale','off')
        set(plotHandle.toolArrow,'LineWidth',3,'color',plateColor, 'MaxHeadSize',6,'AutoScale','off')
        anis(ii) = animatedline(tipX,tipY,tipZ,'MaximumNumPoints',trackLength,'linewidth',2);


        xlim([-limit limit]);
        ylim([-limit limit]);
        zlim([-limit*0.3 limit*1.7]);
        xlabel("x");
        ylabel("y");
        zlabel("z");
    end


    plotHandleList = [];
    
%     Isometric view
    subii = 1;
    subplot(2,2,subii,'Parent',fig);
    hold on 
    plotHandleList = [plotHandleList setupOnePlot()];

    hold off 
    grid on
    view(3);
    rotate3d on;
    title("isometric");

%     xz view
    subii = 2;
    subplot(2,2,subii,'Parent',fig);
    hold on 
    plotHandleList(subii) = setupOnePlot();
    hold off
    
    grid on
    view(0,0);
    title("x-z plane");


%     xy view
    subii = 3;
    subplot(2,2,subii,'Parent',fig);
    hold on 
    plotHandleList(subii) = setupOnePlot();
    hold off
    
    grid on
    view(0,90);
    title("x-y plane");


% yz view
    subii = 4;
    subplot(2,2,subii,'Parent',fig);
    hold on 
    plotHandleList(subii) = setupOnePlot();
    hold off
    
    grid on
    view(-90,0);
    title("y-z plane");
    
%     track end effector position line.
%     for ii=1:4
%         subplot(2,2,ii);
% %         anis(ii) = animatedline('linewidth',1.5);
%     end 
    drawnow

end

