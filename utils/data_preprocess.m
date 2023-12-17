%%% data process for libsvm dataset with a fixed number.
%%% Classification data is labeled as +1 / -1
%%% Regression data is labeled to the scale [0, 1].
%%% shape: n * d
%%% X is processed by mapstd
function data_preprocess(data_name, selected_number)
    addpath('./utils/libsvm/matlab/');
    dataset_path = ['./datasets/', data_name];
    if endsWith(dataset_path, '.mat')
        [y, X] = load(dataset_path);
    else
        [y, X] = libsvmread(dataset_path); 
    end
    if isinf(selected_number)
        rand_idx = 1:length(y);
    else
        rand_idx = randperm(length(y), selected_number);
    end
    y = y(rand_idx);
    y = label_scale(y);
    X = mapstd(X(rand_idx, :));
    save(['./data/', data_name], 'X', 'y');
end

function y = label_scale(y)
    if length(unique(y)) == 2 % strcmp(type, 'binary')
        y(y==min(y)) = -1;
        y(y==max(y)) = 1;       
    end
end