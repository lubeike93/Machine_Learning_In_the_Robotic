function [Class_means, Class_cov] = Mean_digit_classes( y,labels )
%MEAN_DIGIT_CLASSSES This function computes the means and covariance
% matrices of all 10 classes.

% Initialization
Nr_classes = max(labels)+1;
Class_means = zeros(size(y,1), Nr_classes);


for i = 1 : Nr_classes
    
    % Compute filter matrix for extraction of class elements.
    Filter = bsxfun(@eq, labels, i-1);
    Filter2 = repmat(Filter', size(y,1),1); 
    
    % Selection of class elements.
    clear Filter;
    Class_elements = y.*Filter2;
    Class_elements(:, ~any(Class_elements)) = [];
    
    % Computation of class means and covariance matrices.
    Class_means(:,i) = mean(Class_elements,2);
    Class_cov(:,:,i) = cov(Class_elements');
    clear Class_elements;
end

end

