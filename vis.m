function vis(NodesCoord, Edges,Stage,varargin)
%  vis: canditates edges visualization
%
% INPUTS
%
%  NodesCoord  : nodes coordinates
%  Edges       : edges definition
%  Stage       : 0 consecutive iterations / 1 final results
%  varargin    : optional axis limits
%

roots = (NodesCoord(Edges(:,1),:)+NodesCoord(Edges(:,2),:))/2;

figure()
hold on
plot3(roots(:,1),roots(:,2),roots(:,3),'k.','MarkerSize',0.5)
view(-30,45)
grid on

if(Stage==0)
    xlabel('Re(z) [scaled]');
    ylabel('Im(z) [scaled]');
    zlabel('t [scaled]');
    title(['number of nodes = ',num2str(size(NodesCoord,1))])
elseif(Stage==1)
    xlabel('Re(z)');
    ylabel('Im(z)');
    zlabel('t');
    title(['Final results: ','number of nodes = ',num2str(size(NodesCoord,1))])
end

if(~isempty(varargin))
    Domain = varargin{1};
    xlim([Domain(:,1)])
    ylim([Domain(:,2)])
    zlim([Domain(:,3)])
end

drawnow;
hold off

end

