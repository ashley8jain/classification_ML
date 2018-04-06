clc;clear;


%%%%%%%%%%%%%%%%%%% training on train datas
catg_index=0;
word_index=0;
no_word_catg=ones(40000,20);
catg_map = containers.Map;word_map = containers.Map;
save('common');

trainf = fopen('r8-train-all-terms.txt','r');


row = fgetl(trainf);
while ischar(row)
    splits = strsplit(row);
    if(~isKey(catg_map,char(splits(1))))
        catg_index=catg_index+1;
        catg_map(char(splits(1)))=catg_index;
        catgIndx=catg_index;
        no_catgDocs(catgIndx)=1;
    else
        catgIndx=catg_map(char(splits(1)));
        no_catgDocs(catgIndx)=no_catgDocs(catgIndx)+1;
    end
    for i = 2:length(splits)
       if(~isKey(word_map,char(splits(i))))
           word_index=word_index+1;
           word_map(char(splits(i)))=word_index;
       end
       wordIndx=word_map(char(splits(i)));
       no_word_catg(wordIndx,catgIndx)=no_word_catg(wordIndx,catgIndx)+1;
    end
    row = fgetl(trainf);
end

fclose(trainf);

%for calculating size of vocabulary in test datas
testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
while ischar(row)
    splits = strsplit(row);
    for i = 2:length(splits)
       if(~isKey(word_map,char(splits(i))))
           word_index=word_index+1;
           word_map(char(splits(i)))=word_index;
       end
    end
    row = fgetl(testf);
end
fclose(testf);

%remove remaining parts of empty words
no_word_catg=no_word_catg(1:word_index,1:catg_index);

count_totWords_catg = sum(no_word_catg)+length(keys(word_map));
save('train')













%%%%%%%%%%%%%%%%%%% accuracy over training datas
load('train')

accuracy=0;
count_row=0;

trainf = fopen('r8-train-all-terms.txt','r');
row = fgetl(trainf);

while ischar(row)
    splits = strsplit(row);
    catgIndx=catg_map(char(splits(1)));
    prob_allcatg=zeros(1,length(keys(catg_map)));
    prob_allcatg=prob_allcatg+log(no_catgDocs/sum(no_catgDocs));
    for i=2:length(splits)
        if(~isKey(word_map,char(splits(i))))
            no_wordCatg = ones(1,length(keys(catg_map)));
        else
            no_wordCatg = no_word_catg(word_map(char(splits(i))),:);
        end    
         prob_allcatg=prob_allcatg+log( no_wordCatg./count_totWords_catg );
    end
    if(find(prob_allcatg==max(prob_allcatg))==catgIndx)
        accuracy=accuracy+1;
    end
    count_row=count_row+1;
    row = fgetl(trainf);
end
accuracy = accuracy/count_row;
disp('accuracy over train set:');
disp(accuracy*100);

fclose(trainf);

















%%%%%%%%%%%%%%%%%%% accuracy over test datas
count_row=0;

confusionM=zeros(length(keys(catg_map)),length(keys(catg_map)));


testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
while ischar(row)
    splits = strsplit(row);
    catgIndx=catg_map(char(splits(1)));
    prob_allcatg=zeros(1,length(keys(catg_map)));
    prob_allcatg=prob_allcatg+log(no_catgDocs/sum(no_catgDocs));
    for i=2:length(splits)
        if(~isKey(word_map,char(splits(i))))
            no_wordCatg = ones(1,length(keys(catg_map)));
        else
            no_wordCatg = no_word_catg(word_map(char(splits(i))),:);
        end    
         prob_allcatg=prob_allcatg+log( no_wordCatg./count_totWords_catg );
    end
    confusionM(catgIndx,prob_allcatg==max(prob_allcatg))=confusionM(catgIndx,prob_allcatg==max(prob_allcatg))+1;
    count_row=count_row+1;
    row = fgetl(testf);
end

disp('Confusion matrix:');
disp(confusionM);
disp(' ');

accuracy = sum(diag(confusionM))/count_row;
disp('accuracy over test set:');
disp(accuracy*100);

fclose(testf);

