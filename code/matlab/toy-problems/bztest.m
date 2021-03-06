%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2013 by Jerome Maye                                            %
% jerome.maye@gmail.com                                                        %
%                                                                              %
% This program is free software; you can redistribute it and/or modify         %
% it under the terms of the Lesser GNU General Public License as published by  %
% the Free Software Foundation; either version 3 of the License, or            %
% (at your option) any later version.                                          %
%                                                                              %
% This program is distributed in the hope that it will be useful,              %
% but WITHOUT ANY WARRANTY; without even the implied warranty of               %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                %
% Lesser GNU General Public License for more details.                          %
%                                                                              %
% You should have received a copy of the Lesser GNU General Public License     %
% along with this program. If not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script test Blake-Zisserman M-Estimator

% covariance matrix of the error
R(1, 1) = 1e-3;
R(2, 2) = 1e-3;
R(3, 3) = 1e-3;
R(4, 4) = 1e-3;
R(5, 5) = 1e-3;
R(6, 6) = 1e-3;

% number of error terms to generate
numErrors = 1000;

% outliers ratio
outliersRatio = 0.1;

% errors
errors = zeros(numErrors, cols(R));

% squared mahalanobis distance
mahalanobis2 = zeros(numErrors, 1);

% weights for each errors
errorWeights = zeros(numErrors, cols(R));

% generate errors following a normal distribution
for i = 1:numErrors
  if mod(i, 1 / outliersRatio) == 0
    errors(i, :) = mvnrnd(-0.1 + 0.1 .* rand(1, cols(R)), R); % outlier
  else
    errors(i, :) = mvnrnd(zeros(1, cols(R)), R); % inlier
  end
  mahalanobis2(i) = errors(i, :) * inv(R) * errors(i, :)';
  for j = 1:cols(R)
    errorWeights(i, j) = wbz(mahalanobis2(i), cols(R), 0.1, 0.999);
  end
end

[binCount, binPos] = hist(mahalanobis2, 100);
bar(binPos, binCount / trapz(binPos, binCount));
hold on;
x = 0:0.01:30;
plot(x, wbz(x, cols(R), 0.1, 0.999),'g');
