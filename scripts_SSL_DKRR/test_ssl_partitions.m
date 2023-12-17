function filepath = test_ssl_partitions(data_name)
    [lambda, k_par, M, M_set, m, m_set, T, repeat, ntr, nts, ntr_ssl_set, ntr_ssl] = best_parameters_SSL_DKRR(data_name)

    cobj = [];
    callback = @(alpha, cobj) [];
    memToUse = [];
    useGPU = 0;

    % %% Load dataset ----------
    filepath = ['./data/', data_name, '.mat'];

    if ~exist('X' , 'var')
        load(filepath);
    end

    [n,d] = size(X);
    X = mapstd(X);
    if startsWith(data_name, 'simulated')
        kernel = createKernel('spline', k_par);
        rf = createFeatures(d, M, k_par, 'spline', 'spline');
    else
        kernel = createKernel('gaussian', k_par);
        rf = createFeatures(d, M, k_par, 'gaussian', 'rff');
    end

    nystroem_time = zeros(length(m_set), repeat);
    rf_time = zeros(length(m_set), repeat);
    falkon_time = zeros(length(m_set), repeat);
    labeled_training_time = zeros(length(m_set), repeat);
    ssl_training_time = zeros(length(m_set), repeat);

    nystroem_error = zeros(length(m_set), repeat);
    rf_error = zeros(length(m_set), repeat);
    falkon_error = zeros(length(m_set), repeat);
    labeled_test_error = zeros(length(m_set), repeat);
    ssl_test_error = zeros(length(m_set), repeat);

    for j = 1:repeat
        idx_resh =randperm(n,n);
        % ssl training
        training_num_ssl = ntr_ssl + ntr;
        idx_train = idx_resh(end - training_num_ssl+1 : end);
        X_train_ssl = X(idx_train, : );    
        Y_train_ssl = y(idx_train);
        Y_train_ssl(1:ntr_ssl) = 0;
        % labeled training
        X_train_labeled = X_train_ssl(ntr_ssl+1:end, : ); 
        Y_train_labeled = Y_train_ssl(ntr_ssl+1:end);
        % test
        idx_test = idx_resh( 1 : nts);
        X_test = X(idx_test, : );
        Y_test = y(idx_test);    
        
        % KRR-Nystroem
        trp = randperm(ntr,M);
        Xuni = X_train_labeled(trp,:);
        tic;
        alpha = nystroem(X_train_labeled, Xuni, kernel, Y_train_labeled, lambda);
        nystroem_time(:, j) = toc;
        Ypred = kernel(X_test, Xuni) * alpha;
        nystroem_error(:, j) = error_estimate(Y_test,  Ypred);
        % KRR-RF
        tic;
        Z_train = rf(X_train_labeled);
        Z_test = rf(X_test);
        rf_generating_time = toc;
        tic;
        w = (Z_train'*Z_train + lambda*ntr*eye(M)) \(Z_train'*Y_train_labeled);
        rf_time(:, j) = toc + rf_generating_time;
        Ypred = Z_test * w;
        rf_error(:, j) = error_estimate(Y_test, Ypred);
        % FALKON
        tic;
        alpha = falkon(X_train_labeled , Xuni , kernel,Y_train_labeled,    lambda, T, cobj, callback, memToUse, useGPU);
        falkon_time(:, j) = toc;
        Ypred = kernel(X_test, Xuni) * alpha;
        falkon_error(:, j) = error_estimate(Y_test, Ypred);

        for i=1:length(m_set)    
            m = m_set(i);

            dkrr_traing_times = zeros(m, 1);
            dkrr_Ypreds = zeros(m, nts);
            ssl_dkrr_traing_times = zeros(m, 1);
            ssl_dkrr_Ypreds = zeros(m, nts);
            steps_ssl = floor(training_num_ssl/m);
            steps = floor(ntr/m);
            for k = 1:m
                part_X_ssl = X_train_ssl(steps_ssl * (k - 1) + 1 : steps_ssl * k, :);
                part_y_ssl = Y_train_ssl(steps_ssl * (k - 1) + 1 : steps_ssl * k);

                part_X_labeled = X_train_labeled(steps * (k - 1) + 1 : steps * k, :);
                part_y_labeled = Y_train_labeled(steps * (k - 1) + 1 : steps * k);

                tic;
                alpha = krr(part_X_labeled, kernel, part_y_labeled, lambda);
                dkrr_traing_times(k, :) = toc;
                dkrr_Ypreds(k, :) = kernel(X_test, part_X_labeled) * alpha;

                tic;
                alpha = krr(part_X_ssl, kernel, part_y_ssl, lambda);
                ssl_dkrr_traing_times(k, :) = toc;
                ssl_dkrr_Ypreds(k, :) = kernel(X_test, part_X_ssl) * alpha; 
            end

            labeled_training_time(i, j) = mean(dkrr_traing_times);
            labeled_test_error(i, j) = error_estimate(Y_test, mean(dkrr_Ypreds, 1)');

            ssl_training_time(i, j) = mean(ssl_dkrr_traing_times);
            ssl_test_error(i, j) = error_estimate(Y_test, mean(ssl_dkrr_Ypreds, 1)');
        end    
    end

    filepath = ['./results/ssl_partitions_', data_name, '_', datestr(now,30), '.mat' ]
    save(filepath);
end