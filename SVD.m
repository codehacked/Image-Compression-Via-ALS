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



for i = 1:len
    rank = ranks(i)
    
    % Run the code runs times for this rank
    for j = 1:runs
        tic;  % Start timing
        
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
