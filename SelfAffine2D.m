%% A simple script to plot self-affine sets by iterating polygons
% Zhou Feng @ 2020-10-12
clc, clf, clear
tic

%% settings
% IFS linear parts
linearMats = {[0.25 0; 0 0.25], ...
        [0.25 0; 0 0.25], ...
            [0.25 0; 0 0.25], ...
            [0.25 0; 0 0.25], ...
            [0.5 0; 0 0.5]};

% IFS translations
translations = {[0; 0], ...
            [0.75; 0], ...
                [0.75; 0.75], ...
                [0; 0.75], ...
                [0.25; 0.25]};

% initial polygon for iteration
shapeInit = [0 1 1 0;
        0 0 1 1];

numItrs = 5; % iteration time

% plot settings
showTitle = true;
showFirstItrs = true;
numFirstItrs = 2;
alphaFaces = 1;
colorFaces = 'k';
colorEdges = 'none';

%% Examples
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

% % Bedford-McMullen carpet
% BMh = 3; % horizontal size
% BMv = 4; % vertical size
% BMselect = [1 0 0 1;
%         0 0 0 0;
%         0 0 0 0;
%         1 0 0 1]; % select positions
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
facesPlot = kron(ones(numShapes, 1), shapeInitFaces) + ...
    kron((0:(numShapes - 1))' * numInitPts, ones(numInitFaces, 1));
figure(1)
patch('Faces', facesPlot, ...
    'Vertices', ptsNow', ...
    'FaceColor', colorFaces, ...
    'EdgeColor', colorEdges, ...
    'FaceAlpha', alphaFaces)
set(gca, 'XColor', 'none', 'YColor', 'none')

if showTitle
    title(['Iteration time = ', num2str(numItrs)], 'Interpreter', 'latex');
end

if showFirstItrs && numItrs >= numFirstItrs
    figure(2)

    for i = 1:numFirstItrs
        subplot(1, numFirstItrs, i)
        sizeTmp = size(ptsTotal{i}, 2);
        numShapesTmp = sizeTmp / numInitPts;
        facesPlot = kron(ones(numShapesTmp, 1), shapeInitFaces) + ...
            kron((0:(numShapesTmp - 1))' * numInitPts, ones(numInitFaces, 1));
        patch('Faces', facesPlot, ...
            'Vertices', ptsTotal{i}', ...
            'FaceColor', colorFaces, ...
            'EdgeColor', colorEdges, ...
            'FaceAlpha', alphaFaces)
        set(gca, 'XColor', 'none', 'YColor', 'none')
        % title(['Iteration time = ', num2str(i-1)], 'Interpreter', 'latex');
    end

end

%% Show param
countPtsTotal = sizeNow;
countShapesTotal = numShapes;
tableResults = table(countPtsTotal, countShapesTotal);
disp(tableResults)
