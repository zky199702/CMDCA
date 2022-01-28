function  [project_vectors_one,project_vectors_two,project_vectors_three,r] = CMDCA(samples_one_train,samples_two_train,samples_three_train,num_class)

[dim_one,num_one]=size(samples_one_train);
[dim_two,num_two]=size(samples_two_train);
[dim_three,num_three]=size(samples_three_train);

if(num_one ~= num_two)|| (num_one ~= num_three)||(num_two ~= num_three)
    disp('the number of the data is not same with the clabel matrix');
    return;
end
S_all=cell(3,2);
[S_all{1,1},S_all{1,2}]=Similarity_order_matrix(samples_one_train,num_class);
[S_all{2,1},S_all{2,2}]=Similarity_order_matrix(samples_two_train,num_class);
[S_all{3,1},S_all{3,2}]=Similarity_order_matrix(samples_three_train,num_class);

LXX_intra=diag(sum(S_all{1,1}.*S_all{1,1})+sum(S_all{1,1}.*S_all{1,1},2)')-S_all{1,1}.*S_all{1,1}-(S_all{1,1}.*S_all{1,1})';
LYY_intra=diag(sum(S_all{2,1}.*S_all{2,1})+sum(S_all{2,1}.*S_all{2,1},2)')-S_all{2,1}.*S_all{2,1}-(S_all{2,1}.*S_all{2,1})';
LZZ_intra=diag(sum(S_all{3,1}.*S_all{3,1})+sum(S_all{3,1}.*S_all{3,1},2)')-S_all{3,1}.*S_all{3,1}-(S_all{3,1}.*S_all{3,1})';
LXY_intra=diag(sum(S_all{1,1}.*S_all{2,1})+sum(S_all{1,1}.*S_all{2,1},2)')-S_all{1,1}.*S_all{2,1}-(S_all{1,1}.*S_all{2,1})';
LYX_intra=diag(sum(S_all{2,1}.*S_all{1,1})+sum(S_all{2,1}.*S_all{1,1},2)')-S_all{2,1}.*S_all{1,1}-(S_all{2,1}.*S_all{1,1})';
LXZ_intra=diag(sum(S_all{1,1}.*S_all{3,1})+sum(S_all{1,1}.*S_all{3,1},2)')-S_all{1,1}.*S_all{3,1}-(S_all{1,1}.*S_all{3,1})';
LZX_intra=diag(sum(S_all{3,1}.*S_all{1,1})+sum(S_all{3,1}.*S_all{1,1},2)')-S_all{3,1}.*S_all{1,1}-(S_all{3,1}.*S_all{1,1})';
LYZ_intra=diag(sum(S_all{2,1}.*S_all{3,1})+sum(S_all{2,1}.*S_all{3,1},2)')-S_all{2,1}.*S_all{3,1}-(S_all{2,1}.*S_all{3,1})';
LZY_intra=diag(sum(S_all{3,1}.*S_all{2,1})+sum(S_all{3,1}.*S_all{2,1},2)')-S_all{3,1}.*S_all{2,1}-(S_all{3,1}.*S_all{2,1})';

LXY_inter=diag(sum(S_all{1,2}.*S_all{2,2})+sum(S_all{1,2}.*S_all{2,2},2)')-S_all{1,2}.*S_all{2,2}-(S_all{1,2}.*S_all{2,2})';
LYX_inter=diag(sum(S_all{2,2}.*S_all{1,2})+sum(S_all{2,2}.*S_all{1,2},2)')-S_all{2,2}.*S_all{1,2}-(S_all{2,2}.*S_all{1,2})';
LXZ_inter=diag(sum(S_all{1,2}.*S_all{3,2})+sum(S_all{1,2}.*S_all{3,2},2)')-S_all{1,2}.*S_all{3,2}-(S_all{1,2}.*S_all{3,2})';
LZX_inter=diag(sum(S_all{3,2}.*S_all{1,2})+sum(S_all{3,2}.*S_all{1,2},2)')-S_all{3,2}.*S_all{1,2}-(S_all{3,2}.*S_all{1,2})';
LYZ_inter=diag(sum(S_all{2,2}.*S_all{3,2})+sum(S_all{2,2}.*S_all{3,2},2)')-S_all{2,2}.*S_all{3,2}-(S_all{2,2}.*S_all{3,2})';
LZY_inter=diag(sum(S_all{3,2}.*S_all{2,2})+sum(S_all{3,2}.*S_all{2,2},2)')-S_all{3,2}.*S_all{2,2}-(S_all{3,2}.*S_all{2,2})';

Sxx=zeros(dim_one);


Sxy=samples_one_train*(LXY_inter-LXY_intra)*samples_two_train';
Syx=samples_one_train*(LYX_inter-LYX_intra)*samples_two_train';
Sxz=samples_one_train*(LXZ_inter-LXZ_intra)*samples_three_train';
Szx=samples_one_train*(LZX_inter-LZX_intra)*samples_three_train';


Syy=zeros(dim_two);

Syz=samples_two_train*(LYZ_inter-LYZ_intra)*samples_three_train';
Szy=samples_two_train*(LZY_inter-LZY_intra)*samples_three_train';

Szz=zeros(dim_three);

S_xx=samples_one_train*LXX_intra*samples_one_train';
S_yy=samples_two_train*LYY_intra*samples_two_train';
S_zz=samples_three_train*LZZ_intra*samples_three_train';


S=[Sxx Sxy Sxz; Syx Syy Syz; Szx Szy Szz];

S_D=blkdiag(S_xx,S_yy,S_zz);

if rank(S_D) <dim_one+dim_two+dim_three
    S_D = S_D + 0.001 * eye(dim_one+dim_two+dim_three);
    disp('singular S_D');
end
[U,D] = eig(S,S_D);
r = min(rank(S_D),dim_one);
[d_sort,index] = sort(abs(diag(D)),'descend');
U = U(:,index);
temp_Wxyz = U(:,1:r);
Wxyz=zeros(size(temp_Wxyz));

for i=1:r
    temp = temp_Wxyz(:,i);
    Wxyz(:,i) = temp./sqrt(temp'*S_D*temp);
end

project_vectors_one=Wxyz(1:dim_one,:);
project_vectors_two=Wxyz(dim_one+1:dim_one+dim_two,:);
project_vectors_three=Wxyz(dim_one+dim_two+1:dim_one+dim_two+dim_three,:);


end



