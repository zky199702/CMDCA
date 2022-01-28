function [S_intra,S_inter]=Similarity_order_matrix(samples,num_class)

num_all=size(samples,2); 
num_train=num_all/num_class; 


similarity=zeros(num_all);
for i=1:num_all
    for j=1:num_all
        similarity(i,j)=dot(samples(:,i),samples(:,j))/(sqrt(dot(samples(:,i),samples(:,i)))*(sqrt(dot(samples(:,j),samples(:,j)))));
    end
end
for i=1:num_all
    similarity(i,i)=0;
end


S_intra=zeros(size(num_all));
for k=1:num_class
    class_start=(k-1)*num_train+1;
    class_end=k*num_train;
    for i=class_start:class_end
        for j=class_start:class_end
            if i==j
                S_intra(i,j)=0;
            else
                S_intra(i,j)=num_train*similarity(i,j)-sum(similarity(i,i:class_end));
            end
        end
    end
end

S_inter=zeros(size(num_all));
for k=1:num_class
    class_start=(k-1)*num_train+1;
    class_end=k*num_train;
    for i=class_start:class_end
        for j=1:num_all
            if j<=class_end&&j>=class_start
                S_inter(i,j)=0;
            else
                S_inter(i,j)=similarity(i,j);
            end
        end
    end
end

end

