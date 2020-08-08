function [handle] = plotVector(base , tip ,handle )
%PLOTVECTOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    if nargin==2
        handle = plot3([base(1),tip(1)] , [base(2),tip(2)] ,[base(3),tip(3)] );
    elseif nargin==3
        set(handle,'XData',[base(1),tip(1)],'YData',[base(2),tip(2)] ,'ZData',[base(3),tip(3)] );
    end

end

