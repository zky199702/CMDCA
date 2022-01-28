function [rand_train,rand_test,label_train,label_test,save_part_train,index_read_correctness] = STBox_Read_samples_random(address,name_dataset,num_train,save_part_train)


try
    if num_train<10
        save_part_train=[save_part_train,num2str(num_train)];
    else
        save_part_train=[save_part_train,'_',num2str(num_train)];
    end
    
    index_read_correctness=1;
catch
    
    disp([name_dataset,'中每类 ',num2str(num_train),' 个训练样本的随机数据读取失败']);
    
    index_read_correctness=0;
    rand_train=[];
    rand_test=[];
    label_train=[];
    label_test=[];
    save_part_train=[];
end

end

