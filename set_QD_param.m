function [rad_speed,abs_matrix,sat_energy_matrix,fluorescence_lifetime_matrix,energy_spectrum_list,N_total_list]=set_QD_param(Q_type_seq,networkSys)
choice_parameter;
data_parameter;


Q_number=length(Q_type_seq);

rad_speed=zeros(1,Q_number);
abs_matrix=zeros(1,Q_number);
total_tau=zeros(1,Q_number);
sat_energy_matrix=zeros(1,Q_number);
fluorescence_lifetime_matrix=zeros(1,Q_number);
transfer_FRET_speed=sum(transpose(networkSys));
energy_spectrum_list=zeros(1,Q_number);


for  i=1:Q_number
    %radiative coefficient
    rad_speed(i)=Qdot_eff(Q_type_seq(i))/fluorescence_lifetime(Q_type_seq(i));
    
    %absorption area
    abs_matrix(i)=abs_area(Q_type_seq(i));
    
    %energy_spectrum of each QD
    energy_spectrum_list(i)=QD_energy_spect(Q_type_seq(i));
    
    
    if strcmp(FRET_implementation,'on')==1
        total_tau(i)=1/(1/fluorescence_lifetime(Q_type_seq(i))+transfer_FRET_speed(i));
    else
        total_tau(i)=fluorescence_lifetime(Q_type_seq(i));
    end
    
    %飽和エネルギーの記述
    sat_energy_matrix(i)=QD_energy_spect(Q_type_seq(i))/(total_tau(i));
    if isnan(sat_energy_matrix(i))==1
        sat_energy_matrix(i)=Inf;
    end

    fluorescence_lifetime_matrix(i)=fluorescence_lifetime(Q_type_seq(i));
end
N_total_list=sat_energy_matrix./energy_spectrum_list;

for check_term=1:length(N_total_list)
    if isnan(N_total_list(check_term))==1
        N_total_list(check_term)=Inf;
    end
end