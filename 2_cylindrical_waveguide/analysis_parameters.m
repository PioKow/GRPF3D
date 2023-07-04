% this file contains all parameters of the analysis
% the cubid domain size: xb,xe,yb,ye,tb,te
% NodesMax, Visual
% advanced parameters: Optional,Scale,InitNodesRatio
% buffers: ItMax,MinEdgesLength

%domain size
xb = -4.5;  % real part range begin 
xe = 4.5;  % real part range end
yb = -0.25;  % imag part range begin
ye =  2.5;  % imag part range end 
tb = 2*1e9;  % addational paramter range begin
te = 7*1e9;  % addational paramter range end 

% a maximum number of the function calls 
% accuracy is indirectly related to this parameter
% set carefully depending on the numerical complexity of the function
NodesMax = 100000;

Visual = 2; 
%%%% results visualization modes, plots the curve of the roots  
% 0 - no
% 1 - only last iteration
% 2 - all iterations and results

%% constants (change only if you are an advanced user)

Optional = []; % any optional fun parameters

% empty by default, in order to scale the domain to a cube
Scale = []; 
%Scale = [1,1,1e9]; 
% another possibility, an example of how to manually scale the domain
% a 3-row vector corresponding to (x,y,t) 
% each component of the domain is divided by these values.

InitNodesRatio = 0.01;
% ratio of the number of the initial mesh points to the total number of points
% usually one percent of NodesMax

%buffers
ItMax = 100; % maximum number of iterations
MinEdgesLength = 1e-9; % minimum length of the candidate's edges

