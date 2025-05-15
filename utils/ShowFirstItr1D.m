%% To show the intervals in a particular iteration
% Used after SelfSimilar1D.m

%% settings
% data
numGen = 4;
ptsPltInit = reshape(ptsTotal{1}, 2, []);
ptsPltGen = reshape(ptsTotal{numGen + 1}, 2, []);
numSegmentsGen = size(ptsPltGen, 2);
% plot
thickness = 15;
downShift = 0.01;
constNormalize = 5000;
colorMain = 'k';
colorAlert = 'b';

% export
saveFigures = true;
filename = "imgs/BC-EO"; % the prefix for saved files
fileExt = ".png"; % file format: .pdf, .png, .jpg, .fig
rmWhite = true;

%% plot
figure(3)
plot(ptsPltInit, zeros(2, 1), colorMain, "LineWidth", thickness)
hold on
for i = 1:numSegmentsGen
    if i == 4 || i == 5
        color = colorAlert;
    else
        color = colorMain;
    end
    plot(ptsPltGen(:, i), zeros(2, 1) - (downShift + (i-1) * thickness/constNormalize),...
        color, "LineWidth", thickness)
end
hold off
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')
ylim([ - (downShift + (numSegmentsGen ) * thickness/constNormalize), thickness/constNormalize])

% export
if saveFigures
    if ~rmWhite
        saveas(gcf, filename + "-itr" + num2str(numGen) + fileExt)
    else
        exportgraphics(gcf, filename + "-itr" + num2str(numGen) + fileExt,...
            'BackgroundColor', 'none')
    end
end
