clc;
clear all;

data = load('FVTreeVertexGraphCounts.txt');

% get all tree graph IDs
fileID = fopen('TreeGraphID.txt','r');
lines = textscan(fileID,'%s');
GraphIDs = string(lines{1});
fclose(fileID);

S = []; % the first feature
E = []; % the second feature

% calculate the Fiedler Vectors for all graphs
for i = 1 : size(data,1) % for every vertex number
    N = data(i,1); % number of vertices
    graph_file = sprintf('TreeAdj/V%dAdjDG', N);
    matrices = load(graph_file);
    
    for j = 1 : size(matrices, 1)/N
        AdjM = matrices((j-1)*N+1:j*N, :); % get adjacency matrix
        DegM = diag(sum(AdjM));
        LapM = DegM - AdjM;
        [V,D] = eig(LapM);
        eigenvalues = diag(D);
        [~,idx] = sort(eigenvalues);
        column = 0;
        for c = 1 : length(idx)
            if idx(c) == 2
                column = c;
            end
        end
        FV = V(:,column); % get Fiedler vector
        FV = sort(FV); % sort
        FV = FV*(N-1)/(FV(end)-FV(1)); % scale
        p = polyfit([1:N]', FV, 1); % least squares linear regression
        s = p(1);
        e = sum((polyval(p,[1:N]')-FV).^2);
        S = [S;s];
        E = [E;e];
    end
end

plot(S,E,'.');
% writematrix([GraphIDs S E],'FVTreeGraphFeatures.txt','Delimiter','tab');

%%
clc;
clear all;

data = load('FVDualVertexGraphCounts.txt');

% calculate the Fiedler Vectors
fileID = fopen('DualGraphID.txt','r'); % get all the graph IDs
lines = textscan(fileID,'%s');
GraphIDs = string(lines{1});
fclose(fileID);

S = [];
E = [];

for i = 1 : size(data,1) % for every vertex number
    N = data(i,1); % number of vertices
    graph_file = sprintf('DualAdj/V%dAdjDG', N);
    matrices = load(graph_file);
    
    for j = 1 : size(matrices, 1)/N
        AdjM = matrices((j-1)*N+1:j*N, :);
        DegM = diag(sum(AdjM));
        LapM = DegM - AdjM;
        [V,D] = eig(LapM);
        eigenvalues = diag(D);
        [~,idx] = sort(eigenvalues);
        column = 0;
        for c = 1 : length(idx)
            if idx(c) == 2
                column = c;
            end
        end
        FV = V(:,column);
        FV = sort(FV);
        FV = FV*(N-1)/(FV(end)-FV(1));
        p = polyfit([1:N]', FV, 1);
        s = p(1);
        e = sum((polyval(p,[1:N]')-FV).^2);
        S = [S;s];
        E = [E;e];
    end
end

plot(S,E,'.');
% writematrix([GraphIDs S E],'FVDualGraphFeatures.txt','Delimiter','tab');