function Irr=convert_pulse_square(modify_target_func)
choice_parameter;
load('changed_param.mat');

reduced_time=0:time_step:time_scale;
expand_value=int64(time_step/time_span);

Irr=zeros(length(time),1);

switch irradiation_type
    
    case 'square'
        for n=1:length(reduced_time)-1
            if n==1
                start_val=1;
                end_val=n*expand_value-1;
            else
                start_val=(n-1)*expand_value;
                end_val=n*expand_value;
            end
            Irr(round(start_val):round(end_val))=Initial_Input*modify_target_func(n);
        end
        
    case 'pulse'
        for n=1:length(reduced_time)-1
            if n==1
                start_val=1;
            else
                start_val=(n-1)*expand_value;
            end
            Irr(round(start_val))=Initial_Input*modify_target_func(n);
        end
%         plot(Irr)
        Irr=form_delta_to_pulse(Irr,time,time_span);
end