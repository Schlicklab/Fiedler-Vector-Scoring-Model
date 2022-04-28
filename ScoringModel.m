% Calculate scores for all tree graphs
clc;
clear all;

sigma = 1;
epsilon = 5;
r = 1.5;

fileID=fopen('FVTreeGraphFeatures.txt','r');
lines=textscan(fileID,'%s%f%f%f');
fclose(fileID);
GraphIDs=string(lines{1});
S = [lines{2}];
E = [lines{3}];

data = load('FVTreeGraphExistingFeatures.txt');
ES = data(:,2);
EE = data(:,3);
weights = data(:,4);
EScore = sigma*log(weights)+epsilon; % initial scores of the existing graphs
X = sqrt(ES.^2 + EE.^2); % distances of the existing graphs from the origin

Score = zeros(length(S),1);
for j = 1 : length(S) % for each graph j
    for i = 1 : length(ES) % for each existing graph i
        d = sqrt((ES(i)-S(j))^2 + (EE(i)-E(j))^2); % distance between graph j and existing graph i
        Score(j) = Score(j) + EScore(i)*exp(-r*d/X(i)); % add the score graph j gets from existing graph i
    end
end

Score = Score/max(Score)*100; % scale scores

figure;
scatter(S, E, 20, Score, 'filled');
colorbar;


%% Calculate scores for all dual graphs
clc;
clear all;

sigma = 1;
epsilon = 5;
r = 1.5;

data = load('FVDualGraphExistingFeatures.txt');
ES = data(:,2);
EE = data(:,3);
weights = data(:,4);
EScore = sigma*log(weights)+epsilon;
X = sqrt(data(:,2).^2 + data(:,3).^2);

data = load('FVDualGraphFeatures.txt');
S = data(:,2);
E = data(:,3);
Score = zeros(length(S),1);
for j = 1 : length(S)
    for i = 1 : length(ES)
        d = sqrt((ES(i)-S(j))^2 + (EE(i)-E(j))^2);
        Score(j) = Score(j) + EScore(i)*exp(-r*d/X(i));
    end
end

Score = Score/max(Score)*100;

figure;
scatter(S, E, 20, Score, 'filled');
colorbar;
