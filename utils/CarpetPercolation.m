% A simple script to plot self-affine sets by iterating polygons
% Zhou Feng @ 2020-10-12
clc, clf, clear
tic

%% settings
p = 0.5; % percolation rate
numItrs = 4; % iteration time

% carpet setup
hh = [1/3 1/3 1/3]; % horizontal partition
vv = [1/3 1/3 1/3]; % vertical partition

% plot settings
shouldNested = false;
showTitle = false;
alphaFaces = 1;
fixAxisRatio = true;
shouldFill = true;
allBlack = false;
finalBlack = true;
finalFaceColor = 'k';
finalEdgeColor = 'k';
% grid
showGrid = false;
widthGrid = 0.05;

%% defaults
% select positions
Bar_select = ones(length(vv), length(hh));
% generate the IFS
Bar_mat = flipud(Bar_select);
[oneRows, oneCols] = find(Bar_mat > 0);
Bar_size = length(oneRows);
linearMats = cell(1, Bar_size);
translations = cell(1, Bar_size);
for i = 1:Bar_size
    linearMats{i} = [hh(oneCols(i)) 0; 0 vv(oneRows(i))];
    translations{i} = [sum(hh(1:oneCols(i))) - hh(oneCols(i));...
        sum(vv(1:oneRows(i))) - vv(oneRows(i))];
end
shapeInit = [0 1 1 0;
             0 0 1 1];

% % Sierpinski gasket
% cRatio = 1/2;
% linearMats = cell(1, 3);
% for i = 1:3
%     linearMats{i} = cRatio * eye(2);
% end
% translations = {[0; 0], [cRatio; 0], [0; cRatio]};
% shapeInit = [0 1 0; 0 0 1];

%% error handling


isCompactible = false;

if length(linearMats) == length(translations)
    isCompactible = true;
end

if ~isCompactible
    error('Illegal settings. Dimensions of the parameters does not match!')
end

% generate params
spaceDim = 2;
numInitFaces = 1;
sizeIFS = length(linearMats);
numInitPts = size(shapeInit, 2);
shapeInitFaces = 1:numInitPts;

% colors
colorsRGB = {[0 0.4470 0.7410],...
    [0.8500 0.3250 0.0980],...
    [0.9290 0.6940 0.1250],...
    [0.4940 0.1840 0.5560],...
    [0.4660 0.6740 0.1880],...
    [0.3010 0.7450 0.9330],...
    [0.6350 0.0780 0.1840]};

%% Generate points
ptsInit = shapeInit;
ptsNow = ptsInit;
sizeNow = numInitPts;
ptsTotal = cell(numItrs + 1, 1);
ptsTotal{1} = ptsInit;

for levelNow = 1:numItrs
    % generate random selection
    numShapeNow = sizeNow / numInitPts;
    indxBirth = binornd(1, p, 1, numShapeNow * sizeIFS);
    numBirth = sum(indxBirth) * numInitPts;
    ptsTmp = zeros(spaceDim, numBirth);


    indxStart = 1;
    for indexFct = 1:sizeIFS
        indxShapeTmp = indxBirth((indexFct - 1) * numShapeNow + 1:indexFct * numShapeNow);
        % index of parent points
        indxPtsTmp = logical(kron(indxShapeTmp, [1, 1, 1, 1]));
        indxEnd = indxStart + sum(indxPtsTmp) - 1;
        % index of relative points
        indxSW = logical(kron(indxShapeTmp, [1 0 0 0]));
        indxSE = logical(kron(indxShapeTmp, [0 1 0 0]));
        indxNW = logical(kron(indxShapeTmp, [0 0 0 1]));
        % generate the offsprings
        ptsTmp(:, indxStart:indxEnd) = linearMats{indexFct} * ptsNow(:, indxPtsTmp) +...
            (eye(spaceDim) - linearMats{indexFct}) * kron(ptsNow(:, indxSW), [1, 1, 1, 1]) + ...
            [translations{indexFct}(1) * kron(ptsNow(1, indxSE)-ptsNow(1, indxSW), [1 1 1 1]);
            translations{indexFct}(2) * kron(ptsNow(2, indxNW)-ptsNow(2, indxSW), [1 1 1 1])];
        
        indxStart = indxEnd + 1;
    end

    ptsNow = ptsTmp;
    sizeNow = size(ptsNow, 2);

    ptsTotal{levelNow + 1} = ptsNow;
end

%% Plot
numShapes = sizeNow / numInitPts;

if shouldNested
    figure(1)
    for i = 1:numItrs+1
        sizeTmp = size(ptsTotal{i}, 2);
        numShapesTmp = sizeTmp / numInitPts;
        facesPlot = kron(ones(numShapesTmp, 1), shapeInitFaces) + ...
            kron((0:(numShapesTmp - 1))' * numInitPts, ones(numInitFaces, 1));
        if allBlack
            colorEdges = 'k';
        else
            colorEdges = colorsRGB{mod(i+6, length(colorsRGB))+1};
            if i == numItrs + 1 && finalBlack
                colorEdges = 'k';
            end
        end
        if i == numItrs + 1 && shouldFill
            if finalBlack
                colorFaces = 'k';
            else
                colorFaces = colorEdges;
            end
        else
            colorFaces = 'none';
        end
        patch('Faces', facesPlot, ...
            'Vertices', ptsTotal{i}', ...
            'FaceColor', colorFaces, ...
            'EdgeColor', colorEdges, ...
            'FaceAlpha', alphaFaces)
        hold on
    end
    set(gca, 'XColor', 'none', 'YColor', 'none')
    if showGrid
        grid on
        set(gca, 'xtick', min(shapeInit(1,:)):widthGrid:max(shapeInit(1,:)))
        set(gca, 'ytick', min(shapeInit(2,:)):widthGrid:max(shapeInit(2,:)))
    end
    if fixAxisRatio
        axis image
    end
    if showTitle
        title(['Iteration time = ', num2str(numItrs)], 'Interpreter', 'latex');
    end
else
    figure(1)
    for i = numItrs+1
        sizeTmp = size(ptsTotal{i}, 2);
        numShapesTmp = sizeTmp / numInitPts;
        facesPlot = kron(ones(numShapesTmp, 1), shapeInitFaces) + ...
            kron((0:(numShapesTmp - 1))' * numInitPts, ones(numInitFaces, 1));
        if allBlack
            colorEdges = 'k';
        else
            colorEdges = colorsRGB{mod(i+6, length(colorsRGB))+1};
        end
        if i == numItrs + 1 && shouldFill
            colorFaces = colorEdges;
        else
            colorFaces = 'none';
        end
        patch('Faces', facesPlot, ...
            'Vertices', ptsTotal{i}', ...
            'FaceColor', finalFaceColor, ...
            'EdgeColor', finalEdgeColor, ...
            'FaceAlpha', alphaFaces)
        hold on
    end
    set(gca, 'XColor', 'none', 'YColor', 'none')

    if showGrid
        grid on
        set(gca, 'xtick', min(shapeInit(1,:)):widthGrid:max(shapeInit(1,:)))
        set(gca, 'ytick', min(shapeInit(2,:)):widthGrid:max(shapeInit(2,:)))
    end
    if fixAxisRatio
        axis image
    end
    xlim([shapeInit(1, 1) shapeInit(1, 2)])
    ylim([shapeInit(2, 1) shapeInit(2, 4)])
    if showTitle
        title(['Iteration time = ', num2str(numItrs)], 'Interpreter', 'latex');
    end
end

%% Show param
countPtsTotal = sizeNow;
countShapesTotal = numShapes;
tableResults = table(countPtsTotal, countShapesTotal);
disp(tableResults)
