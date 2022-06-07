%time span at simulation [s]
time_span=1*10^-12;
%total time[s]


time_step=1*10^-9;

total_data_num=2;

time_scale=time_step*total_data_num;


ns=10^9;
show_time_step=strcat(num2str(time_step*ns),'ns');

%aviable detection time [s]
detect_time_step=time_step;

%total_time_step
time=0:time_span:time_scale;

%fliuorescence wavelength of each QD
QD_wavelength=[550,600,0]*10^-9;

% QD type in QD network (1:exit?º?0:none; (1):QD490,(2):QD525,(3):QD575,(4):QD630,(5):QD665)
quantum_type_number=[1,1,1];

%number of QD in network [number]
cell_num=10;



%irradiation wavelength
% irr_wavelength=400*10^-9;

%netowork size [nm^2]
square_distance=100;

%number of node (number of QD network) [number]
Q_number=1;


%Irradiation type
choice_num=0;
%test %1:sin wave, 2:constant wave, 3:periodic wave (constant), 4:xor wave,
%5:logistic wave, %6:santafe wave, %7:nand wave


irradiation_type='pulse';
%pulse: pulse sequences, %square: square wave



%fluorescence detection method(1: fluorescence from each QD type 2:fluorescence spectrum from QD network?º?
spectrum_method=2;


%spatial irradiation method?º?1:gauss?ºåelse:uniform?º?
gauss_fix=0;

%spatial FWHM of [nm]
FWHM=50;

if gauss_fix==0
    FWHM=0;
    norm_dist_fix_param=0;
end
       
%Input intensity

Rep_freq=1000;
%Initial_Input=Intensity/Rep_freq;
%time_integral=2.5324*10^-23;%„Éë„É´„ÇπÁ©çÂ?ÂÄ§

sat_intensity=2.8*10^6;

 
Initial_Input=2.8*10^3;

Intensity_amp=log10(Initial_Input/sat_intensity);%[W/cm^2]
%Intensity/Rep_freq/time_integral;


%type of weight_in:rand:random weight, arrange: increasing weight in order, none: same weight  
weight_in_type='none';



%detected wavelength?º?1=540, 2=580nm, 3=All)
wavelength_choice=2;



evaluation_method='acc';
%acc or rmse;



%implementation of FRET
FRET_implementation='on';




scattering_method='gauss';
scattering_param=square_distance/2;
