function [distance_value, position_value]=distance_matrix_fix(cell_num,qd_size,folder_name,Q_type_seq,it_num)
% clear all
% close all
% %
% qd_number=10;
% square_distance=100;
%
% qd_size=6.9;
% cell_num=4;
% Q_type_seq=randi(3,[cell_num^2,1]);
% square_distance=qd_size*(cell_num+1);

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

position_value=gpuArray(position_value);

save(strcat(folder_name,'/QD_posi_',num2str(it_num),'.mat'),'Q_type_seq','position_value')
% %mac
% calib_scale=72/96;
% %windows
% % calib_scale=1;
% clf
% square_distance=qd_size*(cell_num+1);
% fig=gcf;
% fig.Units='points';
% fig.InnerPosition=[100 100 400 400];
% sz=(qd_size/2*450/square_distance*calib_scale)^2*pi;
% 
% 
% for i=1:length(Q_type_seq)
%     if Q_type_seq(i)==1
%         scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','b','MarkerEdgeColor','b')
%     elseif Q_type_seq(i)==2
%         scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','g','MarkerEdgeColor','g')
%     elseif Q_type_seq(i)==3
%         scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','None','MarkerEdgeColor','None')
%     end
%     if i~=length(Q_type_seq)
%         hold on
%     end
% end
% % 
% xlabel('Posiiton [nm]')
% ylabel('Posiiton [nm]')
% 
% xlim([0,square_distance])
% ylim([0,square_distance])
% title(strcat('Iteration: ',num2str(it_num)))
% fig_name=strcat(folder_name,'/Qdot_plot/graph_',num2str(it_num),'.jpg');
%  saveas(fig,fig_name)
% disp('dekita')
% close(gcf)


% for i=1:qd_number
%
% end

