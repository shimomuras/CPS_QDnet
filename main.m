close all
clear all
folder_name=strcat('Result/',datestr(datetime('now'),'yyyymmdd/HHMM'));
%%
%%%%
label_tau_list=[0.1857 0.1610 0.2990]*10^-9;
% label_tau_list=[0.4871 0.8282 0.5770]*10^-9;
% label_tau_list=[0.9302 0.4190 0.6792]*10^-9;

choice_processor='CPU';

ref_diff_rate=100;
diff_rate=100;
rate_amp=10;
iter_num=10;
temp_num=10;
change_prob_num=10;
temp_dec_rate=0.9;
ini_temp=5*10^-2;
ini_list=0:1:temp_num-1;
irr_wavelength_list=[400 425 450]*10^-9;
irr_wavelength=irr_wavelength_list(1);
WL_tau_list=zeros(1,length(irr_wavelength_list));


temp_list=ini_temp*temp_dec_rate.^ini_list;


diff_rate_list=zeros(iter_num*temp_num,1);
ref_diff_rate_list=zeros(iter_num*temp_num,1);
ave_tau_list=zeros(iter_num*temp_num,length(label_tau_list));
ref_num_list=zeros(iter_num*temp_num,1);

choice_parameter;
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

[Generated_qd_distance, position_value]=distance_matrix_fix(cell_num,qd_size);
save(strcat(folder_name,'/cell_distance_list.mat'),'Generated_qd_distance','position_value')

for tm_num=1:temp_num
    for it_num=1:iter_num
        count=count+1;
%         disp(count);
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
            [fluorescence_result,~]=cal_QD_energy_and_flu(plot_num,Irr_fix,QD_type_seq,networkSys,irr_wavelength);
            [max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
            check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;
            fix_time=time(max_position_flu:end)-max_position_flu*time_span;            
            fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp1','Lower',[0,-Inf],'Upper',[10,0]);
            WL_tau_list(WL_num)=-1/fit_result.b;
                    % fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp2','Lower',[0,-Inf,0,-Inf],'Upper',[10,0,10,0]);
                    % average_tau=(fit_result.a*(-1/fit_result.b)^2+fit_result.c*(-1/fit_result.d)^2)/(fit_result.a*(-1/fit_result.b)+fit_result.c*(-1/fit_result.d))*2;
        end

        % plot(fix_time,check_fluorescence_signal)
        %%
        diff_rate=sum(abs(WL_tau_list-label_tau_list))/mean(label_tau_list);
        
        if diff_rate<ref_diff_rate
            ref_diff_rate=diff_rate;
            ref_QD_type_seq=QD_type_seq;
            ref_num=count;
        else
            proba=exp(-(diff_rate-ref_diff_rate)/temp_list(tm_num));
            if proba>rand(1)
                ref_diff_rate=diff_rate;
                ref_QD_type_seq=QD_type_seq;
                ref_num=count;     
            end
            
        end
        ref_num_list(count)=ref_num;
        ave_tau_list(count,:)=WL_tau_list;
        diff_rate_list(count)=diff_rate;
        ref_diff_rate_list(count)=ref_diff_rate;
        
        
        
        % diff_rate=ref_diff_rate*rate_amp;
    end
end
save(strcat(folder_name,'/result.mat'),'ave_tau_list','diff_rate_list','ref_diff_rate_list','label_tau_list','ref_num_list')

%%
close all
% fig1=figure
plot(ref_diff_rate_list)
% ylim([0 .1])
ylabel('Loss function')
xlabel('Iteration')
set(gca,'FontSize',16)
saveas(gca,strcat(folder_name,'/loss_function.fig'))


[~,min_QD_net_num]=min(diff_rate_list);



save(strcat(folder_name,'/choice_parameter.mat'),...
    'diff_rate_list','time_step','time_span','time_scale','cell_num','irr_wavelength','square_distance','Initial_Input','iter_num','rate_amp','min_QD_net_num','qd_size');
