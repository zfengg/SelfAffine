% A simple script to plot self-affine sets by iterating polygons
% Zhou Feng @ 2020-10-12
clc, clf, clear
tic

%% settings
% a = 3/5; b = 5/7;
a = 3/5; b = 2/3;
% a = 3/5; b = 5/7;
% a = 3/11; b = 11/13;
% a = 5/17; b = 17/19;
linearMats = {[b 0; 0 a], [a 0; 0 b]};
translations = {[0; 0], [(b+1-a)/2; (a+1-b)/2]};
shapeInit = [0 1 1 0; 0 0 1 1];

numItrs = 1; % iteration time

% plot settings
% format
showTitle = false;
fixAxisRatio = true;
colorFaces = repelem("black", numItrs+1);
alphaFaces = 0.3/(numItrs+1) * (1:1:numItrs+1);
% alphaFaces = 0.1 * ones(1, numItrs + 1);
colorEdges = repelem("black", numItrs+1);
alphaEdges = ones(1, numItrs + 1);
% figures
showItrs = false; % show intermediate iterations
showHistory = false; % plot previous iterations
saveFigures = false;
filename = "imgs/test"; % the prefix for saved files
fileExt = ".png"; % file format: .pdf, .png, .jpg, .fig
fixBoundary = true; % fix the boundary as the initial polygon
rmWhite = true;
% grid
showGrid = false;
widthGrid = 0.05;

%% Examples
% % --- Hochman's talk ----------
% % non-overlap self-similar set
% numMaps = 3;
% rotDeg = [0, 17, 60]; % unit in degree in [0, 360]
% ratios = 1/4 * ones(1, numMaps);
% linearMats = cell(1, numMaps);
% for i = 1:numMaps
%     linearMats{i} = ratios(i) * [cosd(rotDeg(i)) -sind(rotDeg(i));...
%         sind(rotDeg(i)) cosd(rotDeg(i))];
% end
% translations = {[1/10; 6/10],...
%     [1/5; 1/8],...
%     [4/5; 3/10]};
% shapeInit = [0 1 1 0;
%     0 0 1 1];

% % overlapping self-similar set
% numMaps = 3;
% rotDeg = [0, 17, 90]; % unit in degree in [0, 360]
% ratios = 1/3 * ones(1, numMaps);
% linearMats = cell(1, numMaps);
% for i = 1:numMaps
%     linearMats{i} = ratios(i) * [cosd(rotDeg(i)) -sind(rotDeg(i));...
%         sind(rotDeg(i)) cosd(rotDeg(i))];
% end
% translations = {[1.5; 0.2],...
%     [0.25; 0.4],...
%     [2.7; 0.6]};
% shapeInit = [0 3 3 0;
%              0 0 2 2];

% ---------------------------------- gaskets --------------------------------- %
% % Sierpinski gasket
% cRatio = 1/2;
% linearMats = cell(1, 3);
% for i = 1:3
%     linearMats{i} = cRatio * eye(2);
% end
% translations = {[0; 0], [cRatio; 0], [0; cRatio]};
% shapeInit = [0 1 0; 0 0 1];

% % Sierpinski gasket (self-affine)
% hRatio = 0.25;
% vRatio = 0.7;
% linearMats = {[hRatio 0; 0 vRatio],
%               [1 - hRatio 1 - hRatio - vRatio; 0 vRatio],
%               [1 - vRatio 0; 0 1 - vRatio]};
% translations = {[0; 0], [hRatio; 0], [0; vRatio]};
% shapeInit = [0 1 0; 0 0 1];

% ---------------------------------- carpets --------------------------------- %
% % Sierpinski carpet
% linearMats = cell(1, 8);
% for i = 1:8
%     linearMats{i} = 1/3 * eye(2);
% end
% translations = {[0;0], [1;0], [2;0], [0;1], [2;1], [0;2], [1;2], [2;2]};
% shapeInit = [0 3 3 0; 0 0 3 3];
%
% % Bedford-McMullen carpet
% BMselect = [0 1 0;
%         1 0 1]; % select positions
% [BMv, BMh] = size(BMselect);
% BMmat = flipud(BMselect);
% [oneRows, oneCols] = find(BMmat > 0);
% BMsize = length(oneRows);
% BMlinear = [1 / BMh 0; 0 1 / BMv];
% linearMats = cell(1, BMsize);
% translations = cell(1, BMsize);
% for i = 1:BMsize
%     linearMats{i} = BMlinear;
%     translations{i} = [(oneCols(i) - 1) * (1 / BMh); (oneRows(i) - 1) * (1 / BMv)];
% end
% shapeInit = [0 1 1 0; 0 0 1 1];

% % Baranski carpet (with possible overlaps)
% Bar_h = [0.1 0.3 0.4 0.2]; % horizontal scales
% Bar_v = [0.1 0.2 0.4 0.3]; % vertical scales
% Bar_select = [1 0 1 0;
%               0 1 0 1;
%               0 0 0 0;
%               0 0 1 0]; % select positions
% Bar_mat = flipud(Bar_select);
% [oneRows, oneCols] = find(Bar_mat > 0);
% Bar_size = length(oneRows);
% linearMats = cell(1, Bar_size);
% translations = cell(1, Bar_size);
% for i = 1:Bar_size
%     linearMats{i} = [Bar_h(oneCols(i)) 0; 0 Bar_v(oneRows(i))];
%     translations{i} = [sum(Bar_h(1:oneCols(i))) - Bar_h(oneCols(i));...
%         sum(Bar_v(1:oneRows(i))) - Bar_v(oneRows(i))];
% end
% shapeInit = [0 1 1 0; 0 0 1 1];

% --------------------------------- triangles -------------------------------- %
% % Sierpinski triangle
% cRatio = 1/2;
% linearMats = cell(1, 3);
% for i = 1:3
%     linearMats{i} = cRatio * eye(2);
% end
% translations = {[0; 0], [1-cRatio; 0], [0.5*(1-cRatio); (1-cRatio)*0.5*sqrt(3)]};
% shapeInit = [0 1 0.5; 0 0 0.5*sqrt(3)];

% % Sierpinski triangle (self-affine)
% ratio1st = 2/3;
% ratio2nd = 2/3;
% linearMats = {[ratio1st * (1 - ratio2nd) ratio1st * (2 * ratio2nd - 1) / sqrt(3);...
%     0 ratio1st * ratio2nd], ...
%     [ratio1st * (1 - ratio2nd) 0; 0 ratio1st * (1 - ratio2nd)], ...
%     [ratio1st * ratio2nd 0; 0 ratio1st * ratio2nd], ...
%     [1 - ratio1st 0; 0 1 - ratio1st], ...
%     [1/2 (1/2 - ratio1st) / sqrt(3); sqrt(3) / 2 - sqrt(3) * ratio1st 1/2]};
% translations = {[0; 0], [ratio1st * ratio2nd / 2; ratio1st * ratio2nd * sqrt(3) / 2],...
%     [ratio1st * (1 - ratio2nd); 0], ...
%     [ratio1st; 0], [ratio1st / 2; ratio1st * sqrt(3) / 2]};
% shapeInit = [0 1 0.5; 0 0 0.5 * sqrt(3)];

% ----------------------------------- dusts ---------------------------------- %
% % Cantor dust
% linearMats = cell(1, 4);
% for i = 1:4
%     linearMats{i} = 0.25 * eye(2);
% end
% translations = {[0.26; 0], ...
%     [0.75; 0.25], ...
%     [0; 0.5], ...
%     [0.5; 0.75]};
% shapeInit = [0 1 1 0; 0 0 1 1];

% % product Cantor set
% linearMats = cell(1, 4);
% for i = 1:4
%     linearMats{i} = 1/3 * eye(2);
% end
% translations = {[0; 0], [2/3; 0], [0; 2/3], [2/3; 2/3]};
% shapeInit = [0 1 1 0; 0 0 1 1];

% ----------------------------------- misc ----------------------------------- %
% % Dim of self-affine sets is discontinuous
% ratioDimDiscts = 0.1;
% linearMats = {[0.5 0; 0 1/3], [0.5 0; 0 1/3]};
% translations = {[0; 2/3], [ratioDimDiscts; 0]};
% shapeInit = [0 1 1 0; 0 0 1 1];

% % attenna
% linearMats = {[0.25 0; 0 0.25], [0.25 0; 0 0.25], [0.25 0; 0 0.25],...
%               [0.25 0; 0 0.25], [0.5 0; 0 0.5]};
% translations = {[0; 0], [0.75; 0], [0.75; 0.75], [0; 0.75], [0.25; 0.25]};
% shapeInit = [0 1 1 0; 0 0 1 1];

% % Overlapping carpet with symmetric ratios
% a = 3/5; b = 5/7;
% linearMats = {[b 0; 0 a], [a 0; 0 b]};
% translations = {[0; 0], [(b+1-a)/2; (a+1-b)/2]};
% shapeInit = [0 1 1 0; 0 0 1 1];

% % An exmple for saturation on the diagonal direction
% lambda = 5/7; n = 5;
% if lambda < 1/sqrt(2) || lambda^n >= 1/3
%     warning("This is not an example of saturation on diagonal.")
% end
% ratio = lambda ^ n;
% lambdaPowers = zeros(1, n);
% for i = 1:n
%     lambdaPowers(i) = lambda ^ (i-1);
% end
% numMaps = 2 ^ n;
% linearMats = cell(1, numMaps);
% translations = cell(1, numMaps);
% curMap = 1;
% curNode = zeros(1, n);
% while curNode(end) <= 1
%     % assign the map
%     linearMats{curMap} = ratio * eye(2);
%     translations{curMap} = [dot(curNode, lambdaPowers);...
%         dot(curNode, lambdaPowers)];
%     if curMap == 1
%         translations{curMap} = [dot(ones(1,n), lambdaPowers); 0];
%     end
%     if curMap == numMaps
%         translations{curMap} = [0; dot(ones(1,n), lambdaPowers)];
%     end
%     curMap = curMap + 1;
%     % update node
%     curNode(1) = curNode(1) + 1;
%     i = 1;
%     while curNode(i) > 1 && i < n
%         curNode(i) = 0;
%         curNode(i+1) = curNode(i+1) + 1;
%         i = i + 1;
%     end
% end
% shapeInit = [0 1/(1 - lambda) 1/(1 - lambda) 0;...
%              0 0 1/(1 - lambda) 1/(1 - lambda)];

% % graph of limit Rademacher function
% lambda = (sqrt(5) - 1)/2; % lambda in (1/2, 1)
% linearMats = {[1/2 0; 0 lambda], [1/2 0; 0 lambda]};
% translations = {[0; -1], [1/2; 1]};
% shapeInit = [0 1 1 0; -1/(1-lambda) -1/(1-lambda) 1/(1-lambda) 1/(1-lambda)];

%% Error handling
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

    ptsTmp = zeros(spaceDim, sizeNow * sizeIFS);

    for indexFct = 1:sizeIFS
        ptsTmp(:, (indexFct - 1) * sizeNow + 1:indexFct * sizeNow) = ...
            linearMats{indexFct} * ptsNow + translations{indexFct};
    end

    ptsNow = ptsTmp;
    sizeNow = size(ptsNow, 2);

    ptsTotal{levelNow + 1} = ptsNow;
end

%% Plot
numShapes = sizeNow / numInitPts;
startF = numItrs + 1;
if showItrs
    startF = 1;
end
for f = startF:numItrs +1
    if showItrs
        figure(f)
    else
        figure(1)
    end

    startPlot = 1;
    if ~showHistory
        startPlot = f;
    end
    if fixBoundary
        for i = 1
            sizeTmp = size(ptsTotal{i}, 2);
            numShapesTmp = sizeTmp / numInitPts;
            facesPlot = kron(ones(numShapesTmp, 1), shapeInitFaces) + ...
                kron((0:(numShapesTmp - 1))' * numInitPts, ones(numInitFaces, 1));
            patch('Faces', facesPlot, ...
                'Vertices', ptsTotal{i}', ...
                'FaceColor', 'w', ...
                'EdgeColor', 'w')
            hold on
        end
    end
    for i = startPlot:f
        sizeTmp = size(ptsTotal{i}, 2);
        numShapesTmp = sizeTmp / numInitPts;
        facesPlot = kron(ones(numShapesTmp, 1), shapeInitFaces) + ...
            kron((0:(numShapesTmp - 1))' * numInitPts, ones(numInitFaces, 1));
        patch('Faces', facesPlot, ...
            'Vertices', ptsTotal{i}', ...
            'FaceColor', colorFaces(i), ...
            'FaceAlpha', alphaFaces(i),...
            'EdgeColor', colorEdges(i), ...
            'EdgeAlpha', alphaEdges(i))
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
        title(['Iteration time = ', num2str(f)], 'Interpreter', 'latex');
    end
    if saveFigures
        if ~rmWhite
            saveas(gcf, filename + "-itr" + num2str(f-1) + fileExt)
        else
            exportgraphics(gcf, filename + "-itr" + num2str(f-1) + fileExt,...
                'BackgroundColor', 'none')
        end
    end
end


%% show param
countPtsTotal = sizeNow;
countShapesTotal = numShapes;
tableResults = table(countPtsTotal, countShapesTotal);
disp(tableResults)
