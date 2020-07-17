function [transy ] = Transy(d)
%TRSY output 4*4 matrix translate d along y 
     transy = [ 1,0,0,0; 0,1,0,d; 0,0,1,0; 0,0,0,1;] ;

%     transy = eye(4);
%     transy = sym(transy);
%     transy(2,4) = d;

end