function Geneate_signal_component(folder_name,target_func,it_num)
%%
choice_parameter;
data_parameter;


gauss_fix_parameter=zeros(1,quantum_number);
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

para_name=strcat('./',folder_name,'/param_');


plot_num=round(time_scale/time_span+1);




for QD_net_number=1:Q_number

    modify_target_func=encoding_irr(QD_net_number,target_func,Q_number);
    
%     reduced_time=0:time_step:time_scale;
%     expand_value=int64(time_step/time_span);
    
%     Irr=zeros(length(time),1);
    Irr=convert_pulse_square(modify_target_func).*In_weight(QD_net_number);

    
    
    
%plot(Irr)

%     if choice_num==5||choice_num==5
%         for n=1:length(reduced_time)-1
%             if n==1
%                 start_val=1;
%                 end_val=n*expand_value-1;
%             else
%                 start_val=(n-1)*expand_value;
%                 end_val=n*expand_value;
%             end
%             Irr(round(start_val):round(end_val))=Initial_Input*modify_target_func(n);
%         end
%         
%     elseif choice_num==6
%         for n=1:length(reduced_time)-1
%             if n==1
%                 start_val=1;
%             else
%                 start_val=(n-1)*expand_value;
%             end
%             Irr(round(start_val))=Initial_Input*modify_target_func(n);
%         end
%         Irr=form_delta_to_pulse(Irr,time,time_span);
%     end
    
%     plot(Irr)
    
%     disp('Prepare network')
    %Q-networkの組成とネットワークのノード間結合力
    [Q_type_seq,networkSys,Generated_qd_distance,position_value]=Generate_Q_net(quantum_type_number, quantum_number, fluorescence_lifetime, Qdot_eff,square_distance, qd_size,folder_name,QD_net_number,spectrum_method,refrac,kai2,Na,scattering_method,scattering_param,QD_type_rate);
    
    
    if gauss_fix==1
        sigma2=(FWHM/(2*sqrt(2*log(2))))^2*eye(2);
        mu=square_distance/2*ones(1,2);
        norm_dist_fix_param=mvnpdf(position_value,mu,sigma2);
        norm_dist_fix_param=norm_dist_fix_param./mvnpdf(mu,mu,sigma2);
        Irr_fix=Irr*transpose(norm_dist_fix_param);
    else
        Irr_fix=Irr*ones(1,quantum_number);
    end
    
    
    
    
    
[fluorescence_result,Energy_list]=cal_QD_energy_and_flu(plot_num,Irr_fix,Q_type_seq,networkSys);
    
    %
%     QD_net_number
       save(strcat(para_name,num2str(it_num),'-',num2str(QD_net_number),'.mat'),'fluorescence_result','Generated_qd_distance','networkSys','Q_type_seq','Irr','position_value','Energy_list','norm_dist_fix_param');

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