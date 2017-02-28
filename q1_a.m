% clc;clear;
% 
% catg_map = containers.Map;
% dict_map = containers.Map;
% catg_index=0;
% word_index=0;
% % no_word_catg = ones(19983,8);
% no_word_catg = ones(23586,8);
% 
% trainf = fopen('r8-train-all-terms.txt','r');
% row = fgetl(trainf);
% while ischar(row)
%     splits = strsplit(row);
%     if(~isKey(catg_map,char(splits(1))))
%         catg_index=catg_index+1;
%         catg_map(char(splits(1)))=catg_index;
%         no_catgDocs(catg_index)=1;
%     else        
%         no_catgDocs(catg_map(char(splits(1))))=no_catgDocs(catg_map(char(splits(1))))+1;
%     end
%     for i = 2:length(splits)
%        if(~isKey(dict_map,char(splits(i))))
%            word_index=word_index+1;
%            dict_map(char(splits(i)))=word_index;
%        end
%        no_word_catg(dict_map(char(splits(i))),catg_map(char(splits(1))))=no_word_catg(dict_map(char(splits(i))),catg_map(char(splits(1))))+1;
%     end
%     row = fgetl(trainf);
% end
% 
% fclose(trainf);
% 
% 
% testff = fopen('r8-test-all-terms.txt','r');
% row = fgetl(testff);
% while ischar(row)
%     splits = strsplit(row);
%     if(~isKey(catg_map,char(splits(1))))
%         catg_index=catg_index+1;
%         catg_map(char(splits(1)))=catg_index;
%         no_catgDocs(catg_index)=1;
%     else        
%         no_catgDocs(catg_map(char(splits(1))))=no_catgDocs(catg_map(char(splits(1))))+1;
%     end
%     for i = 2:length(splits)
%        if(~isKey(dict_map,char(splits(i))))
%            word_index=word_index+1;
%            dict_map(char(splits(i)))=word_index;
%        end
%        no_word_catg(dict_map(char(splits(i))),catg_map(char(splits(1))))=no_word_catg(dict_map(char(splits(i))),catg_map(char(splits(1))))+1;
%     end
%     row = fgetl(testff);
% end
% 
% count_totWords_catg = sum(no_word_catg)+length(keys(dict_map));
% fclose(testff);













load('train')

prob_allcatg=zeros(1,length(keys(catg_map)));
acc=0;
count_row=0;

trainff = fopen('r8-train-all-terms.txt','r');
row = fgetl(trainff);

while ischar(row)
    splits = strsplit(row);
    prob_allcatg=prob_allcatg+log(no_catgDocs/sum(no_catgDocs));
    for i=2:length(splits)
        if(~isKey(dict_map,char(splits(i))))
            no_wordCatg = ones(1,length(keys(catg_map)));
        else
            no_wordCatg = no_word_catg(dict_map(char(splits(i))),:);
        end    
         prob_allcatg=prob_allcatg+log( no_wordCatg./count_totWords_catg );
    end
    if(find(prob_allcatg==max(prob_allcatg))==catg_map(char(splits(1))))
        acc=acc+1;
    end
    count_row=count_row+1;
    row = fgetl(trainff);
end
disp('accuracy over train set:');
disp(acc/count_row);

fclose(trainff);
















prob_allcatg=zeros(1,length(keys(catg_map)));
acc=0;
count_row=0;

testf = fopen('r8-test-all-terms.txt','r');
row = fgetl(testf);
while ischar(row)
    splits = strsplit(row);
    prob_allcatg=prob_allcatg+log(no_catgDocs/sum(no_catgDocs));
    for i=2:length(splits)
        if(~isKey(dict_map,char(splits(i))))
            no_wordCatg = ones(1,length(keys(catg_map)));
        else
            no_wordCatg = no_word_catg(dict_map(char(splits(i))),:);
        end    
         prob_allcatg=prob_allcatg+log( no_wordCatg./count_totWords_catg );
    end
    if(find(prob_allcatg==max(prob_allcatg))==catg_map(char(splits(1))))
        acc=acc+1;
    end
    count_row=count_row+1;
    row = fgetl(testf);
end
disp('accuracy over test set:');
disp(acc/count_row);

fclose(testf);

