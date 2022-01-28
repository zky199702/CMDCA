function [samples_train,samples_test] = TBox_readsamples_label(samples,label_train,label_test)
   
     samples_train=samples(:,label_train);
   
       samples_train_mean=mean(samples_train,2);
      samples_train=samples_train-repmat(samples_train_mean,1,size(samples_train,2));
      
   

       samples_test=samples(:,label_test);
    
     samples_test=samples_test-repmat(samples_train_mean,1,size(samples_test,2));
    
end

