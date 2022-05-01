close all
clear all
tic;
toc;

<<<<<<< HEAD
change_val_name='QD_type_rate';
=======
change_val_name='time_step';
>>>>>>> 722656639c4031669bcd6022679c2b7cb7367c21
change_val=0;
val_list=1*10^-9;
search_data_num=length(val_list);
% start_data_num:(end_data_num-start_data_num)/(search_data_num-1):end_data_num;

% choice_parameter;
% data_parameter;


%Amplication_rate=10^20;


% plot(target_func)

program_start=clock;
show_imp_time=['start time ',num2str(program_start(2)),'/',num2str(program_start(3)),' ',num2str(program_start(4)),':',num2str(program_start(5))];
disp(show_imp_time)
time_sta=tic;

for search_num=1:search_data_num
    changed_val=val_list(search_num);
    choice_parameter;
    switch change_val_name
        case 'time_step'
            time_step=changed_val;
            ns=10^9;
            show_time_step=strcat(num2str(time_step*ns),'ns');
        case 'total_data_num'
            total_data_num=changed_val;         
        case 'quantum_number'
            quantum_number=changed_val;         
        case 'irr_wavelength'
            irr_wavelength=changed_val;          
        case 'square_distance'
            square_distance=changed_val;         
        case 'Q_number'
            Q_number=changed_val;
        case 'Initial_Input'
            Initial_Input=changed_val;
        case 'QD_type_rate'
            QD_type_rate=changed_val;    
        otherwise
    end
    save('changed_param.mat','time_step','show_time_step','total_data_num','quantum_number','irr_wavelength','square_distance','Q_number','Initial_Input','QD_type_rate')
    [target_func,norm_valuie]=choice_irradiation;
    data_parameter;
    %フォルダの作成
    %folder_name=strcat('Parameter_',num2str(sum(quantum_type_number)),'type_',num2str(quantum_number),'num_',num2str(square_distance),'nm_gauss_',num2str(gauss_fix),'_dalay_',delay_point);
    if exist(folder_name)~=0
        rmdir(folder_name,'s');
    end
    mkdir(folder_name)
    mkdir(strcat(folder_name,'/Qdot_plot'))
    
    
    evaluation_list_train=zeros(itar_number,1);
    evaluation_list_test=zeros(itar_number,1);
    ridge_patameter_list=zeros(itar_number,1);
    
    
    
    for it_num=1:itar_number
        acc_train=0;
        acc_pre=0;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ネットワーク生成%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Geneate_signal_component(folder_name,target_func,it_num);
        
        if it_num==1&&search_num==1
            process_time=toc(time_sta);
            elapse_time=process_time*itar_number*search_data_num;
            [time_hour,elapse_time_min]=quorem(sym(round(elapse_time)),sym(3600));
            [time_min,time_sec]=quorem(sym(elapse_time_min),sym(60));
            show_process_time=['Complete time: ',num2str(double(time_hour)),'h ',num2str(double(time_min)),'m ',num2str(double(time_sec)),'s'];
            disp(show_process_time)
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%学習過程%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Read_out=zeros(length(time)-1,Q_number);
        %since fast data of Read_out is all 0 and last data must be deleted to
        %adjust data number between train and label.
        
        %load QD data
        for i=1:Q_number
            load(strcat(folder_name,'/param_',num2str(it_num),'-',num2str(i),'.mat'));
            fix_fluorescence_result=fluorescence_result(2:end, wavelength_choice);
            Read_out(:,i)=fix_fluorescence_result;
            if choice_num==0
                plot(time,fluorescence_result(:,wavelength_choice)./max(fluorescence_result(:,wavelength_choice)));
                hold on
            end
            
        end
        if choice_num==0
            error('test responce');
        end
        
        
        %detect_data
        detect_Read_out=Detect_data(Read_out,time_span,detect_time_step);
        
        % Activtion of nonlinear function
        Activated_Read_out=activation_func(detect_Read_out,node_func);
        
        %Read_out=Read_out.*Amplication_rate;
        min_Read_out=min(min(Activated_Read_out));
        norm_Read_out=max(max(Activated_Read_out-min_Read_out));
        
        scaled_Read_out=(Activated_Read_out-min_Read_out)./norm_Read_out*scaling_rate(2)+scaling_rate(1);
        
        
        
        
        %last data is deleted because
        training_data=scaled_Read_out(2:end-1,:);
        
        % Define label. fist data is deleted bacause fast label is arrangement 0 of irr.
        %second label is input data against fist output data and deleted.
        labeled_data=norm_valuie.*target_func(3:end);
        
        
        %discard initial rise fluorescence
        fix_label_data=labeled_data(start_learning-1:end,:);
        fix_Read_out=training_data(start_learning-1:end,:);
        %     fix_label_data=labeled_data;
        %     fix_Read_out=training_data;
        %fix_Read_out=1-fix_Read_out;
        
        [train_data,test_data,train_label,test_label]=train_test_split_data(fix_Read_out,fix_label_data,split_rate);
        
        if strcmp(evaluation_method,'acc')==1
            [Predict_data_train,mean_predict,evaluation_train,Weight_node,ridge_parameter]=ridge_tuning_01(train_data,train_label,min_ridge_parameter,max_ridge_parameter);
            Predict_output_train=Weight_node(2:end)*transpose(train_data)+Weight_node(1);
            Predict_output_test=Weight_node(2:end)*transpose(test_data)+Weight_node(1);
            [Predict_data_test,evaluation_test]=acc_validation_test(Predict_output_test,test_label,mean_predict);
            
        elseif strcmp(evaluation_method,'rmse')==1
            [evaluation_train,Weight_node,ridge_parameter]=ridge_tuning_nmse(train_data,train_label,min_ridge_parameter,max_ridge_parameter);
            Predict_data_train=0;
            mean_predict=0;
            Predict_output_train=Weight_node(2:end)*transpose(train_data)+Weight_node(1);
            Predict_output_test=Weight_node(2:end)*transpose(test_data)+Weight_node(1);
            evaluation_test=(sum(test_label-transpose(Predict_output_test)).^2)/(std(test_label)*length(test_label));
            Predict_data_test=0;
        end
        
        evaluation_list_train(it_num)=evaluation_train;
        ridge_patameter_list(it_num)=ridge_parameter;
        
        evaluation_list_test(it_num)=evaluation_test;
        
        save(strcat(folder_name,'/train_data_',num2str(it_num),'.mat'),'Weight_node',...
            'Predict_data_train','Predict_data_test','min_Read_out','norm_Read_out',...
            'mean_predict','fix_label_data','evaluation_train','evaluation_test',...
            'fix_Read_out','train_data','test_data','train_label','test_label');
        
    end
    
    
    ns=10^-9;
    time_ns=0:time_step/ns:time_step/ns*viewing_number;
    
    show_time_step=num2str(time_step/ns);
    show_Q_number=num2str(Q_number);
    
    mean_eval_train=round(mean(evaluation_list_train),3);
    max_eval_train=round(max(evaluation_list_train),3);
    min_eval_train=round(min(evaluation_list_train),3);
    view_predict_output_train=Predict_output_train(end-viewing_number:end);
    view_fix_label_data_train=train_label(end-viewing_number:end);
    
    
    mean_eval_test=round(mean(evaluation_list_test),3);
    max_eval_test=round(max(evaluation_list_test),3);
    min_eval_test=round(min(evaluation_list_test),3);
    view_predict_output_test=Predict_output_test(end-viewing_number:end);
    view_fix_label_data_test=test_label(end-viewing_number:end);
    
    
    
    %title_name_train=strcat('train_time-step-',show_time_step,'ns-acc-',num2str(min_acc_train),'-',num2str(mean_acc_train),'-',num2str(max_acc_train),'-FRET-',FRET_implementation);
    if choice_num==4||choice_num==7
        title_name_test=strcat('test time-step-',show_time_step,'ns-acc-',num2str(min_eval_test),'-',num2str(mean_eval_test),'-',num2str(max_eval_test),'-FRET-',FRET_implementation);
    else
        title_name_test=strcat('test time-step-',show_time_step,'ns-nmse-',num2str(max_eval_test),'-',num2str(mean_eval_test),'-',num2str(max_eval_test),'-FRET-',FRET_implementation);
    end
    
    min_view_Predict_output_test=min(view_predict_output_test);
    norm_predict_data_test=max(view_predict_output_test-min_view_Predict_output_test);
    %view_predict_output_test=(view_predict_output_test-min_view_Predict_output_test)./norm_predict_data_test;
    
    
    figure
    figb=gca;
    plot(time_ns,view_fix_label_data_test,'--')
    hold on
    ylabel('Predict value')
    yyaxis right
    plot(time_ns,view_predict_output_test)
    hold on
    legend('Label','Predict')
    %title(title_name_test)
    xlabel('Time step [a.u.]')
    ylabel('Predicted output [a.u.]')
    set(gca,'Position',[0.2 0.2 0.6 0.6],'Fontsize',25,'Fontname','Helvetica')
    saveas(gcf,strcat(folder_name,'/signal_',title_name_test,'.jpg'))
    
    
    if strcmp(evaluation_method,'acc')==1
        figure
        figd=gca;
        histogram(evaluation_list_test,'BinWidth',0.01,'BinLimits',[0.3,1])
        title(title_name_test)
        xlabel('Accuracy')
        saveas(gcf,strcat(folder_name,'/hist_',title_name_test,'.jpg'))
        disp(['train accuracy: ',num2str(mean_eval_train)]);
        disp(['test accuracy: ',num2str(mean_eval_test)]);
        save(strcat(folder_name,'/accuracy_rate.mat'),'ridge_patameter_list','evaluation_list_train','evaluation_list_test','mean_eval_train','mean_eval_test');
    else
        figure
        figd=gca;
        plot(time_ns,abs(transpose(view_predict_output_test)-view_fix_label_data_test))
        title(title_name_test)
        xlabel('time step [a.u.]')
        saveas(gcf,strcat(folder_name,'/diff_',title_name_test,'.jpg'))
        disp(['train nmse: ',num2str(mean_eval_train)]);
        disp(['test nmse: ',num2str(mean_eval_test)]);
        save(strcat(folder_name,'/rmse.mat'),'ridge_patameter_list','evaluation_list_train','evaluation_list_test','mean_eval_train','mean_eval_test');
    end
    
    %%
    save(strcat(folder_name,'/choice_parameter.mat'),...
        'time_span','time_scale','time_step','quantum_type_number',...
        'quantum_number','square_distance','Q_number','QD_wavelength',...
        'delay_point','encoding_num','spectrum_method',...
        'FWHM','Intensity_amp','wavelength_choice','FRET_implementation',...
        'scaling_rate','Initial_Input','weight_in_type','In_weight','devide_number',...
        'show_time_step','itar_number','delay_irr_num','evaluation_method',...
        'choice_num','irradiation_type','irr_wavelength','total_data_num','change_val_name','search_data_num','val_list');
end
%main_2;

