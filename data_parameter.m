%folder_name;




%minimum quantum yield
Fluorescence_conversion_efficiency=0.4;

%QD diameter
qd_size=6.9;%[nm]
%QD_540:6.1 nm, QD_580:7.6 nm

%fluorescence lifetime [QD540,QD580] ref lifetime_check
fluorescence_lifetime=[8.55 7.85 1000]*10^-9;

%optical speed
c=2.99792458*10^8;

%Plank constant
h=6.62607004*10^-34;

%energy spectrum of QD
QD_energy_spect=h*c./QD_wavelength;
QD_energy_spect(3)=0;
%refractive index
refrac=1.4;

%orientation factor
kai2=2/3;

%excitation frequency
% exc_freq=c/(irr_wavelength*10^-9);

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
mol_abs=zeros(3,1);
mol_abs(1)=Quantum_dots_abs(1)/(mol_concentration_540*light_distance);
mol_abs(2)=Quantum_dots_abs(2)/(mol_concentration_580*light_distance);

%absorption crosscection[cm^-1]
Na=6.022*10^23;
abs_area=1000*mol_abs./log10(exp(1))./Na;


%fluorescence_spectrum
flu540 = xlsread('540_flu_2.xlsx','','','basic');
flu580 = xlsread('580_flu_2.xlsx','','','basic');


%fluorescence_spectrum
fluorescence_efficiency=Fluorescence_spectrum_matrix(flu540,flu580,Fluorescence_conversion_efficiency,mol_abs,QD_wavelength);

%Quantum yield
Qdot_eff=Fluorescence_conversion_efficiency*ones(1,length(fluorescence_lifetime));


