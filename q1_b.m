clc;clear;
load('train_on_train')

acc=0;
count_row=0;
testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
while ischar(row)
    splits = strsplit(row);
    p=rand(1,1)*length(keys(catg_map));
    if( p<catg_map(char(splits(1))) && p>=(catg_map(char(splits(1)))-1) )
        acc=acc+1;
    end
    row = fgetl(testf);
    count_row=count_row+1;
end   
fclose(testf);

disp('Accuracy in random prediction:');
disp(acc/count_row);




acc=0;
testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
max_occ=find(no_catgDocs==max(no_catgDocs));
while ischar(row)
    splits = strsplit(row);
    if( max_occ==catg_map(char(splits(1))) )
        acc=acc+1;
    end
    row = fgetl(testf);
end   
fclose(testf);

disp('Accuracy in majority prediction:');
disp(acc/count_row);






