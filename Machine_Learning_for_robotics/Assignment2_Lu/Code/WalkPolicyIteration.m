
function WalkPolicyIteration(s)

    % state transition matrix
    Psa = [2 4 5 13; 1 3 6 14; 4 2 7 15; 3 1 8 16; 6 8 1 9; 5 7 2 10;...
            8 6 3 11; 7 5 4 12; 10 12 13 5; 9 11 14 6; 12 10 15 7;...
            11 9 16 8; 14 16 9 1; 13 15 10 2; 16 14 11 3; 15 13 12 4];
    % reward function
    Rsa = [0 0 0 0; 0 1 -1 -1; 1 -1 -1 0; -1 0 1 0; -1 -1 0 1; 0 0 0 0;...
            0 0 0 0; -1 1 -1 0; -1 0 1 -1; 0 0 0 0; 0 0 0 0; -1 0 0 0;...
            1 0 -1 0; -1 0 -1 1; 0 0 -1 0; 0 0 0 0];

    % initialize policy randomly
    pi = ceil(rand(16,1)*4);

    %snext = zeros(16,1);
    V = zeros(16,1);% expected total future value
    rwd = zeros(4,1);
    gamma = 0.99;
    count = 0;
    it = 0;
    converged =0;

    while(~converged)
        it = it+1;

        % construct matrices of a linear system
        A = zeros(16,16); 
        b = zeros(16,1);
        for i=1:16
            %eqt(i) = V(i) == Rsa(i,pi(i)) + gamma*V(Psa(i,pi(i)));
            A(i,i) = 1;
            A(i,Psa(i,pi(i))) = -gamma;
            b(i) = Rsa(i,pi(i));
        end
        V = linsolve(A,b);

        pi_old =pi;
        for i=1:16
            for j=1:4
                rwd(j) = Rsa(i,j) + gamma*V(Psa(i,j));
            end
            [maxrwd, pi(i)] = max(rwd);
        end
        fprintf('\nIteration: %d',it)

        % if the policy hasn't change for 3 iterations, stop
        if pi==pi_old
            count = count+1;
        else
            count = 0;
        end
        if count==3
            converged = 1;
        end
    end

    % generating state sequence of length N
    N = 16;
    state = zeros(N,1);
    state(1) = s;
    seq = s;
    for i=1:N-1
        state(i+1) = Psa(state(i),pi(state(i)));
        seq = [seq, state(i+1)];
    end
    walkshow(seq);
    
end