function [acc_best,dim_best,acc_all,dim_all]=STBox_acc_dim_three_unequal(project_vectors_one,project_vectors_two,project_vectors_three,samples_one_train,samples_one_test,samples_two_train,samples_two_test,samples_three_train,samples_three_test,label_train,label_test)




acc_all=[];
dim_all=[];
for num_dim=1:size(project_vectors_one,2)
    
    project_samples_train=project_vectors_one(:,1:num_dim)'*samples_one_train+project_vectors_two(:,1:num_dim)'*samples_two_train+project_vectors_three(:,1:num_dim)'*samples_three_train;
    project_samples_test=project_vectors_one(:,1:num_dim)'*samples_one_test+project_vectors_two(:,1:num_dim)'*samples_two_test+project_vectors_three(:,1:num_dim)'*samples_three_test;
    
    
    label_test_knn=knnclassify(real(project_samples_test'),real(project_samples_train'),label_train,1,'euclidean');
    accuracy=sum(label_test_knn==label_test)/length(label_test);
    acc_all=[acc_all;accuracy*100];
    dim_all=[dim_all;num_dim];
    
end
[acc_best,acc_best_index]=max(acc_all);
dim_best=dim_all(acc_best_index);

end

