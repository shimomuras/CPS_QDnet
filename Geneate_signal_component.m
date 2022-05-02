function fluorescence_result=Geneate_signal_component(folder_name,target_func)
%%
choice_parameter;
data_parameter;


gauss_fix_parameter=zeros(1,cell_num^2);
%*******************************ここからコード********************************
%フォルダの作成
% folder_name=strcat('Parameter_',num2str(sum(quantum_type_number)),'type_',num2str(quantum_number),'num_',num2str(square_distance),'nm_','gauss_',num2str(gauss_fix));
% 
% 
% if exist(folder_name)~=0
%     rmdir(folder_name,'s');
% end
% mkdir(folder_name)
% mkdir(strcat(folder_name,'/Qdot_plot'))


plot_num=round(time_scale/time_span+1);




for QD_net_number=1:Q_number

    modify_target_func=target_func;
    
%     reduced_time=0:time_step:time_scale;
%     expand_value=int64(time_step/time_span);
    
%     Irr=zeros(length(time),1);
    Irr=convert_pulse_square(modify_target_func);

    
    
    

%     disp('Prepare network')
    %Q-networkの組成とネットワークのノード間結合力
    QD_type_seq=randi(length(quantum_type_number),[cell_num^2,1]);


    iter_data_num=100;
    diff_rate=1;
    for i=1:iter_data_num
        QD_type_seq=QD_type_definition(QD_type_seq,diff_rate);
        [networkSys,Generated_qd_distance,position_value]=Generate_Q_net(QD_type_seq,cell_num,fluorescence_lifetime,...
                                                         Qdot_eff,qd_size,quantum_type_number,...
                                                         folder_name,refrac,kai2,Na);
    
    end
    if gauss_fix==1
        sigma2=(FWHM/(2*sqrt(2*log(2))))^2*eye(2);
        mu=square_distance/2*ones(1,2);
        norm_dist_fix_param=mvnpdf(position_value,mu,sigma2);
        norm_dist_fix_param=norm_dist_fix_param./mvnpdf(mu,mu,sigma2);
        Irr_fix=Irr*transpose(norm_dist_fix_param);
    else
        Irr_fix=Irr*ones(1,cell_num^2);
    end
    
    
    
    
    
[fluorescence_result,Energy_list]=cal_QD_energy_and_flu(plot_num,Irr_fix,QD_type_seq,networkSys);
    

end

%%
% disp('Show graph')
% 
% fig1=figure;
% if quantum_type_number(1)==1
%     plot(time,fluorescence_result(:,1),'DisplayName','490nm')
%     hold on
% end
% if quantum_type_number(2)==1
%     plot(time,fluorescence_result(:,2),'DisplayName','525nm')
%     hold on
% end
% if quantum_type_number(3)==1
%     plot(time,fluorescence_result(:,3),'DisplayName','575nm')
%     hold on
% end
% if quantum_type_number(4)==1
%     plot(time,fluorescence_result(:,4),'DisplayName','630nm')
%     hold on
% end
% if quantum_type_number(5)==1
%     plot(time,fluorescence_result(:,5),'DisplayName','665nm')
%     hold on
% end
% xlabel('Time [s]')
% ylabel('Intensity [a.u]')
% legend
% fig1.Position=[0,1700,1000,300];