clear;clc;

%NOTE: run q1_a firstly to load datas
load('datas')

m = size(X,1);
C = 500;

%%%%%%%%%%%%%%%%%%%% Gaussian kernel Matrix
gauss_M = zeros(m,m);
for i=1:m
    x = X(i,:);
    for j=1:m
        xX = X(i,:)-X(j,:);
        gauss_M(i,j) = exp(-2.5*(xX*xX'));
    end    
end        



%%%%%%%%%%%%%%%%%%%%% SVM optimization problem using CVX
Q = (y*y').*gauss_M;
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









%%%%%%%%%%%%%%%%%%%%% finding b intercept term

alph_btw_0_C = find(alph>1e-4 & alph<(C-0.1));
X_0_C = X(alph_btw_0_C(1),:);
y_0_C = y(alph_btw_0_C(1));

K_star =zeros(m,1);
for i=1:m
        xx = X_0_C-X(i,:);
        K_star(i) = exp(-2.5*(xx*xx'));
end

W_phi_x = y.* alph.* K_star;
b = y_0_C - sum(W_phi_x);

disp('value of b:');disp(b);









%%%%%%%%%%%%%%%%%% predicted label for test datas
mm = size(test_X,1);

predicted=zeros(mm,1);
K_Xi=zeros(m,1);
for i=1:mm
    for j=1:m
        xx = test_X(i,:)-X(j,:);
        K_Xi(j)=exp(-2.5*(xx*xx'));
    end
    W_phi_X=y.* alph.* K_Xi;
    predicted(i)= b + sum(W_phi_X);
end    

predict_label = predicted.*test_y;

accuracy = size(find(predict_label>0),1)/size(predict_label,1);
disp('accuracy:');disp(accuracy*100);
