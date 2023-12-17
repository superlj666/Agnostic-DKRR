function draw_unlabeled(filepath)
    load(filepath);

    legend_str = {'Semi-supervised DKRR', 'Supervised DKRR', 'Nystr\"om', 'RF', 'FALKON'};
    xlabel_str = '$\#$ the number of unlabeled examples';

    if length(unique(y)) == 2
        ylabel_str = 'Classification error';
    else
        ylabel_str = 'RMSE';
    end    
    Y = {mean(ssl_test_error, 2)', mean(labeled_test_error, 2)',  mean(nystroem_error, 2)',  mean(rf_error, 2)',  mean(falkon_error, 2)'};
    draw_plot_fig(ntr_ssl_set, Y, ['./results/', data_name, '_ssl_error_unlabeled.pdf'], legend_str, xlabel_str, ylabel_str);

    ylabel_str = 'Log of training time (s)';
    Y = {mean(log(ssl_training_time), 2)', mean(log(labeled_training_time), 2)',  mean(log(nystroem_time), 2)',  mean(log(rf_time), 2)',  mean(log(falkon_time), 2)'};
    draw_plot_fig(ntr_ssl_set, Y, ['./results/', data_name, '_ssl_training_unlabeled.pdf'], legend_str, xlabel_str, ylabel_str);
end