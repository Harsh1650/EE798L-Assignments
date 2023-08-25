%% Start of Code
%% 1st Question: Generation of data
%% Setting up parameters and data parameters given in question
N = 500;
mu1 = [3; 3];
Sigma1 = [1 0; 0 2];
mu2 = [1; -3];
Sigma2 = [2 0; 0 1];
pi1 = 0.8; % Given in question
pi2 = 0.2;
data = zeros(N,2);
for i = 1:N
    if rand < pi1 % Because we are using rand we dont need to convert this into decimal in that case we will be using randi
        data(i,:) = mvnrnd(mu1,Sigma1); % Sampling from data 1
    else
        data(i,:) = mvnrnd(mu2,Sigma2); % Sampling from data 2
    end
end

% Plot the data
scatter(data(:,1),data(:,2),8,'filled','MarkerFaceColor','#66CCCC');
xlabel('x');
ylabel('y');
grid on;
title('Genetrated Dataset');
hold on

% Add legend
legend('Data Points','Location','best','AutoUpdate','off');
hold on

% Add the contour plot
[x, y] = meshgrid(-6:0.1:6);

% Compute the multivariate normal PDF for each point on the meshgrid
pdf_1 = mvnpdf([x(:) y(:)], mu1', Sigma1);
pdf_2 = mvnpdf([x(:) y(:)], mu2', Sigma2);
z1 = pi1*pdf_1+pi2*pdf_2;

% Plot the graph
contour(x, y, reshape(z1,size(x)), [0.01 0.05 0.1 0.2 0.3],'LineWidth',1.5)
hold off
%% End of Code