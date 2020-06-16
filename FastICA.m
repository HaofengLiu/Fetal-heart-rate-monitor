function Y = FastICA(X)
%%
%-----------Centering---------%
[Row,Col] = size(X);    % Get the number of rows / columns of the input matrix,
                        % the number of rows is the number of observation data, 
                        % the number of columns is the number of sampling points   
average = mean(X')';    % Get the mean value
for i = 1:Row
    X(i,:) = X(i,:) - average(i) * ones(1,Col);
end

%%
%----------Whitening----------%
Cx = cov(X',1);                      % Calculate the covariance matrix Cx
[eigvector,eigvalue] = eig(Cx);      % Calculate the eigenvalue and eigenvector of Cx
W = eigvalue ^ (-1/2)*eigvector';    % Whitening the matrix
Y = W * X;                           % Orthogonal the matrix

%%
%----------Iteration-------%
Maxcount = 100000;        % Set the maximum number of iterations
Critical = 0.00000001;     % Determine whether converge is success
m = Row;                  % The number of components need to be estimated
W = rand(m);              % Select an initial value randomly

for n = 1:m 
    WP = W(:,n);          % Initial weight vector
    count = 0;
    LastWP = zeros(m,1);
    W(:,n) = W(:,n) / norm(W(:,n));
   
    while norm(abs(WP - LastWP)) > Critical && norm(abs(WP + LastWP)) > Critical
        count = count + 1;     % Number of iteration
        LastWP = WP;           % The value of the last iteration
        
        %WP=1/Col*Y*((LastWP'*Y).^3)'-3*LastWP;
        
        for i=1:m    
            WP(i) = mean(Y(i,:) .* (tanh((LastWP)' * Y))) - (mean(1-(tanh((LastWP))' * Y) .^ 2)) .* LastWP(i);
        end
        
        WPP = zeros(m,1);     % Create an all-zero matrix
        
        for j = 1:n-1
            WPP = WPP + (WP' * W(:,j)) * W(:,j);
        end
        
        WP = WP - WPP;
        WP = WP / (norm(WP));
        
        if count == Maxcount
            fprintf('No corresponding signal found');
            return;
        end
    end
    W(:,n) = WP;
end

%%
%----------Improvement-------%
Y = W' * Y;
num = Row;

for i = 1:num
    [c,l] = wavedec(Y(i,:),4,'db7');
    anum = wrcoef('a',c,l,'db7',4);
    Y(i,:) = anum;
end

% The weight vetor I choosed randomly, the different direction of the vector
% will cause different output (actually they are same).
% So just for beautiful, I would like make the heart beat pulse be positive.
% Therefore, the output need to be inversed, just add a minus sign.
% When we extract signal from cited signal, we divide 10, so we need to multiply 10 now.
% (in 'main.m', when I get signal_1 - 4)

Y = - 10 * Y;