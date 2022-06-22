close all
clear all
folder_name=strcat('Result/',datestr(datetime('now'),'yyyymmdd/HHMM'));
choice_parameter;
%%
%%%%
data_No=1;
test_wavelength=400;
test_irr_wavelength=test_wavelength*10^-9;

[ref_signal,test_signal,irr_wavelength_list]=load_decay_data(data_No,test_wavelength,total_data_num);


%%%%%%%%%%initialize%%%%%%%%%%%
ref_loss_value=100;
MSE_list=zeros(1,length(irr_wavelength_list));
loss_value_list=zeros(iter_num*temp_num,1);
min_loss_value_list=zeros(iter_num*temp_num,1);
ave_MSE_list=zeros(iter_num*temp_num,length(irr_wavelength_list));
ref_num_list=zeros(iter_num*temp_num,1);
irr_wavelength=400*10^-9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

change_prob=change_prob_num/cell_num^2;
[target_func,norm_value]=choice_irradiation;
data_parameter;

mkdir(folder_name)
mkdir(strcat(folder_name,'/Qdot_plot'))
mkdir(strcat(folder_name,'/ref_Qdot_plot'))

QD_type_seq=randi(length(quantum_type_number),[cell_num^2,1]);
for i=1:length(QD_type_seq)
    if quantum_type_number(QD_type_seq(i))==0
        while true
            fix_dice=randi(length(quantum_type_number));
            if quantum_type_number(fix_dice)~=0
                break;
            end
        end
        QD_type_seq(i)=fix_dice;
    end
end

ref_QD_type_seq=QD_type_seq;
count=0;
ref_num=0;

if dimension==2
    [Generated_qd_distance, position_value]=distance_matrix_fix(cell_num,qd_size);
elseif dimension==3
    [Generated_qd_distance, position_value]=distance_matrix_fix3D(cell_num,qd_size);
end

save(strcat(folder_name,'/cell_distance_list.mat'),'Generated_qd_distance','position_value')

for tm_num=1:temp_num
    for it_num=1:iter_num
        count=count+1;
        
        while true
            QD_type_seq=QD_type_definition(ref_QD_type_seq,change_prob,quantum_type_number);
            if sum(QD_type_seq)~=3*cell_num.^2
                break;
            end
        end
        
        save(strcat(folder_name,'/QD_type_',num2str(count),'.mat'),'QD_type_seq')
        
        plot_num=round(time_scale/time_span+1);
        Irr=convert_pulse_square(target_func);
        
        networkSys=Generate_Q_net(Generated_qd_distance,QD_type_seq,cell_num,fluorescence_lifetime,...
            Qdot_eff,refrac,kai2,Na);
        
        if gauss_fix==1
            sigma2=(FWHM/(2*sqrt(2*log(2))))^2*eye(2);
            mu=square_distance/2*ones(1,2);
            norm_dist_fix_param=mvnpdf(position_value,mu,sigma2);
            norm_dist_fix_param=norm_dist_fix_param./mvnpdf(mu,mu,sigma2);
            Irr_fix=Irr*transpose(norm_dist_fix_param);
        else
            Irr_fix=Irr*ones(1,cell_num^2);
        end
        
        for WL_num=1:length(irr_wavelength)
            irr_wavelength=irr_wavelength_list(WL_num);
            fluorescence_result=cal_QD_energy_and_flu(plot_num,Irr_fix,QD_type_seq,networkSys,irr_wavelength,choice_processor);
            [max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
            check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;
%             fix_time=time(max_position_flu:end)-max_position_flu*time_span;
            reference_signal=ref_signal(:,WL_num);
            MSE_list(WL_num)=immse(reference_signal(1:length(check_fluorescence_signal)),check_fluorescence_signal);



            % fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp2','Lower',[0,-Inf,0,-Inf],'Upper',[10,0,10,0]);
            % average_tau=(fit_result.a*(-1/fit_result.b)^2+fit_result.c*(-1/fit_result.d)^2)/(fit_result.a*(-1/fit_result.b)+fit_result.c*(-1/fit_result.d))*2;
        end
        
        % plot(fix_time,check_fluorescence_signal)
        %%



        loss_value=mean(MSE_list);
        
        if loss_value<ref_loss_value
            ref_loss_value=loss_value;
            ref_QD_type_seq=QD_type_seq;
            ref_num=count;
        else
            proba=exp(-(loss_value-ref_loss_value)/temp_list(tm_num));
            if proba>rand(1)
                ref_loss_value=loss_value;
                ref_QD_type_seq=QD_type_seq;
                ref_num=count;
            end
            
        end
        ref_num_list(count)=ref_num;
        ave_MSE_list(count,:)=MSE_list;
        loss_value_list(count)=loss_value;
        min_loss_value_list(count)=ref_loss_value;
        
        
    end
    ave_MSE_list(count,:)=MSE_list;
    loss_value_list(count)=loss_value;
    min_loss_value_list(count)=ref_loss_value;
    
    
    
    % diff_rate=ref_diff_rate*rate_amp;
end







%%
close all
% fig1=figure
subplot(1,4,1)
plot(min_loss_value_list)
ylabel('Loss function')
xlabel('Iteration')
set(gca,'FontSize',16)



[~,min_QD_net_num]=min(loss_value_list);
%%
save(strcat(folder_name,'/train_data.mat'),...
    'ave_MSE_list','test_wavelength','data_No','irr_wavelength_list','ref_signal',...
    'Initial_Input','iter_num','min_QD_net_num','plot_num','Irr_fix','loss_value_list','min_loss_value_list');


%%
%test

copyfile("choice_parameter.m",folder_name)
copyfile("data_parameter.m",folder_name)
load(strcat(folder_name,'/QD_type_',num2str(min_QD_net_num),'.mat'))

networkSys=Generate_Q_net(Generated_qd_distance,QD_type_seq,cell_num,fluorescence_lifetime,Qdot_eff,refrac,kai2,Na);
for i=1:length(irr_wavelength_list)
    subplot(1,4,i+1)
    fluorescence_result=cal_QD_energy_and_flu(plot_num,Irr_fix,QD_type_seq,networkSys,irr_wavelength_list(i),choice_processor);
    [max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
    check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;
    reference_signal=ref_signal(:,i);
    time=0:time_span:time_span*(length(check_fluorescence_signal)-1);
    time=time*10^12;
    plot(time,check_fluorescence_signal)
    hold on
    plot(time,reference_signal(1:length(check_fluorescence_signal)))
    title(strcat('Validation ',num2str(irr_wavelength_list(i)*10^9),'nm'))
    xlabel('Time [ps]')
    ylabel('Fluorescence intensity [a.u.]')
    legend('Smu','Exp')
end


fluorescence_result=cal_QD_energy_and_flu(plot_num,Irr_fix,QD_type_seq,networkSys,irr_wavelength_list(i),choice_processor);
[max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;

validation_MSE=ref_loss_value;
test_MSE=immse(test_signal(1:length(check_fluorescence_signal)),check_fluorescence_signal)

component_rate=nnz(QD_type_seq==1)/nnz(QD_type_seq==2)


subplot(1,4,4)
    time=0:time_span:time_span*(length(check_fluorescence_signal)-1);
    time=time*10^12;
plot(time,check_fluorescence_signal)
hold on
plot(time,test_signal(1:length(check_fluorescence_signal)))
title(strcat('Test ',num2str(test_wavelength),'nm'))
xlabel('Time [ps]')
ylabel('Fluorescence intensity [a.u.]')
legend('Smu','Exp')
saveas(gca,strcat(folder_name,'/loss_and_prediction.fig'))
save(strcat(folder_name,'/result_prediction.mat'),...
    'test_MSE','validation_MSE','component_rate');
