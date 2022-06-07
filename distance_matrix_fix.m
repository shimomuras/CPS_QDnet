function [distance_value, position_value]=distance_matrix_fix(cell_num,qd_size)
%folder_name,Q_type_seq,it_num)

position_value=zeros(cell_num^2,2);
for i=1:cell_num^2
    position_value(i,1)=mod(i-1,cell_num);
    position_value(i,2)=floor((i-1)/cell_num);
end

position_value=position_value*qd_size+qd_size;

distance_value=zeros(cell_num,cell_num);

for i=1:cell_num^2
    for j=i:cell_num^2
            distance_value(i,j)=sqrt((position_value(i,1)-position_value(j,1))^2+(position_value(i,2)-position_value(j,2))^2);
            distance_value(j,i)=distance_value(i,j);
    end
end


% for i=1:qd_number
%
% end

