clc;clear;
load('train')

% random prediction
testf = fopen('r8-test-all-terms.txt','r');
accuracy=0;
count_row=0;
row = fgetl(testf);
while ischar(row)
    splits = strsplit(row);
    catgIndx=catg_map(char(splits(1)));
    
    p=rand(1,1)*length(keys(catg_map))+1;
    if(floor(p)==catgIndx)
        accuracy=accuracy+1;
    end
    row = fgetl(testf);
    count_row=count_row+1;
end   
fclose(testf);

accuracy = accuracy/count_row;
disp('Accuracy in random prediction:');
disp(accuracy*100);





%majority prediction
accuracy=0;
testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
max_occ=find(no_catgDocs==max(no_catgDocs));
while ischar(row)
    splits = strsplit(row);
    catgIndx=catg_map(char(splits(1)));
    if( max_occ==catgIndx )
        accuracy=accuracy+1;
    end
    row = fgetl(testf);
end   
fclose(testf);

accuracy = accuracy/count_row;
disp('Accuracy in majority prediction:');
disp(accuracy*100);