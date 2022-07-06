clear all
close all 

irr_intensity=5.7;%[W/cm^2]
time_span=10^-12;
time=0:time_span:4*10^-9;
form_shape=5*10^11;
Rep_freq=1*10^4;
%パルス半値幅：74.194ps

% func_cos=cos(pi*Rep_freq*(time-time_span*length(time)/2)).^(2*form_shape);
 
%  plot(func_cos)

options = fitoptions('gauss1','Upper',[1 1 1],'Robust','Bisquare');
 func_cos=cos(pi*Rep_freq*(time-max(time)/2)).^(2*form_shape);
 f=fit(transpose(time),transpose(func_cos),'gauss1',options)
% % f=fit(transpose(time_2),transpose(func_cos),'gauss1','Normalize', 'on','Robust','Bisquare')
% 
% 
 FWHM=f.c1*2*sqrt(log(2))*10^9;
 disp(strcat(num2str(FWHM),'ns'))
% 
 plot(f,time,func_cos)

time_end=4*10^-7;

 
func_cos_sym=@(time_syms) cos(pi*Rep_freq*(time_syms-max(time)/2)).^(2*form_shape);
total_area=integral(func_cos_sym,0,time_end);

initial_inten=irr_intensity/total_area;