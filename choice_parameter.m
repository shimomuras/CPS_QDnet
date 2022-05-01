%time span at simulation [s]
time_span=1*10^-11;
%total time[s]

%1 time step between endoded input of XOR [s]
time_step=1*10^-9;

total_data_num=1000;

time_scale=time_step*total_data_num;


ns=10^9;
show_time_step=strcat(num2str(time_step*ns),'ns');

%aviable detection time [s]
detect_time_step=time_step;

%total_time_step
time=0:time_span:time_scale;

%fliuorescence wavelength of each QD
QD_wavelength=[550,600]*10^-9;

% QD type in QD network (1:exit?º?0:none; (1):QD490,(2):QD525,(3):QD575,(4):QD630,(5):QD665)
quantum_type_number=[1,1];

%number of QD in network [number]
quantum_number=30;

%type rate of donor QD
QD_type_rate=0.8;

%irradiation wavelength
irr_wavelength=400*10^-9;

%netowork size [nm^2]
square_distance=100;

%number of node (number of QD network) [number]
Q_number=20;


%Irradiation type
choice_num=4;
%test %1:sin wave, 2:constant wave, 3:periodic wave (constant), 4:xor wave,
%5:logistic wave, %6:santafe wave, %7:nand wave


irradiation_type='pulse';
%pulse: pulse sequences, %square: square wave

%delay_point of XOR
delay_point=3;

%encoding method
encoding_num=0;

%encoding method for encoding_num:6.5
delay_irr_num=0;

%encoding method for encoding_num:11
devide_number=5;


%fluorescence detection method(1: fluorescence from each QD type 2:fluorescence spectrum from QD network?º?
spectrum_method=1;


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

 
Initial_Input=2.8*10^6;

Intensity_amp=log10(Initial_Input/sat_intensity);%[W/cm^2]
%Intensity/Rep_freq/time_integral;

 

%define starting point of training to discard initial energy preservation
start_learning_rate=0.5;
start_learning=int64(start_learning_rate*length(time)/(detect_time_step/time_span));

%Weight_in range
max_pixel_value=32;

%type of weight_in:rand:random weight, arrange: increasing weight in order, none: same weight  
weight_in_type='none';
%
if strcmp(weight_in_type,'arrange')==1
    In_weight=1:(max_pixel_value-1)/(Q_number-1):max_pixel_value;
    In_weight=round(In_weight);
elseif strcmp(weight_in_type,'rand')==1
    % In_weight=1/round(max_pixel_value/Q_number):1/round(max_pixel_value/Q_number):1/round(max_pixel_value/Q_number)*Q_number;
    In_weight=randi(max_pixel_value,Q_number,1);
else 
    In_weight=ones(Q_number,1);
end

%split_rate between train and validation
split_rate=0.25;
%train75/test25

%detected wavelength?º?1=540, 2=580nm, 3=All)
wavelength_choice=2;

%activation function
%0=none,1=sigmoid,2=relu,3=binary,4=tanh
node_func=0;

%Learning method
learning_method='Ridge';
%GD: Gradient descent
%Ridge:Ridge regression

evaluation_method='acc';
%acc or rmse;


%Ridge parameter
min_ridge_parameter=1;
max_ridge_parameter=50;

%Learning rate of GD
learning_rate=1*10^13/Q_number;


%implementation of FRET
FRET_implementation='on';


%showing data number of predict and of label
viewing_number=15;

%scaling_rate;
scaling_rate=[0,1];

%ittaration number to evaluate acc.
itar_number=10;

%irraration number to evaluate acc.
max_prediction=1;


scattering_method='gauss';
scattering_param=square_distance/2;
