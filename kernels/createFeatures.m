function f = createFeatures(d, D, k_par, typeKernel, typeRF)
    % creates random features
    % Inputs:
    % X the datapoints to use to generate those features (n x d)
    % D the number of features to make
    
    b = 2*pi*rand(1, D);
    
    switch typeKernel
        case 'gaussian'
            W = normrnd(0, 1/k_par, [d, D]);
        case 'cauchy'
            % TODO
            W = normrnd(0, 1/k_par, [d, D]);
        case 'laplacian'
            % TODO
            W = normrnd(0, 1/k_par, [d, D]);
        case 'spline'
            W = rand(1, D);
        otherwise
            W = normrnd(0, 1/k_par, [d, D]);
    end
    
	switch typeRF
        case 'rff'        
            f = @(X) rff(X, D, W, b);
        case 'rff_2d'     
            f = @(X) rff_2d(X, D, W);    
        case 'le_rff'     
            f = @(X) le_rff(X, D, W, b);
        case 'spline'            
            f = @(X) spline_rf(X, D, W, k_par);
    end
end


function Z = rff(X, D, W, b)
    % dimension - D
	Z = sqrt(2/D)*cos(bsxfun(@plus, X*W, b));
end

function Z = rff_2d(X, D, W)
    % dimension - D
	Z = sqrt(1/D)*[cos(X*W), sin(X*W)];
end


function Z = le_rff(X, D, W, b)
	Z = [cos(bsxfun(@plus, X*W(:,1:D), b)),sin(bsxfun(@plus, X*W(:,D+1:end), b))];
end

function Z = spline_rf(X, D, W, k_par)
	Z = sqrt(1/D)*spline_function(X, W', k_par/2);
end