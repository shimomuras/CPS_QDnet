%folder_name;
load('changed_param.mat');
switch choice_num
    case 0
        folder_name=strcat('time_step_',show_time_step,'_FRET_',FRET_implementation,'_type_',irradiation_type,'_node_',num2str(Q_number));
    case 4
        if strcmp(weight_in_type,'none')==1
%             folder_name=strcat('nox_time_step_',show_time_step,'_FRET_',FRET_implementation,'_dalay_',num2str(delay_point),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp),'_',weight_in_type,'_encode_',num2str(encoding_num),'_devide_num_',num2str(devide_number),'_',irradiation_type,'node',num2str(quantum_number));
<<<<<<< HEAD
              folder_name=strcat('nox_time_step_',show_time_step,'_total_num_',num2str(total_data_num),'_contQD',num2str(quantum_number),'_irr_wavelen_',num2str(round(irr_wavelength*10^9)),'_sq_size_',num2str(square_distance),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp),'_rate_',num2str(QD_type_rate));
=======
              folder_name=strcat('nox_time_step_',show_time_step,'_total_num_',num2str(total_data_num),'_contQD',num2str(quantum_number),'_irr_wavelen_',num2str(round(irr_wavelength*10^9)),'_sq_size_',num2str(square_distance),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp));
>>>>>>> 722656639c4031669bcd6022679c2b7cb7367c21
        else
            folder_name=strcat('nox_time_step_',show_time_step,'_FRET_',FRET_implementation,'_dalay_',num2str(delay_point),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp),'_',weight_in_type,num2str(max_pixel_value),'_encode_',num2str(encoding_num),'_devide_num_',num2str(devide_number));
        end
    case 7
        if strcmp(weight_in_type,'none')==1
            folder_name=strcat('nand_time_step_',show_time_step,'_FRET_',FRET_implementation,'_dalay_',num2str(delay_point),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp),'_',weight_in_type,'_encode_',num2str(encoding_num),'_devide_num_',num2str(devide_number));
        else
            folder_name=strcat('nand_time_step_',show_time_step,'_FRET_',FRET_implementation,'_dalay_',num2str(delay_point),'_node_',num2str(Q_number),'_input_',num2str(Intensity_amp),'_',weight_in_type,num2str(max_pixel_value),'_encode_',num2str(encoding_num),'_devide_num_',num2str(devide_number));
        end
        
    case 5
        folder_name=strcat('time_step_',show_time_step,'_encode_',num2str(encoding_num),'_FRET_',FRET_implementation,'_enon_type_',irradiation_type);
    case 6
        folder_name=strcat('santafe_time_step_',show_time_step,'_node_',num2str(Q_number),'_FRET_',FRET_implementation,'_type_',irradiation_type,'_amp_',num2str(Intensity_amp));
        
    otherwise
        folder_name=strcat('time_step_',show_time_step,'_encode_',num2str(encoding_num),'_FRET_',FRET_implementation,'_type_',irradiation_type,'_data_choice_',num2str(choice_num));
end


%minimum quantum yield
Fluorescence_conversion_efficiency=0.4;

%QD diameter
qd_size=6.9;%[nm]
%QD_540:6.1 nm, QD_580:7.6 nm

%fluorescence lifetime [QD540,QD580] ref lifetime_check
fluorescence_lifetime=[8.55 7.85]*10^-9;

%optical speed
c=2.99792458*10^8;

%Plank constant
h=6.62607004*10^-34;

%energy spectrum of QD
QD_energy_spect=h*c./QD_wavelength;

%refractive index
refrac=1.0;

%orientation factor
kai2=2/3;

%excitation frequency
exc_freq=c/(irr_wavelength*10^-9);

mol_concentration_540=4.6*10^-7;
mol_concentration_580=4.6*10^-7;


%light distance of absorption spectroscopy
light_distance=1.0;%[cm]

%absorption coefficient
Abs540 = xlsread('540.xlsx','','','basic');
Abs580 = xlsread('580.xlsx','','','basic');

%absorption spectrum matrix;
Quantum_dots_abs=Absorb_spectrum_matrix(irr_wavelength,Abs540,Abs580);

%molar absorption spectrum matrix;
mol_abs=zeros(2,1);
mol_abs(1)=Quantum_dots_abs(1)/(mol_concentration_540*light_distance);
mol_abs(2)=Quantum_dots_abs(2)/(mol_concentration_580*light_distance);

%absorption crosscection[cm^-1]
Na=6.022*10^23;
abs_area=mol_abs./log10(exp(1))./Na;


%fluorescence_spectrum
flu540 = xlsread('540_flu_2.xlsx','','','basic');
flu580 = xlsread('580_flu_2.xlsx','','','basic');


%fluorescence_spectrum
fluorescence_efficiency=Fluorescence_spectrum_matrix(flu540,flu580,Fluorescence_conversion_efficiency,mol_abs,QD_wavelength);

%Quantum yield
Qdot_eff=Fluorescence_conversion_efficiency*ones(1,length(fluorescence_lifetime));


