function [max_amp,average_tau]=exp2fit_bias(time_fix,fix_data_1)


% fun = @(x,xdata)x(1)*exp(x(2)*xdata)+x(3)*exp(x(4)*xdata);
fun = @(x,xdata)x(1)*exp(x(2)*xdata);
% x0=[10,-5,10,-5];
% lb=[0,-inf,0,-inf];
% ub=[500,0,500,0];
x0=[1 inf];
lb=[0,-inf];
ub=[500,0];
fit_result=lsqcurvefit(fun,x0,time_fix,fix_data_1);
% fit_func=fit_result(1)*exp(fit_result(2)*time_fix)+fit_result(3)*exp(fit_result(4)*time_fix);

fit_func=fit_result(1)*exp(fit_result(2)*time_fix);
plot(time_fix,fit_func./max(fit_func),'LineWidth',2);
hold on
plot(time_fix,fix_data_1,'LineWidth',2);
% tau1=-1/fit_result(2)
% tau2=-1/fit_result(4)

% average_tau=(fit_result(1)*(-1/fit_result(2))^2+fit_result(3)*(-1/fit_result(4))^2)/(fit_result(1)*(-1/fit_result(2))+fit_result(3)*(-1/fit_result(4)));
average_tau=0;
max_amp=max(fit_func);
% fit(time_fix,fix_data_1,'exp1');