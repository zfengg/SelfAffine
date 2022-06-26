%% To plot homogeneous self-similar sets by iterating intervals
% Zhou Feng @ 2022-5-20
clc, clf, clear
tic

%% settings
% num of maps
numMaps = 2;
% contract ratio
ratio = 1/3;
% translations
trans = [0, 2/3];
% initial inverval
intervalInit = [0, 1];

numItrs = 5; % iteration time

% plot settings
showTitle = true;
showFirstItrs = true;
numFirstItrs = numItrs;
color = 'k';
thickness = 30;

%% examples
% % mid-third Cantor set
% numMaps = 2;
% ratio = 1/3;
% trans = [0, 2/3];
% intervalInit = [0, 1];

% % lambda Cantor set
% numMaps = 3;
% ratio = 1/3;
% lambda = 1/2;
% trans = [0, 2/3, lambda / 3];
% intervalInit = [0, 1];

% % Bernoulli convolutions
% numMaps = 2;
% ratio = 0.4;
% trans = [0, 1 - ratio];
% intervalInit = [0, 1];

% % an example
% numMaps = 5;
% a = 3;
% ratios = 1/3 * ones(1, numMaps);
% trans = [0, a.^ - (0:1:(numMaps - 2))];
% intervalInit = [0, 1.5];

%% prepare params & error handling
isCompact = false;

if numMaps == length(trans)
    isCompact = true;
end

if ~isCompact
    error('Illegal settings. Dimensions of the parameters does not match!')
end

ratios = ratio * ones(1, numMaps);
trans = sort(trans);
lenInit = diff(intervalInit);
numFirstItrs = numFirstItrs + 1;

%% generate points
ptsInit = intervalInit(1);
ptsNow = ptsInit;
sizeNow = length(ptsNow);
ptsTotal = cell(numItrs + 1, 1);
ptsTotal{1} = ptsInit;

for levelNow = 1:numItrs
    ptsTmp = kron(ptsNow, ratios) + kron(ones(1, sizeNow), trans);
    ptsNow = unique(ptsTmp);
    sizeNow = length(ptsNow);
    ptsTotal{levelNow + 1} = ptsNow;
end

%% plot
lenBasic = ratio^numItrs * lenInit;
ptsDiff = diff(ptsNow);
indexGaps = ptsDiff > lenBasic;
ptsLeft = ptsNow([true indexGaps]);
numSegments = length(ptsLeft);
ptsRight = [ptsNow([false, indexGaps]) - ptsDiff(indexGaps), ptsNow(end)] + lenBasic;

figure(1)
plot([ptsLeft; ptsRight], ...
    zeros(2, numSegments), ...
    color, "LineWidth", thickness)
set(gca, 'XColor', 'none', 'YColor', 'none')

if showTitle
    title(['Iteration time = ', num2str(numItrs)], 'Interpreter', 'latex');
end

if showFirstItrs && numItrs + 1 >= numFirstItrs
    figure(2)

    for i = 1:numFirstItrs
        lenBasicTmp = ratio^(i - 1) * lenInit;
        ptsDiffTmp = diff(ptsTotal{i});
        indexGapsTmp = ptsDiffTmp > lenBasicTmp;
        ptsLeftTmp = ptsTotal{i}([true indexGapsTmp]);
        numSegmentsTmp = length(ptsLeftTmp);
        ptsRightTmp = [ptsTotal{i}([false, indexGapsTmp]) - ptsDiffTmp(indexGapsTmp), ...
                                    ptsTotal{i}(end)] + lenBasicTmp;
        plot([ptsLeftTmp; ptsRightTmp], ...
            zeros(2, numSegmentsTmp) - i, ...
            color, "LineWidth", thickness)
        hold on
    end

    hold off
    set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')

    if showTitle
        title(['Iteration time = ', num2str(numFirstItrs - 1)], 'Interpreter', 'latex');
    end

    ylim([- numFirstItrs - 0.5 * thickness / 50, 0])
end

%% show param
countPtsTotal = sizeNow;
countShapesTotal = size(ptsLeft, 2);
tableResults = table(countPtsTotal, countShapesTotal);
format long
disp(tableResults)
