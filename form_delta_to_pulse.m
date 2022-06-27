function total_func_cos=form_delta_to_pulse(Irr,time,time_span)
% clear all
% close all
% 
% load('Parameter_2type_20num_50nm_gauss_1/param_1.mat')

% time_span=10^-12;
% time_2=0:time_span:5*10^-9;
form_shape=5*10^11;
Rep_freq=1*10^4;
%パルス半値幅：74.194ps

total_func_cos=zeros(length(Irr),1);

for i=1:length(Irr)
    if Irr(i)~=0
        func_cos=Irr(i)*cos(pi*Rep_freq*(time-(i-1)*time_span)).^(2*form_shape);
        total_func_cos=total_func_cos+transpose(func_cos);        
    end
end
% 
% plot(total_func_cos)


%options = fitoptions('gauss1','Upper',[1 1 1],'Robust','Bisquare');
% func_cos=cos(pi*Rep_freq*(time_2-max(time_2)/2)).^(2*form_shape);
% f=fit(transpose(time_2),transpose(func_cos),'gauss1',options)
% % f=fit(transpose(time_2),transpose(func_cos),'gauss1','Normalize', 'on','Robust','Bisquare')
% 
% 
% FWHM=f.c1*2*sqrt(log(2))*10^9;
% disp(strcat(num2str(FWHM),'ns'))
% 
% plot(f,time_2,func_cos)




% t=time;
% func_cos=cos(pi*Rep_fre*t).^(2*form_shape);
% Irr=Irr.*func_cos;



% func_cos=cos(pi*Rep_fre*(time_2-time_span*10^4*5)).^(2*form_shape)+cos(pi*Rep_fre*(time_2-time_span*10^4*2)).^(2*form_shape);
% % eqn=func_cos(t)==0.5;
% % sol=solve(eqn,t);
% % width=double(abs(sol(1)-sol(2)))
% % t=time;
% % func_cos=cos(pi*Rep_fre*t).^(2*form_shape);
% % Irr=Irr.*func_cos;

% plot(time_2,func_cos)