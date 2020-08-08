function [transz ] = Transz(d)
%TRSZ output 4*4 matrix translate d along z
    transz = [ 1,0,0,0; 0,1,0,0; 0,0,1,d; 0,0,0,1;] ; % this way matlab could automatically do symbalic or double

end