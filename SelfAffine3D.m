%% A simple script to plot self-affine sets by iterating polyhedrons
% Zhou Feng @ 2022-6-25
clc, clf, clear
tic

%% settings
% IFS linear parts
linearMats = {diag([1/6, 1/4, 1/3]), ...
        diag([1/2, 1/2, 1/3]), ...
            diag([1/3, 1/4, 2/3]), ...
            diag([1/2, 1/4, 1/3])};

% IFS translations
translations = {[0 0 0]', ...
            [1/6 1/4 0]', ...
                [2/3, 3/4, 1/3]', ...
                [1/6, 0, 0]'};

% initial polyhedron for iteration
shapeInit = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1]';
shapeInitFaces = [4 8 5 1; 1 5 6 2; 2 6 7 3; 3 7 8 4; 5 8 7 6; 1 4 3 2];

% iteration time
numItrs = 4;

% plot settings
showTitle = true;
showFirstItrs = true;
numFirstItrs = 2;
alphaFaces = 1;
colorFaces = 'k';
colorEdges = 'w'; % 'none'

%% Examples
% ---------------------------------- sponges --------------------------------- %
% % Sierpinski-Menger snowflake
% ratio = 1/3;
% linearMats = cell(8, 1);
% for i = 1:8
%     linearMats{i} = ratio * eye(3);
% end
% translations = {[0 0 0]', [0 2/3 0]', [2/3, 2/3, 0]', [2/3, 0, 0]', ...
%             [0 0 2/3]', [0 2/3 2/3]', [2/3, 2/3, 2/3]', [2/3, 0, 2/3]'};
% shapeInit = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1]';
% shapeInitFaces = [4 8 5 1; 1 5 6 2; 2 6 7 3; 3 7 8 4; 5 8 7 6; 1 4 3 2];

% % Sierpinski-Menger sponge
% ratio = 1/3;
% linearMats = cell(20, 1);
% for i = 1:20
%     linearMats{i} = ratio * eye(3);
% end
% translations = kron(ones(4, 1), [0 0 0;...
%                                 1/3 0 0;...
%                                 2/3 0 0]);
% translations(4:6, 2) = translations(4:6, 2) + 2/3;
% translations(7:9, 3) = translations(7:9, 2) + 2/3;
% translations(10:12, 2:3) = translations(10:12, 2:3) + 2/3;
% translations = [translations; kron(ones(4, 1), [0, 0, 1/3; 2/3, 0, 1/3])];
% translations(15:16, 2) = translations(15:16, 2) + 2/3;
% translations(17:18, 2:3) = translations(17:18, 2:3) + [1/3 -1/3; 1/3 -1/3];
% translations(19:20, 2:3) = translations(19:20, 2:3) + [1/3 1/3; 1/3 1/3];
% translations = mat2cell(translations', [3], ones(20, 1));
% shapeInit = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1]';
% shapeInitFaces = [4 8 5 1; 1 5 6 2; 2 6 7 3; 3 7 8 4; 5 8 7 6; 1 4 3 2];

% % Baranski menger
% linearMats = {diag([1/6, 1/4, 1/3]),...
%               diag([1/2, 1/2, 1/3]),...
%               diag([1/3, 1/4, 2/3]),...
%               diag([1/2, 1/4, 1/3])};
% translations = {[0 0 0]',...
%                 [1/6 1/4 0]',...
%                 [2/3, 3/4, 1/3]',...
%                 [1/6, 0, 0]'};
% shapeInit = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1]';
% shapeInitFaces = [4 8 5 1; 1 5 6 2; 2 6 7 3; 3 7 8 4; 5 8 7 6; 1 4 3 2];

% --------------------------------- pyramids --------------------------------- %
% % Sierpinski pyramid
% linearMats = cell(4, 1);
% for i = 1:4
%     linearMats{i} = 1/2 * eye(3);
% end
% translations = {[0 0 0]',...
%     [1/2 0 0]',...
%     [1/4, sqrt(3)/4, 0]',...
%     [1/4, sqrt(3)/12, sqrt(6)/6]'};
% shapeInit = [0 0 0; 1 0 0; 1/2 sqrt(3)/2 0; 1/2 1/sqrt(12) sqrt(6)/3]';
% shapeInitFaces = [1 2 3; 1 2 4; 1 3 4; 2 3 4];

%% Error handling
isCompactible = false;

if length(linearMats) == length(translations)
    isCompactible = true;
end

if ~isCompactible
    error('Illegal settings. Dimensions of the parameters does not match!')
end

spaceDim = 3;
sizeIFS = length(linearMats);
numInitPts = size(shapeInit, 2);
numInitFaces = size(shapeInitFaces, 1);

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
view(3)
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')

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
        view(3)
        set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')
        % title(['Iteration time = ', num2str(i-1)], 'Interpreter', 'latex');
    end

end

%% Show param
countPtsTotal = sizeNow;
countShapesTotal = numShapes;
tableResults = table(countPtsTotal, countShapesTotal);
disp(tableResults)
