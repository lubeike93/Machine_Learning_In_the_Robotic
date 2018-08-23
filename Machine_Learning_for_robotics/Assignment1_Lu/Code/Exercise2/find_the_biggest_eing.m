function [ max_eigen] = find_the_biggest_eing(eigen, d)

% Initialization
max_eigen = zeros(size(eigen,1),d);

for i = 1 : d
    % Find the index of highest eigenvalues in eigen.
    [~, index] = max(eigen(size(eigen,1),:), [], 2);
    % Extract corresponding eigenvector.
    max_vector = eigen(:,index);
    % Write found eigenvector in output argument.
    max_eigen(:,i) = max_vector;
    % Delete found eigenvector in eigen matrix.
    eigen(:,index) = [];
end
end

