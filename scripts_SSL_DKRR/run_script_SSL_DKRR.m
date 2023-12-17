clear;
addpath('./scripts_SSL_DKRR');
addpath('./methods');
addpath('./kernels');
addpath('./utils');
rng('default');

datasets = {'ijcnn1'};%{'EEG', 'SUSY', 'covtype'};

for c_data = datasets
    data_name = char(c_data);
    
    filepath = test_ssl_unlabeled(data_name);
    draw_ssl_unlabeled(filepath);

    filepath = test_ssl_partitions(data_name);
    draw_ssl_partitions(filepath);
end