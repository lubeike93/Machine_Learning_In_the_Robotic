function [ p ] = Likelihood( Test_y, Class_means, Class_cov )

% likelihood function
    for class = 1 : size(Class_means,2)
      p(class,:) = (mvnpdf(Test_y', Class_means(:, class)', Class_cov(:,:,class)))';
    end


end

