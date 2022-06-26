%% To plot homogeneous self-similar sets by iterating intervals
% Zhou Feng @ 2022-5-20
clc, clf, clear
tic

%% settings
ratios = [1/2, 1/3, 1/4];
trans = [0, 1/3, 3/4];
intervalInit = [0, 1];

numItrs = 7; % iteration time

% plot settings
showTitle = true;
showFirstItrs = true;
numFirstItrs = numItrs;
color = 'k';
thickness = 30;

%% examples
% % mid-third Cantor set
% ratios = [1/3 1/3];
% trans = [0, 2/3];
% intervalInit = [0, 1];

% % a classic example
% ratios = [1/2, 1/3, 1/4];
% trans = [0, 1/3, 3/4];
% intervalInit = [0, 1];

%% prepare params & error handling
isCompact = false;

if length(ratios) == length(trans)
    isCompact = true;
end

if ~isCompact
    error('Illegal settings. Dimensions of the parameters does not match!')
end

spaceDim = 1;
sizeIFS = length(ratios);
trans = sort(trans);
lenInit = diff(intervalInit);
numFirstItrs = numFirstItrs + 1;

%% generate points
ptsInit = intervalInit;
ptsNow = ptsInit;
sizeNow = length(ptsNow);
ptsTotal = cell(numItrs + 1, 1);
ptsTotal{1} = ptsInit;

for levelNow = 1:numItrs
    ptsTmp = zeros(spaceDim, sizeNow * sizeIFS);

    for indexFct = 1:sizeIFS
        ptsTmp((indexFct - 1) * sizeNow + 1:indexFct * sizeNow) = ...
            ratios(indexFct) * ptsNow + trans(indexFct);
    end

    ptsNow = ptsTmp;
    sizeNow = length(ptsNow);
    ptsTotal{levelNow + 1} = ptsNow;
end

%% plot
ptsPlt = reshape(ptsNow, 2, []);
numSegments = size(ptsPlt, 2);

figure(1)
plot(ptsPlt, ...
    zeros(2, numSegments), ...
    color, "LineWidth", thickness)
set(gca, 'XColor', 'none', 'YColor', 'none')

if showTitle
    title(['Iteration time = ', num2str(numItrs)], 'Interpreter', 'latex');
end

if showFirstItrs && numItrs + 1 >= numFirstItrs
    figure(2)

    for i = 1:numFirstItrs
        ptsPltTmp = reshape(ptsTotal{i}, 2, []);
        numSegmentsTmp = size(ptsPltTmp, 2);
        plot(ptsPltTmp, zeros(2, numSegmentsTmp) - i, ...
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
countIntervalsTotal = size(ptsPlt, 2);
tableResults = table(countPtsTotal, countIntervalsTotal);
format long
disp(tableResults)
