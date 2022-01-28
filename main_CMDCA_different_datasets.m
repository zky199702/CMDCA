clear all;clc;close all;warning off;
addpath tools
addpath data
addpath data_random/Coil20

index_choose=1;
[choose_datasets_all] = Choose_dataset_and_random( index_choose );

for num_dataset=1:size(choose_datasets_all,1)
  
    name_algorithm='CMDCA';
    name_dataset=choose_datasets_all{num_dataset,1};
    num_train_all=choose_datasets_all{num_dataset,2};
    
   
    [samples_one,samples_two,samples_three,num_class,address,repeat_samples_all,save_part_train] =Read_dataset_three_views(name_dataset);
    results_record=fopen([name_algorithm,'_',name_dataset,'_improtant_results_record.txt'],'at+');
    
    
    eval([name_algorithm,'_',name_dataset,'_save_all','=cell(length(num_train_all),1);']);
    eval([name_algorithm,'_',name_dataset,'_save_repeat_samples','=cell(length(num_train_all),1);']);
    eval([name_algorithm,'_',name_dataset,'_save_results','=[];']);
    
    for num_train=num_train_all
        t1=clock;
        num_cell=find(num_train_all==num_train);
        
        
        [rand_train,rand_test,label_train,label_test,save_part_train,index_read_correctness]=STBox_Read_samples_random(address,name_dataset,num_train,save_part_train);
        if index_read_correctness==0;  continue; end
        
        acc_best_repeat_all=[];
        for repeat_samples=1:repeat_samples_all
            
            [samples_one_train,samples_one_test]=TBox_readsamples_label(samples_one,rand_train{repeat_samples},rand_test{repeat_samples});
            [samples_two_train,samples_two_test]=TBox_readsamples_label(samples_two,rand_train{repeat_samples},rand_test{repeat_samples});
            [samples_three_train,samples_three_test]=TBox_readsamples_label(samples_three,rand_train{repeat_samples},rand_test{repeat_samples});
            
            [project_vectors_one,project_vectors_two,project_vectors_three]=SOPACA(samples_one_train,samples_two_train,samples_three_train,num_class);
            
            [acc_best,dim_best,acc_all,dim_all]=STBox_acc_dim_three_unequal(project_vectors_one,project_vectors_two,project_vectors_three,samples_one_train,samples_one_test,samples_two_train,samples_two_test,samples_three_train,samples_three_test,label_train,label_test);
            acc_best_repeat_all=[acc_best_repeat_all;acc_best];% Record the temporary imformation
            fprintf(results_record,'%d、  训练样本：%d  样本随机：%d  最佳维数：%d  最佳识别率：%.2f%% \n',find(repeat_samples==(1:repeat_samples_all)),num_train,repeat_samples,dim_best,acc_best);
           
            eval([name_algorithm,'_',name_dataset,'_save_all{num_cell}','=[',name_algorithm,'_',name_dataset,'_save_all{num_cell};   repmat([num_train,repeat_samples],length(dim_all),1),dim_all,acc_all   ','];']);
           
            eval([name_algorithm,'_',name_dataset,'_save_repeat_samples{num_cell}','=[',name_algorithm,'_',name_dataset,'_save_repeat_samples{num_cell};  num_train,repeat_samples,dim_best,acc_best   ','];']);
        end
        t2=clock;
        eval([name_algorithm,'_',name_dataset,'_save_results','=[',name_algorithm,'_',name_dataset,'_save_results;   num_train,std( acc_best_repeat_all),mean(acc_best_repeat_all)   ','];']);
        fprintf('%s算法在 %s 上每类 %d 个训练样本时的平均最佳识别率为: %.2f%%\n',name_algorithm,name_dataset,num_train,mean(acc_best_repeat_all));
        fprintf(results_record,'训练样本：%d   标准差：%0.2f   平均最佳识别率：%.2f%%         运行时间：%.2f\n\n\n',num_train,std( acc_best_repeat_all),mean(acc_best_repeat_all),etime(t2,t1));
    end
    fclose('all');
   
    save([name_algorithm,'_',name_dataset,'_',save_part_train,'_train_save_all'],      [name_algorithm,'_',name_dataset,'_save_all']);
    save([name_algorithm,'_',name_dataset,'_',save_part_train,'_save_repeat_samples'], [name_algorithm,'_',name_dataset,'_save_repeat_samples']);
    save([name_algorithm,'_',name_dataset,'_',save_part_train,'_save_results'], [name_algorithm,'_',name_dataset,'_save_results']);
end
