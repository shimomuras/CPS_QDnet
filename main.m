close all
clear all
folder_name=strcat('Result/',datestr(datetime('now')));
label_tau_value=7.85*10^-9;
ref_diff_rate=1;
diff_rate=1;
rate_amp=10;
iter_num=1;
temp_num=100;
change_prob_num=10;
temp_dec_rate=0.9;
ini_temp=5*10^-2;
ini_list=0:1:temp_num-1;
temp_list=ini_temp*temp_dec_rate.^ini_list;
diff_rate_list=zeros(iter_num*temp_num,1);
ref_diff_rate_list=zeros(iter_num*temp_num,1);
ave_tau_list=zeros(iter_num*temp_num,1);

choice_parameter;
change_prob=change_prob_num/cell_num^2;
[target_func,norm_value]=choice_irradiation;
data_parameter;
%ÉtÉHÉãÉ_ÇÃçÏê¨
%folder_name=strcat('Parameter_',num2str(sum(quantum_type_number)),'type_',num2str(quantum_number),'num_',num2str(square_distance),'nm_gauss_',num2str(gauss_fix),'_dalay_',delay_point);

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
for tm_num=1:temp_num
    for it_num=1:iter_num
        count=count+1;
        
        while true
            QD_type_seq=QD_type_definition(ref_QD_type_seq,change_prob,quantum_type_number);
            if sum(QD_type_seq)~=3*cell_num.^2
                break;
            end
        end
        
        [fluorescence_result,QD_type_seq]=Geneate_signal_component(folder_name,target_func,ref_diff_rate,count,QD_type_seq);
        [max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
        check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;
        
        
        % close all
        fix_time=time(max_position_flu:end)-max_position_flu*time_span;
        % plot(fix_time,check_fluorescence_signal)
        %%
        fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp1','Lower',[0,-Inf],'Upper',[10,0]);
        % fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp2','Lower',[0,-Inf,0,-Inf],'Upper',[10,0,10,0]);
        % average_tau=(fit_result.a*(-1/fit_result.b)^2+fit_result.c*(-1/fit_result.d)^2)/(fit_result.a*(-1/fit_result.b)+fit_result.c*(-1/fit_result.d))*2;
        average_tau=-1/fit_result.b*2;
        diff_rate=abs((average_tau-label_tau_value)/label_tau_value);
        
        if diff_rate<ref_diff_rate
            ref_diff_rate=diff_rate;
            ref_QD_type_seq=QD_type_seq;
            ref_num=count;
            title(strcat('Iteration: ',num2str(count)))
            fig_name=strcat(folder_name,'/ref_Qdot_plot/graph_',num2str(count),'.jpg');
            
            saveas(gcf,fig_name)
        else
            proba=exp(-(diff_rate-ref_diff_rate)/temp_list(tm_num))
            if proba>rand(1)
                ref_diff_rate=diff_rate;
                ref_QD_type_seq=QD_type_seq;
                ref_num=count;
                title(strcat('Iteration: ',num2str(count)))
                fig_name=strcat(folder_name,'/ref_Qdot_plot/graph_',num2str(count),'.jpg');
                saveas(gcf,fig_name)
            else
                
                calib_scale=72/96;
                load(strcat(folder_name,'/QD_posi_',num2str(ref_num),'.mat'))
                %windows
                % calib_scale=1;
                clf
                square_distance=qd_size*(cell_num+1);
                fig=gcf;
                fig.Units='points';
                fig.InnerPosition=[100 100 400 400];
                sz=(qd_size/2*450/square_distance*calib_scale)^2*pi;
                
                
                for i=1:length(Q_type_seq)
                    if Q_type_seq(i)==1
                        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','b','MarkerEdgeColor','b')
                    elseif Q_type_seq(i)==2
                        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','g','MarkerEdgeColor','g')
                    elseif Q_type_seq(i)==3
                        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','None','MarkerEdgeColor','None')
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
                title(strcat('Iteration: ',num2str(count)))
                fig_name=strcat(folder_name,'/ref_Qdot_plot/graph_',num2str(count),'.jpg');
                saveas(fig,fig_name)  
            end
            
        end
        ave_tau_list(count)=average_tau;
        diff_rate_list(count)=diff_rate;
        ref_diff_rate_list(count)=ref_diff_rate;
        
        
        
        % diff_rate=ref_diff_rate*rate_amp;
    end
end

%%
close all
% fig1=figure
plot(ref_diff_rate_list)
% ylim([0 .1])
ylabel('Loss function')
xlabel('Iteration')
set(gca,'FontSize',16)
saveas(gca,strcat(folder_name,'/loss_function.fig'))
[~,min_QD_net_num]=min(diff_rate_list)


save(strcat(folder_name,'/choice_parameter.mat'),...
    'diff_rate_list','time_step','time_span','time_scale','cell_num','irr_wavelength','square_distance','Initial_Input','iter_num','rate_amp','min_QD_net_num');
