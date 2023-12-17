function scores = leverage_score(X, filepath, kernel, lambda)
    if exist(filepath , 'file')
        load(filepath);
    else
        K = kernel(X, X);
        n = size(K, 1);
        scores = diag(K / (K + lambda * n * eye(n)));
        scores = scores / sum(scores);
        save(filepath, 'scores', '-v7.3');
    end 
end