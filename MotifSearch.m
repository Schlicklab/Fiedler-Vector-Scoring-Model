% Find similar existing graphs for a given graph
clc;
clear all;

sigma = 1;
epsilon = 15;
r = 1.5;

fileID = fopen('FVDualGraphExistingFeatures.txt','r');
lines = textscan(fileID,'%s%f%f%f');
fclose(fileID);
IDs = string(lines{1});
ESs = lines{2};
EEs = lines{3};
Ws = lines{4};

% search in existing graphs with vertex ln<=n<=un
ln = 3;
un = 3;
data = load('FVDualGraphExistingFeatures.txt');
Ns = data(:,1);
ID = [];
ES = [];
EE = [];
W = [];
for i = 1 : length(Ns)
    n = Ns(i);
    if ln<=n && n<=un
        ID = [ID; IDs(i)];
        ES = [ES; ESs(i)];
        EE = [EE; EEs(i)];
        W = [W; Ws(i)];
    end
end

fileID = fopen('FVDualGraphFeatures.txt','r');
lines = textscan(fileID,'%s%f%f');
fclose(fileID);
id = string(lines{1});
S = lines{2};
E = lines{3};

% search similar motifs for 3_6
graph = string({'3_6'});
gs = []; % get feature S for 3_6
ge = []; % get feature E for 3_6
for n = 1 : length(graph)
    for i = 1 : length(id)
        if strcmp(id(i), graph(n))
            gs = [gs, S(i)];
            ge = [ge, E(i)];
        end
    end
end

[sortID, sortScore] = similarMotif(gs, ge, ES, EE, W, ID, sigma, epsilon, r);

sortID
sortScore


% find most similar existing graphs for given graphs
% @ gs, ge: given graphs' features s and e
% @ ES, EE: vectors of existing graphs' s and e
% @ W: weights of existing graphs
% @ ID: existing graphs' IDs
% @ sigma, epsilon, r: scoring model parameters
function [sortID, sortScore] = similarMotif(gs, ge, ES, EE, W, ID, sigma, epsilon, r)

EScore = sigma*log(W)+epsilon;
X = sqrt(ES.^2 + EE.^2);
Score = zeros(length(W),1);
% calculate the scores that the given graphs get from the existing graphs
for n = 1 : length(gs)
    tempScore = zeros(length(W),1);
    for i = 1 : length(W)
        d = sqrt((ES(i)-gs(n))^2 + (EE(i)-ge(n))^2);
        tempScore(i) = EScore(i)*exp(-r*d/X(i));
    end
    Score = Score + tempScore;
end

[sortScore, idx] = sort(Score, 'descend');
sortID = ID(idx);

end