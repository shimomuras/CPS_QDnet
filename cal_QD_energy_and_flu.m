function [fluorescence_result,previous_Energy_list]=cal_QD_energy_and_flu(plot_num,Irr_fix,Q_type_seq,networkSys)
choice_parameter;
load('changed_param.mat');
data_parameter;
%%
% %initialize
QD_type_number=length(quantum_type_number);

excited_QD_number=zeros(1,quantum_number);
fluorescence_qd_sum_wavelength=zeros(1,QD_type_number);
fluorescence_total=zeros(length(quantum_type_number),1);
fluorescence_result=zeros(plot_num,QD_type_number+1);
excited_QD_number_list=zeros(plot_num,quantum_number);
%%

%radiation speed, of absorbtion cross ssection, of satuation
%energy, of quantum efficiency and fluorescence lifetime of QDs.
[rad_speed,abs_matrix,sat_energy_matrix,fluorescence_lifetime_matrix,energy_spectrum_list,N_total_list]=set_QD_param(Q_type_seq,networkSys);

%%
for i=1:plot_num
    Input=Irr_fix(i,:);
    first_term=-1./fluorescence_lifetime_matrix.*excited_QD_number;
    second_term=abs_matrix.*Input./energy_spectrum_list.*(N_total_list-excited_QD_number);
    
    if strcmp(FRET_implementation,'on')==1
        third_term=-sum(networkSys).*excited_QD_number;
        %forth_term=excited_QD_number./N_total_list*transpose(networkSys).*(N_total_list-excited_QD_number);
        forth_term=excited_QD_number*transpose(networkSys).*(N_total_list-excited_QD_number)./N_total_list;
       % abs_matrix
        %forth_term=excited_QD_number*transpose(networkSys);
        %forth_term=0;
        
    elseif strcmp(FRET_implementation,'off')==1
        third_term=0;
        forth_term=0;
    else
        error('Please define FRET_implementation (on or off)')
    end
    
    check_cal_value=time_span.*(first_term+second_term+third_term+forth_term);
    
    %check calculation error of QDs' energy
    if min(check_cal_value./N_total_list)<-1||max(check_cal_value./N_total_list)>1
        error('cal error: You should change time_span or QD_number')
    end
    
    
    fluorescence=time_span*rad_speed.*excited_QD_number.*energy_spectrum_list;
    
    result_QD_number=excited_QD_number+time_span.*first_term+check_cal_value;
%     if result_QD_number>N_total_list*0.9
%         disp('beep')
%     end
        

%     if strcmp(saturation,'on')==1
%             for k=1:length(sat_energy_matrix)
%                 if Equ_energy(k) > sat_energy_matrix(k)
%                     Equ_energy(k)=sat_energy_matrix(k);
%                 end
%             end
%     end
    
    excited_QD_number=result_QD_number;
    excited_QD_number_list(i,:)=excited_QD_number;
    for s=1:quantum_number
        for t=1:length(quantum_type_number)
            if Q_type_seq(s)==t
                fluorescence_qd_sum_wavelength(t)=fluorescence_qd_sum_wavelength(t)+fluorescence(s);
            end
        end
        %a
    end
    
    
    if spectrum_method==1
        %ここで種類別の量子ドット群のエネルギーから蛍光スペクトルを算出
         %ここで種類別の量子ドット群のエネルギーから蛍光スペクトルを算出
        fluorescene_540=fluorescence_efficiency(1,1)./Qdot_eff(1)*fluorescence_qd_sum_wavelength(1);
        fluorescene_580=fluorescence_efficiency(2,2)./Qdot_eff(2)*fluorescence_qd_sum_wavelength(2);
        
        fluorescence_total(1)=fluorescene_540;
        fluorescence_total(2)=fluorescene_580;
        
        
    elseif spectrum_method==2
        %量子ドット群のエネルギーから蛍光スペクトルを算出(各量子ドットの蛍光混在）
        fluorescene_540=fluorescence_efficiency(:,1)./Qdot_eff(1)*fluorescence_qd_sum_wavelength(1);
        fluorescene_580=fluorescence_efficiency(:,2)./Qdot_eff(2)*fluorescence_qd_sum_wavelength(2);
        
        %
        for j=1:QD_type_number
            fluorescence_total(j)=fluorescene_540(j)+fluorescene_580(j);
        end
    else
        error('error spectrum is not define')
    end
    
        
    fluorescence_result(i,1:QD_type_number)=fluorescence_total;
    fluorescence_qd_sum_wavelength=zeros(1,QD_type_number);
end

fluorescence_all=fluorescence_result(:,1)+fluorescence_result(:,2);
fluorescence_result(:,QD_type_number+1)=fluorescence_all;
previous_Energy_list=excited_QD_number_list(end-int16(time_step/(2*time_span)),:);
