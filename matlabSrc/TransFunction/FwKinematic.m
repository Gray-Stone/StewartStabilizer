function [ pos ] = FwKinematic( q )
%FWKINEMATIC return the position of four joints of the robot (joints:xyz)

 % define link length
    l1 = 169.28;
    l2 = 175;
    l3 = 169.28;

    % extract theta 
    t0 = q(1);
    t1 = q(2);
    t2 = q(3);
    
    % conver to radious
    t0=t0/180*pi;
    t1=t1/180*pi;
    t2=t2/180*pi;
    
    % feed into DH transforamtion 
    T01 = DHTrans(t0,l1,90/180*pi,0);
    T12 = DHTrans(t1,0,0,l2);
    T23 = DHTrans(t2-(90/180*pi), 0,0,l3 );
    T3tip = DHTrans (90/180*pi,0,90/180*pi,0); 

    % find overall trasformation
    T0tip = T01*T12*T23*T3tip;
    T02 = T01*T12;
    
    pos = zeros(3,4);
    % claculate end point 
    p0 = [0;0;0;1]; 
    
    pos(1,:) =p0;
    pos(2,:) = T01 *p0;
    pos (3,:)= T02 *p0;
    pos (4,:) = T0tip *p0;
    
end

