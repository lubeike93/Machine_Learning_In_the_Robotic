function [d_optimal  ,min_error ,confusion_mat_optimal] = Exercise2(d_max)
%EXERCISE2 Classification of MNIST Images using Bayesian Classification



format long;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
Test_images = loadMNISTImages('t10k-images.idx3-ubyte');
Test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');
tic; % Start stopwatch timer

% Get zero-mean images
vector_mean = mean(images, 2);
image_mean = repmat(vector_mean, 1, size(images,2));
images_zero_mean = images - image_mean;


% Subract mean of training data
test_img_mean = repmat(vector_mean, 1, size(Test_images,2));
Test_img_zero_mean = Test_images-test_img_mean;

clear vector_mean;
clear image_mean;

% Covariance matrix
S = cov(images_zero_mean');


% Eigenvectors U and eigenvalues D of S
[U, D] = eig(S);
eigenvalues = sum(D,1);

% Define "eigen" matrix:
% Corresponding eigenvalues and vectors are written below each other.
eigen = [U;eigenvalues];

    for d = 1 : d_max
        [ eigen_max] = find_the_biggest_eing(eigen, d)
        % Choose transformation matrix W
        W = eigen_max(1:end-1, :);
        
        %clear eigen_max;
        % Transform image in lower dimensional space
        y = W'*images_zero_mean;

        % Class means and covariances
        [Class_means, Class_cov] = Mean_digit_classes(y, labels);       
    
        
        % Apply Test input       
        % Project Test_images on learned basis.
        Test_y = W'*Test_img_zero_mean;

        clear W;
        % Compute likelihood for each test vector and each class
        [p] = Likelihood(Test_y, Class_means, Class_cov);
        
        % Find new labels for test inputs.
        clear Class_means Class_cov;
        [~, New_Test_labels] = max(p,[],1);
        New_Test_labels = New_Test_labels-1;
        check_labels = bsxfun(@eq, New_Test_labels', Test_labels);
        
        % Percentage of wrong labels = classification error.
        Nr_wrong_class.images = size(Test_labels, 1) - sum(check_labels,1);        
        percentage_wrong_labels(d,1) = 1 - sum(check_labels,1)/size(Test_labels,1);
       
        % Confusion matrix
        [confusion_mat(:,:,d), ~] = confusionmat(Test_labels, New_Test_labels);
        clear New_Test_labels;
        
    end
    toc;
    
    % d_optimal and min_error.
    [min_error, d_optimal] = min(percentage_wrong_labels, [], 1);
    
    % Extract corresponding confusion matrix.
    confusion_mat_optimal = confusion_mat(:,:, d_optimal);
    
    % Plot: Classificate error.
    plot(percentage_wrong_labels);

end

