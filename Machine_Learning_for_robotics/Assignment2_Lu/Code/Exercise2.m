
M = 8; %number of discrete observations
N = 12; %number of states
A = dlmread('A.txt'); %transition probability
B = dlmread('B.txt')'; %observation probability
pi = dlmread('pi.txt')'; %intial state distribution
test = dlmread('Test.txt'); %test set

T = 60; %length of observations

% forward procedure
loglikelh = zeros(size(test,2),1);
    alpha = zeros(N,1);
    alpha_new = zeros(N,1);
    for seq=1:size(test,2)

        obs = test(:,seq);
        alpha = pi.*B(:,obs(1));
        % induction
        for t=1:T-1
            for j=1:N
                alpha_new(j) = alpha'*A(:,j)*B(j,obs(t+1));
            end
            alpha = alpha_new;
        end
        % termination
        loglikelh(seq) = log(sum(alpha));
    end
% end

loglikelh = loglikelh'
