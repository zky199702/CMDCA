function [samples_one,samples_two,samples_three,num_class,address,repeat_samples_all,save_part_train] =Read_dataset_three_views(name_dataset)




repeat_samples_all=10;
save_part_train=[];


switch name_dataset
        
  case 'Coil20'
        
        num_class=20;
        % Read all the sample
        load Coil20_Coi_100.mat
        load Coil20_Dau_100.mat
        load Coil20_Sym_100.mat
        samples_one=Coil20_Coi_100;
        samples_two=Coil20_Dau_100;
        samples_three=Coil20_Sym_100;
        % Some other set for algorithms
        address=[address,'\',name_dataset];

        
end

end

