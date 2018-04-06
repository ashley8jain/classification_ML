clear;clc;

%reading datas from txt file
X = load('traindata.txt');y = load('trainlabels.txt');
y(y==2)=-1;

test_X = load('testdata.txt');test_y = load('testlabels.txt');
test_y(test_y==2)=-1;
save('datas');

m = size(X,1);
C = 500;



%%%%%%%%%%%%%%%%%%%% SVM optimization problem using CVX

%Q matrix
Q = (y*y').*(X*X');

cvx_begin
    variable alph(m,1)
    maximize(sum(alph)-0.5*(alph'*Q*alph))
    subject to
        alph'*y == 0
        0 <= alph
        alph <= C
cvx_end


%support vector
supp_vec_indices = find(alph>1e-4);
disp('no. of support vectors:');
disp(length(supp_vec_indices));
disp('support vector indices:');
disp(mat2str(supp_vec_indices'));





%%%%%%%%%%%%%%%%%%%%% weight vector and intercept term
W = X'*(alph.*y);
disp('W:');disp(mat2str(W'));

WX = X*W;
b = -0.5*(max(WX(y==-1)+min(WX(y==1))));
disp('value of b:');disp(b);




%%%%%%%%%%%%%%%%%%%%%% test set accuracy
predicted = test_X*W+b;
predict_label = predicted.*test_y;

accuracy = size(find(predict_label>0),1)/size(predict_label,1);
disp('accuracy:');disp(accuracy*100);
