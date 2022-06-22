function [distance_value, position_value]=distance_matrix_fix3D(cell_num,qd_size)
%folder_name,Q_type_seq,it_num)
% clear all
% close all
% 
% cell_num=5;
% qd_size=6.9;

position_value=zeros(cell_num^2,3);
for i=1:cell_num^3
    position_value(i,3)=floor((i-1)/cell_num.^2);
    mod_value_1=mod((i-1),cell_num.^2);
    position_value(i,2)=floor(mod_value_1/cell_num);
    position_value(i,1)=mod(mod_value_1,cell_num);
end

position_value=position_value*qd_size+qd_size;

distance_value=zeros(cell_num.^3,cell_num.^3);

for i=1:cell_num^3
    for j=i:cell_num^3
            distance_value(i,j)=sqrt((position_value(i,1)-position_value(j,1))^2+(position_value(i,2)-position_value(j,2))^2+(position_value(i,3)-position_value(j,3))^2);
            distance_value(j,i)=distance_value(i,j);
    end
end

