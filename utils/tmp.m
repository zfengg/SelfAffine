clc,clear

%% dimensions of projections of the measure of full dimension
% a = 2/3; b = 3/5;
a = 3/5; b = 5/7;
% a = 3/11; b = 11/13;

% the affinity dimension
f = @(x) a * b^(x-1) + b * a^(x-1) - 1;
dimAFF = fzero(f, 1.4);
g = @(x) a^x + b^x - 1;
dimAFFaxis = fzero(g, 1.1);

% other quantities
p = [a * b^(dimAFF-1), b * a^(dimAFF-1)];
q = flip(p);

Hp = F(p(1)) + F(p(2));
chi1 = p(1) * - log(a) + p(2) * - log(b);
chi2 = p(2) * - log(a) + p(1) * - log(b);

function y = F(x)
    y = - x * log(x) / log(2);
end

Hp_LY = [Hp, chi1, chi2]

dimsLY = [dimAFF, Hp / chi1, Hp / chi2]

dimAFFaxis
