close all
clear all

data_name=dir('time_step_1ns_FRET_on_type_pulse_node_1/*.mat')
it_num=1;

qd_size=6.9;
cell_num=3;

calib_scale=72/96;
%windows
% calib_scale=1;

for it_num=1:length(data_name)
    clf
    square_distance=qd_size*(cell_num+1);
    fig=gcf;
    fig.Units='points';
    fig.InnerPosition=[100 100 400 400];
    sz=(qd_size/2*470/square_distance*calib_scale)^2*pi;
    load(strcat('time_step_1ns_FRET_on_type_pulse_node_1/',data_name(it_num).name));
    
    for i=1:length(Q_type_seq)
        if Q_type_seq(i)==1
            scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','b','MarkerEdgeColor','b')
        elseif Q_type_seq(i)==2
            scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','g','MarkerEdgeColor','g')
        elseif Q_type_seq(i)==3
            scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','None','MarkerEdgeColor','None')
        elseif Q_type_seq(i)==4
            scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','r','MarkerEdgeColor','r')
        elseif Q_type_seq(i)==5
            scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','k','MarkerEdgeColor','k')
        end
        if i~=length(Q_type_seq)
            hold on
        end
    end
    %
    xlabel('Posiiton [nm]')
    ylabel('Posiiton [nm]')
    
    xlim([0,square_distance])
    ylim([0,square_distance])
    title(strcat('Iteration: ',num2str(it_num)))
    fig_name=strcat('time_step_1ns_FRET_on_type_pulse_node_1/Qdot_plot2/graph_',num2str(it_num),'.jpg');
    saveas(fig,fig_name)
    close(gcf)
end