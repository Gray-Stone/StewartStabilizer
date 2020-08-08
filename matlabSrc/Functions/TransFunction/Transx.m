function [transx ] = Transx(d)
%TRSX output 4*4 matrix translate d along x 

    transx = [ 1,0,0,d; 0,1,0,0; 0,0,1,0; 0,0,0,1;] ;
%     transx = eye(4);
%     transx = sym(transx) ;
%     transx(1,4) = d;

end

