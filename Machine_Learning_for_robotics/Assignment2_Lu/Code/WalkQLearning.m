
function WalkQLearning(s)

    % state transition matrix
    Psa = [2 4 5 13; 1 3 6 14; 4 2 7 15; 3 1 8 16; 6 8 1 9; 5 7 2 10;...
            8 6 3 11; 7 5 4 12; 10 12 13 5; 9 11 14 6; 12 10 15 7;...
            11 9 16 8; 14 16 9 1; 13 15 10 2; 16 14 11 3; 15 13 12 4];

    %pi_ref = [1;2;1;3;4;1;1;2;3;1;1;2;1;4;2;2];
    start = s;

    % intialize Q-function
    Q = zeros(16,4);

    % parameters
    epsilon = 0.1; %for greedy learning
    alpha = 0.1; %learning step length
    gamma = 0.99;

    % initialize policy randomly
    pi = ceil(rand(16,1)*4);
    %pi = zeros(16,1);

    Qrwd = zeros(4,1);
    s = ceil(rand()*16);
    T = 10000;
    t = 0;

    while(t<T)
        t = t+1;

        % choose a from s: take a random action sometimes
        if (rand()<epsilon)
            a = ceil(rand()*4);
        else
            for i=1:4
                Qrwd(i) = Q(s,i);
            end
            [maxRwd,a] = max(Qrwd);
        end

        % take the action and see the result
        [news,r] = SimulateRobot(s,a);
        %fprintf('\nIteration: %d',r)

        % update
        for i=1:4
            Qrwd(i) = Q(news,i);
        end
        [newmaxRwd,newa] = max(Qrwd);
        Q(s,a) = Q(s,a)+alpha*(r+gamma*Q(news,newa)-Q(s,a));
        s = news;

    end

    % determine the value of pi
    temp = zeros(4,1);
    for i=1:16
        for j=1:4
            temp(j) = Q(i,j);
        end
        [maxQ,pi(i)] = max(temp);
    end

    % generating state sequence of length N
    N = 16;
    state = zeros(N,1);
    state(1) = start;
    seq = start;
    for i=1:N-1
        state(i+1) = Psa(state(i),pi(state(i)));
        seq = [seq, state(i+1)];
    end
    walkshow(seq); 

end