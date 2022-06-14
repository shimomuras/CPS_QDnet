close all
clear all

OS_name='mac';
day_name='20220607';
time_name='1825';
choice_parameter;
qd_size=6.9;

result_folder_name=strcat('./Result/',day_name,'/',time_name);

mkdir(strcat(result_folder_name,'/ref_QD_net'))

load(strcat(result_folder_name,'/cell_distance_list.mat'))
load(strcat(result_folder_name,'/result.mat'))

for i=1:length(ref_num_list)
    if ref_num_list(i)==i
        name,'/QD_type_',num2str(i),'.mat'))
    end
    show_QDnet(OS_name,position_value,qd_size,cell_num,QD_type_seq,i)
%     title(strcat('Iteration:',num2str(i)))
    fig_name=strcat(result_folder_name,'/ref_QD_net/graph_',num2str(i),'.jpg');
    saveas(gcf,fig_name)
end