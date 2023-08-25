% Define the mean and covariance matrix
mu = [2; 1];
sigma = [1 0; 0 1];

% Define the range of x and y values
x = -5:0.1:5;
y = -5:0.1:5;

% Create a grid of x and y values
[X,Y] = meshgrid(x,y);

% Compute the pdf values at each point on the grid
Z = mvnpdf([X(:) Y(:)], mu', sigma);

% Reshape the pdf values to the grid shape
Z = reshape(Z, size(X));

% Plot the pdf as a contour plot
figure(1);hold off
contour(X,Y,Z);
xlabel('x');
ylabel('y');
title('Contour plot Multivariate Normal PDF [1 0; 0 1]');

mu1 = [2; 1];
sigma1 = [1 0.8; 0.8 1];

% Define the range of x and y values
x1 = -5:0.1:5;
y1 = -5:0.1:5;

% Create a grid of x and y values
[X1,Y1] = meshgrid(x1,y1);

% Compute the pdf values at each point on the grid
Z1 = mvnpdf([X1(:) Y(:)], mu1', sigma1);

% Reshape the pdf values to the grid shape
Z1 = reshape(Z1, size(X1));

% Plot the pdf as a contour plot
figure(2);hold off
contour(X1,Y1,Z1);
xlabel('x1');
ylabel('y1');
title('Contour plot Multivariate Normal PDF [1 0.8; 0.8 1]');

% Create a grid of points for plotting the PDF
x_1 = linspace(mu(1)-3, mu(1)+3, 100);
x_2 = linspace(mu(2)-3, mu(2)+3, 100);
[X_1,X_2] = meshgrid(x_1,x_2);
X_ = [X_1(:) X_2(:)];

% Evaluate the PDF at each point on the grid
pdf = mvnpdf(X_, mu', sigma);

% Reshape the PDF values back into a grid for plotting
pdf = reshape(pdf, size(X_1));

% Plot the PDF as a 3D surface
figure(3);
surf(X_1,X_2,pdf);
xlabel('x_1');
ylabel('x_2');
zlabel('PDF');
title('PDF expression of (a)');

% Create a grid of points for plotting the PDF
y_1 = linspace(mu1(1)-3, mu1(1)+3, 100);
y_2 = linspace(mu1(2)-3, mu1(2)+3, 100);
[Y_1,Y_2] = meshgrid(y_1,y_2);
Y_ = [Y_1(:) Y_2(:)];

% Evaluate the PDF at each point on the grid
pdf1 = mvnpdf(Y_, mu1', sigma1);

% Reshape the PDF values back into a grid for plotting
pdf1 = reshape(pdf1, size(Y_1));

% Plot the PDF as a 3D surface
figure(4);
surf(Y_1,Y_2,pdf1);
xlabel('y_1');
ylabel('y_2');
zlabel('PDF');
title('PDF expression of (b)');