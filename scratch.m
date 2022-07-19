centers = [0 0];
radii = [1];

colorCircle = 'k';
widthCircle = 0.01;


colorPoint = 'r';
sizeMaker = 0.1;

figure(1)
viscircles(centers, radii,...
        'Color', colorCircle,...
        'LineWidth', widthCircle)
hold on
scatter(0, 0,...
        colorPoint)

axis image