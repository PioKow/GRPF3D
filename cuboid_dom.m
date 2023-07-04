function [NodesCoord,Scale] = cuboid_dom(Domain,InitNrOfNodes,NodesMax,varargin)
%  rect_dom : generates the initial mesh for cuboid domain
%
% INPUTS
%  Domain         : [xb yb tb; xe ye te]
%  InitNrOfNodes  : number of initial points
%  NodesMax       : total number of the points
%  varargin       : Scale (empty by default, in order to scale the domain to a cube) 
%
% OUTPUTS
%  NodesCoord     : coordinates of points in the scaled space R3
%  Scale          : a 3-row vector corresponding to (x,y,t) 
%                   each component of the NodesCoord is multiply by these values
%                   in order to obtain the primary domain
%

NodesCoord=[];
Scale = [];
x = Domain(:,1);
y = Domain(:,2);
t = Domain(:,3);
if(x(2)<=x(1) || y(2)<=y(1) || t(2)<=t(1))
    return
end

if(InitNrOfNodes<27)
    InitNrOfNodes = 27;
end
N = round(InitNrOfNodes^(1/3));

if(~isempty(varargin))
    Scale = varargin{1};
end

if isnumeric(Scale) && sum(size(Scale) == [1 3])
    x = x./Scale(1);
    y = y./Scale(2);
    t = t./Scale(3);
    Scale(2,:) = 0;

    dx = x(2)-x(1);
    dy = y(2)-y(1);
    dz = t(2)-t(1);
    diff = median([dx dy dz]);
    dmax = diff/(N-1);

    Nx = ceil((dx)/dmax+1);
    Ny = ceil((dy)/dmax+1);
    Nt = ceil((dz)/dmax+1);
    if(Nx<3)
        Nx = 3;
    elseif(Ny<3)
        Ny = 3;
    elseif(Nt<3)
        Nt = 3;
    end
else
    Scale = [(x(2)-x(1)),(y(2)-y(1)),(t(2)-t(1)); x(1),y(1),t(1)];
    x = [0;  1];
    y = [0;  1];
    t = [0;  1];
    Nx = N;
    Ny = N;
    Nt = N;
end

if(Nx*Ny*Nt<=NodesMax)
    [xx,yy,tt]=meshgrid(linspace(x(1),x(2),Nx), linspace(y(1),y(2),Ny), linspace(t(1),t(2),Nt));
    NodesCoord = [reshape(xx,Nx*Ny*Nt,1), reshape(yy,Nx*Ny*Nt,1), reshape(tt,Nx*Ny*Nt,1)];
end

end

