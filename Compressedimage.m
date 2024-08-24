clear all;

% Define parameters
runs = 1;  % Number of times to run the code for each rank (set to 1 for error map generation)
ranks = 75:5:100;  % Ranks to test
len = length(ranks);
tol = 1e-9;  % Tolerance for convergence

% Read and normalize image
img = rgb2gray(imread('U:\SEMESTER-6\NM\PROJECT\compress\einstein.jpg'));
A = double(img') / 255; 
clear img;

% Initialize containers for times, iterations, and L
times = zeros(runs, len);
iterations = zeros(runs, len);
L = zeros(1, len);

for i = 1:len
    rank = ranks(i)
    
    % Run the code runs times for this rank
    for j = 1:runs
        tic;  % Start timing
        
        % Call ALS function with the current rank
        [W, Z, iter] = ALS(A, rank, tol);

        % Record elapsed time and iterations
        times(j,i) = toc;
        iterations(j,i) = iter;

%         Generate error maps
        hatA = W * Z';
        imwrite(hatA', strcat('com', int2str(rank), '.png'))
        emap = abs(A - hatA);
        imwrite(emap', strcat('als', int2str(rank), '.png'));
        
        % Calculate the Frobenius norm
        L(i) = norm(A - hatA, 'fro');
          
        [U, S, V] = svd(A);
%         Generate error maps
        hatSA =U(:, 1: rank) * S(1: rank, 1: rank) * V(:, 1: rank)';
        imwrite(hatSA', strcat('comp', int2str(rank), '.png'))
        emap = abs(A - hatSA);
        imwrite(emap', strcat('svd', int2str(rank), '.png'));
        
        % Calculate the Frobenius norm
        LS(i) = norm(A - hatSA, 'fro');

    end
end
% % Plot L(i) against rank
figure;
plot(ranks, L, '-o');

hold on;
plot(ranks,LS,'-*')
xlabel('Rank');
ylabel('Loss');
legend('QR', 'SVD');
% title('Frobenius Norm of Error vs. Rank');
grid on;
saveas(gcf, 'g2.png');

% ************************************
% uncomment for direct implementation
% % ************************************
% ct_direct = times;
% ni_direct = iterations;
% save('direct.mat','ct_direct', 'ni_direct');
%   

% load('direct.mat');
% 
% 
% 
% % Create box plots for computation time
% for i = 1:len
%     f = figure('visible', 'off');
%     boxplot([times(:,i) ct_direct(:,i)], 'Labels', {'QR', 'Direct'});
%     ax = gca; ax.FontSize = 15; ax.PlotBoxAspectRatio = [1 1 1];
%     title(append('Rank = ', int2str(ranks(i))), 'FontSize',18);
%     exportgraphics(f, strcat('ct',int2str(ranks(i)),'.png'));
% end
% 
% 
% % Create box plot for number of iterations
% for i = 1:length(ranks)
%     f = figure('visible', 'off');
%     boxplot([iterations(:,i) ni_direct(:,i)], 'Labels', {'QR', 'Direct'});
%     ax = gca; ax.FontSize = 15; ax.PlotBoxAspectRatio = [1 1 1];
%     title(append('Rank = ', int2str(ranks(i))), 'FontSize',18);
%     exportgraphics(f, strcat('ni',int2str(ranks(i)),'.png'));
% end
