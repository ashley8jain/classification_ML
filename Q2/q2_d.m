clear;clc;

%NOTE: run q1_a firstly to load datas
load('datas');

disp('Using LIBSVM:-')

%linear kernel
disp('Linear Kernel:')

model = svmtrain(y, X, '-t 0 -c 500');
[predicted_label, accuracy, decision_values] = svmpredict(test_y,test_X,model);
disp(' ');
disp('no. of support vectors:');
disp(length(model.sv_indices));
disp('support vectors indices:');
disp(mat2str(model.sv_indices'));
disp(' ');
disp('accuracy:');disp(accuracy(1));
disp(' ');


%gaussian kernel
disp('Gaussian Kernel:')
model2 = svmtrain(y, X, '-t 2 -c 500 -g 2.5');
[predicted_label, accuracy, decision_values] = svmpredict(test_y,test_X,model2);
disp(' ');
disp('no. of support vectors:');
disp(length(model2.sv_indices));
disp('support vectors indices:');
disp(mat2str(model2.sv_indices'));
disp('accuracy:');disp(accuracy(1));



