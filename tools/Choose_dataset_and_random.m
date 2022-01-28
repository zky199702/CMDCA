function [choose_datasets_all] = Choose_dataset_and_random( index_choose )

all_datasets=cell(1,2);


all_datasets{1,1}='Coil20';
all_datasets{1,2}=(2:12);





choose_datasets_all=cell(length(index_choose),2);
for index_dataset=1:length(index_choose)
    choose_datasets_all{index_dataset,1}=all_datasets{index_choose(index_dataset),1};
    choose_datasets_all{index_dataset,2}=all_datasets{index_choose(index_dataset),2};
end

end

