trainf = fopen('r8-train-all-terms.txt','r');
row = fgetl(trainf);

catg_map = containers.Map;
dict_map = containers.Map;
catg_index=0;
word_index=0;
while ischar(row)
    splits = strsplit(row);
    if(~isKey(catg_map,char(splits(1))))
        catg_index=catg_index+1;
        catg_map(char(splits(1)))=catg_index;
    end
    for i = 2:length(splits)
       if(~isKey(dict_map,char(splits(i))))
           word_index=word_index+1;
           dict_map(char(splits(i)))=word_index;
       end    
    end
    row = fgetl(trainf);
end
fclose(trainf);

trainf = fopen('r8-train-all-terms.txt','r');
row = fgetl(trainf);

prob_catg=zeros(length(keys(catg_map)));
prob_word_catg=zeros(length(keys(catg_map)),length(keys(dict_map)));
no_catgDocs = zeros(length(keys(catg_map)));

while ischar(row)
    splits = strsplit(row);
    no_catgDocs(catg_map(char(splits(1))))=no_catgDocs(catg_map(char(splits(1))))+1;
    
    row = fgetl(trainf);
end


fclose(trainf);
