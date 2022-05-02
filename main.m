close all
clear all



it_num=1;

choice_parameter;
% switch change_val_name
%     case 'time_step'
%         time_step=changed_val;
%         ns=10^9;
%         show_time_step=strcat(num2str(time_step*ns),'ns');
%     case 'total_data_num'
%         total_data_num=changed_val;
%     case 'quantum_number'
%         quantum_number=changed_val;
%     case 'irr_wavelength'
%         irr_wavelength=changed_val;
%     case 'square_distance'
%         square_distance=changed_val;
%     case 'Q_number'
%         Q_number=changed_val;
%     case 'Initial_Input'
%         Initial_Input=changed_val;
%     case 'QD_type_rate'
%         QD_type_rate=changed_val;
%     otherwise
% end
% save('changed_param.mat','time_step','show_time_step','total_data_num','quantum_number','irr_wavelength','square_distance','Q_number','Initial_Input','QD_type_rate')
[target_func,norm_value]=choice_irradiation;
data_parameter;
%フォルダの作成
%folder_name=strcat('Parameter_',num2str(sum(quantum_type_number)),'type_',num2str(quantum_number),'num_',num2str(square_distance),'nm_gauss_',num2str(gauss_fix),'_dalay_',delay_point);
if exist(folder_name)~=0
    rmdir(folder_name,'s');
end
mkdir(folder_name)
mkdir(strcat(folder_name,'/Qdot_plot'))

fluorescence_result=Geneate_signal_component(folder_name,target_func);
[max_amp,max_position_flu]=max(fluorescence_result(:,wavelength_choice));
check_fluorescence_signal=fluorescence_result(max_position_flu:end,wavelength_choice)./max_amp;



fix_time=time(max_position_flu:end)-max_position_flu*time_span;
plot(fix_time,check_fluorescence_signal)
%%
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,-Inf,0,-Inf],...
               'Upper',[10,0,10,0],...
               'StartPoint',[1 0 1 0]);
fit_result=fit(transpose(fix_time),check_fluorescence_signal,'exp2','Lower',[0,-Inf,0,-Inf],'Upper',[10,0,10,0]);
average_tau=(fit_result.a*(-1/fit_result.b)^2+fit_result.c*(-1/fit_result.d)^2)/(fit_result.a*(-1/fit_result.b)+fit_result.c*(-1/fit_result.d));



