function [target_func,norm_value]=choice_irradiation
% close all
%
% clear all

% time_span=1.0*10^-12;
% time_scale=3.0*10^-8;
% time_step=1.0*10^-9;
% time=0:time_span:time_scale;
%  Initial_Input=4.8749*10^-5;%[W/cm^2]
% choice_num=6;
%
choice_parameter;
% data_parameter;
%
load('changed_param.mat');
reduced_time=0:time_step:max(time)-time_step;
expand_value=time_step/time_span;


switch choice_num
    case 0     %テスト波
        Irr=zeros(length(reduced_time),1);
        Irr(2)=1;
        target_func=transpose(Irr);
        norm_value=max(target_func);
        
    case 1     %sin波
        frequency=1.0*10^8*pi;
        
        Irr=sin(frequency*reduced_time)+1;
        target_func=transpose(Irr);
        norm_value=max(target_func);
        
    case 2 %一定波
        
        frequency=1.0*10^8*pi;
        
        Irr=square(frequency*time)+1;
        target_func=transpose(Irr);
        norm_value=max(target_func);
        
    case 3
        %定数波
        target_func=ones(length(reduced_time),1);
        norm_value=max(target_func);
        
        
    case 4%xor波
        
        target_func=zeros(length(reduced_time),1);
        
        target_func(1)=0;
        target_func(2)=1;
        
        if delay_point>2
            for j=3:delay_point
                target_func(j)=randi([0 1]);
            end
        end
        
        for i=delay_point+1:length(reduced_time)
            target_func(i)=xor(target_func(i-1),target_func(i-delay_point));
        end
        for n=1:length(reduced_time)
            if n==1
                end_val=expand_value-1;
                Irr(1:round(end_val))=target_func(n);
            else
                start_val=(n-1)*expand_value;
                end_val=n*expand_value;
                Irr(round(start_val):round(end_val))=target_func(n);
            end
        end
        norm_value=max(target_func);
        
    case 5%logi,
        
        target_func=zeros(length(reduced_time),1);
        
        alpha=4;
        initial_value=0.2;
        
        target_func(1)=initial_value;
        
        for i=2:length(target_func)
            target_func(i)=alpha*target_func(i-1)*(1-target_func(i-1));
        end
        
        
        
        for n=1:length(target_func)
            if n==1
                Irr(1)=target_func(n);
            else
                start_val=(n-1)*expand_value;
                Irr(round(start_val))=target_func(n);
            end
        end
        Irr=form_delta_to_pulse(Irr,time,time_span);
        norm_value=max(target_func);
        
    case 6%santafe
        target_func=zeros(length(reduced_time),1);
        fileID=fopen('A.cont_mod.txt');
        end_count=length(reduced_time);
        fil_count=1;
        
        while true
            
            tiline=fgetl(fileID);         
            lead_line=split(tiline,';');
            if ismissing(lead_line)~=1
                target_func(fil_count)=str2double(lead_line);
                fil_count=fil_count+1;
            end
            if fil_count>end_count
                break;
            end
        end
        norm_value=max(target_func);
        target_func=target_func./max(target_func);
        
    case 7%nand波
        
        target_func=zeros(length(reduced_time),1);
        
%         target_func(1)=0;
%         target_func(2)=1;
%         
%         if delay_point>2
            for j=1:delay_point
                target_func(j)=randi([0 1]);
            end
%         end
        
        for i=delay_point+1:length(reduced_time)
            target_func(i)=not(and(target_func(i-1),target_func(i-delay_point)));
        end
        for n=1:length(reduced_time)
            if n==1
                end_val=expand_value-1;
                Irr(1:round(end_val))=target_func(n);
            else
                start_val=(n-1)*expand_value;
                end_val=n*expand_value;
                Irr(round(start_val):round(end_val))=target_func(n);
            end
        end
        norm_value=max(target_func);
end

