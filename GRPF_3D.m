% Copyright (c) 2023 Gdansk University of Technology
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%
% Authors: S.Dziedziewicz M.Warecka R.Lech P.Kowalczyk
% Project homepage: https://github.com/PioKow/GRPF3D
%
%
% main program GRPF3D
%
close all;
clear all;
clc;
format long;
restoredefaultpath

%choose the example
addpath('2_cylindrical_waveguide');
%addpath('3_graphene_transmission_line');

analysis_parameters %input file

%generates the initial mesh
[NewNodesCoord,Scale] = cuboid_dom([xb yb tb; xe ye te],ceil(InitNodesRatio*NodesMax),NodesMax,Scale);

%initialization of the variables
if(isempty(NewNodesCoord))
    FinalMessage = 'Something is wrong with the initial mesh. Check parameters such as Domain, Scale, or InitNodesRatio.';
    Flag=-1;
else
    Flag=0;
end
it=0;
NodesCoord = [];
NrOfNodes = size(NodesCoord,1);

%% general loop
while it<ItMax && Flag==0

    %function evaluation
    NodesCoord=[NodesCoord; NewNodesCoord];
    NodesCoordTrue = Scale(2,:)+(NodesCoord.*Scale(1,:));
    disp(['Evaluation of the function in ',num2str(size(NewNodesCoord,1)),' new points...'])

    for Node=NrOfNodes+1:NrOfNodes+size(NewNodesCoord,1)
        FunctionValues(Node,1) = fun(NodesCoordTrue(Node,:),Optional);
    end

    %%% meshing operation
    NrOfNodes=size(NodesCoord,1);
    disp(['Triangulation and analysis of ',num2str(NrOfNodes),' nodes...'])
    DT = delaunayTriangulation(NodesCoord(:,1),NodesCoord(:,2),NodesCoord(:,3));
    Edges = edges(DT);

    %phase analysis
    CandidateEdges= Edges(abs(dPhase(FunctionValues(Edges(:,1),:),FunctionValues(Edges(:,2),:))) >= pi/2,:);
    CandidateEdgesLength = vecnorm(NodesCoord(CandidateEdges(:,2),:)-NodesCoord(CandidateEdges(:,1),:),2,2);
    disp(['Current number of suspect edges: ',num2str(size(CandidateEdges,1))]);

    %%% density of the mesh
    EdgesToSplit = CandidateEdges(CandidateEdgesLength>MinEdgesLength,:);
    if(isempty(EdgesToSplit))
        if(isempty(CandidateEdges))
            FinalMessage = 'Probably no roots in the domain!'; 
        else
            FinalMessage = 'The maximum possible accuracy has been achieved (increase MinEdgesLength parameter)';
        end
        Flag=1;
    elseif(NrOfNodes<NodesMax)
        if(Visual>1) %visualization
            vis(NodesCoord, CandidateEdges,0)
        end
        if((NrOfNodes+size(EdgesToSplit,1))>NodesMax)
            [~,idOfEdgesToSplitSort]=sort(CandidateEdgesLength(CandidateEdgesLength>MinEdgesLength,:),'descend');
            EdgesToSplit = EdgesToSplit(idOfEdgesToSplitSort(1:(NodesMax-NrOfNodes)),:);
        end
    else
        Flag=-1;
        if(Visual>0) %visualization
            vis(NodesCoord, CandidateEdges,0)
        end
        disp('The assumed number of points has been achieved - do you want to continue the analysis?');
        while Flag<0
            str = input('Give a new value of the NodesMax parameter or enter [c] to cancel: ','s');
            if(str=="c")
                FinalMessage = ['The assumed number of points has been achieved in iteration: ',num2str(it+1)];
                Flag=1;
            else
                NewNodesMax=round(real(str2double(str)));
                if(NewNodesMax>NodesMax)
                    [~,idOfEdgesToSplitSort]= sort(vecnorm(NodesCoord(Edges(:,2),:)-NodesCoord(Edges(:,1),:),2,2),'descend');
                    NewInitEdgesToSplit = Edges(idOfEdgesToSplitSort(1:ceil((NewNodesMax-NodesMax)*InitNodesRatio)),:);
                    NodesMax = NewNodesMax;
                    if((NrOfNodes+size(NewInitEdgesToSplit,1)+size(EdgesToSplit,1))>NodesMax)
                        [~,idOfEdgesToSplitSort]=sort(CandidateEdgesLength(CandidateEdgesLength>MinEdgesLength,:),'descend');
                        EdgesToSplit = EdgesToSplit(idOfEdgesToSplitSort(1:(NodesMax-NrOfNodes-size(NewInitEdgesToSplit,1))),:);
                    end
                    EdgesToSplit = [EdgesToSplit; NewInitEdgesToSplit];
                    Flag=0;
                end
            end
        end
    end

    %split the edge in half
    if(~isempty(EdgesToSplit) && Flag ==0)
        NewNodesCoord = unique((NodesCoord(EdgesToSplit(:,1),:) + NodesCoord(EdgesToSplit(:,2),:))/2,'rows');
    end

    it=it+1;
    disp(['Iteration : ',num2str(it), ' done'])
    disp('----------------------------------------------------------------')
end

%summary of the analysis
if(it>=ItMax && Flag==0)
    FinalMessage = 'The maximum number of iterations has been reached';
end

disp(FinalMessage)
if(Flag>=0)
    roots = (NodesCoordTrue(CandidateEdges(:,1),:)+NodesCoordTrue(CandidateEdges(:,2),:))/2;
    if(Visual>0)
        vis(NodesCoordTrue, CandidateEdges,1,[xb yb tb; xe ye te])
    end
end

