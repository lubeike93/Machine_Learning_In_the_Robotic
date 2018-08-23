
% determine the multivariat normal distribution function
f = @(a,b,c) (1/(sqrt((2*3.1415926)^2*det(c))))*exp(-0.5*(a-b)*c^(-1)*(a-b)');

load('dataGMM.mat');
[p,n] = size(Data);
Data = Data';
K = 4;

%% Intialize GMM parameters with kmeans
[idx mu] = kmeans(Data,K);
%load('std.mat');

sigma = zeros(2,2,K);
pi = zeros(K,1);
for i=1:K
    idxi = find(~(idx-i));
    sigma(:,:,i) = cov(Data(idxi,:));
    pi(i) = length(idxi)/n;
end

% Compute the PDF of a multivariate Gaussian
mu_overall = [mean(Data(:,1)),mean(Data(:,2))];
sigma_overall = cov(Data);

% EM estimation
converged = 0;
it = 0;
pW = zeros(K,n);
tmp = zeros(K,n);
sigtp = zeros(2,2,n);
while(~converged)      
    it = it+1;
    % E-step: evaluate the responseibilities using current paras
    for k=1:K
        for j=1:n
            tmp(k,j) = pi(k) * f(Data(j,:),mu(k,:),squeeze(sigma(:,:,k)));
        end 
    end
    sumtmp = sum(tmp,1);
    st_rep = repmat(sumtmp,4,1);
    pW = tmp./st_rep;
    
    % M-step: re-estimate the parasusing the current responsibilities
    for k=1:K
        nk = sum(pW(k,:));
        % mu
        mu(k,:) = (1/nk)*[sum(pW(k,:)'.*Data(:,1)),sum(pW(k,:)'.*Data(:,2))];
        % sigma
        for i=1:n
            sigtp(:,:,i) = pW(k,i)*(Data(i,:)-mu(k,:))'*...
                            (Data(i,:)-mu(k,:));
        end
        sigma(1,1,k) = (1/nk)*sum(sigtp(1,1,:));
        sigma(1,2,k) = (1/nk)*sum(sigtp(1,2,:));
        sigma(2,1,k) = (1/nk)*sum(sigtp(2,1,:));
        sigma(2,2,k) = (1/nk)*sum(sigtp(2,2,:));
        % pi
        pi(k) = nk/n;
    end    

    likelh_old = sum(log(sumtmp));
    for k=1:K
        for j=1:n
            tmp(k,j) = pi(k) * f(Data(j,:),mu(k,:),squeeze(sigma(:,:,k)));
        end 
    end
    sumtmp = sum(tmp,1);
    likelh = sum(log(sumtmp));
    if (abs(likelh-likelh_old)<1e-6)
        converged = 1;
    end

end
