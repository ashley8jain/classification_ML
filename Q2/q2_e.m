clear;clc;

%NOTE: run q1_a firstly to load datas
load('datas')

m=size(X,1);

C_s=[1,10,100,1000,10000,100000,1000000];
accuracy_valid=zeros(1,length(C_s));
accuracy_test=zeros(1,length(C_s));

k=10;
offset = m/k;

for g_i=1:length(C_s)
    option = strcat({'-t 2 -c '},{int2str(C_s(g_i))},{' -g 2.5'});
    disp(' ');
    disp('C:');disp(C_s(g_i));
    for j=1:10

        %train
        disp(' ');
        disp('j:');
        disp(j);
        XX=[X(1:offset*(j-1),:) ; X(offset*(j)+1:m,:)];
        yy=[y(1:offset*(j-1),:) ; y(offset*(j)+1:m,:)];
        model  = svmtrain(yy,XX,char(option));
        
        %validation
        test_XX=X(offset*(j-1)+1:offset*j,:);
        test_yy=y(offset*(j-1)+1:offset*j,:);
        [predicted_label, accuracy, decision_values] = svmpredict(test_yy,test_XX,model);
        accuracy_valid(g_i)=accuracy_valid(g_i)+accuracy(1);
        
    end
    accuracy_valid(g_i)=accuracy_valid(g_i)/10;
    disp('Average accuracy (training):');disp(accuracy_valid(g_i));
    disp(' ');disp('test:');
    %test accuracies
    model  = svmtrain(y,X,char(option));
    [predicted_label, accuracy, decision_values] = svmpredict(test_y,test_X,model);
    accuracy_test(g_i)=accuracy(1);
    disp('Accuracy over test set:');disp(accuracy_test(g_i));
end

% plot
figure
plot([0,1,2,3,4,5,6],accuracy_test,'-or',[0,1,2,3,4,5,6],accuracy_valid,'-og');
xlabel('log C');
ylabel('accuracy');
legend('test set','validation set');



