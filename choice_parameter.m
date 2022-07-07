%time span at simulation [s]
time_span=5.959*10^-16;

ref_time_step=5.959*10^-12;
ref_total_data_num=300;
total_data_num=ref_total_data_num*ref_time_step/time_span;
time_scale=time_span*total_data_num;

time_step_div=1000;

Initial_Input=5.7*10^15;%[W/cm^2]

%total_time_step
time=0:time_span:time_scale;

%fliuorescence wavelength of each QD
QD_wavelength=[550,600,0]*10^-9;

% QD type in QD network (1:exit?¼?0:none; (1):QD490,(2):QD525,(3):QD575,(4):QD630,(5):QD665)
quantum_type_number=[1,1,1];

%number of QD in network [number]
cell_num=2;

dimension=3;

cell_scale=cell_num.^dimension;

%parameter of SA
iter_num=10;
temp_num=10; 
temp_dec_rate=0.9;
ini_temp=5*10^-3;
ini_list=0:1:temp_num-1;
temp_list=ini_temp*temp_dec_rate.^ini_list;

change_prob_num=10;


choice_processor='CPU';


%Irradiation type
choice_num=0;
%test %1:sin wave, 2:constant wave, 3:periodic wave (constant), 4:xor wave,
%5:logistic wave, %6:santafe wave, %7:nand wave


irradiation_type='pulse';
%pulse: pulse sequences, %square: square wave



%fluorescence detection method(1: fluorescence from each QD type 2:fluorescence spectrum from QD network?¼?
spectrum_method=2;


%spatial irradiation method?¼?1:gauss?¼Œelse:uniform?¼?
gauss_fix=0;

%spatial FWHM of [nm]
FWHM=50;

if gauss_fix==0
    FWHM=0;
    norm_dist_fix_param=0;
end
       
%Input intensity

% sat_intensity=2.8*10^6;
 
% Initial_Input=5.7;




%type of weight_in:rand:random weight, arrange: increasing weight in order, none: same weight  
% weight_in_type='none';



%detected wavelength?¼?1=540, 2=580nm, 3=All)
wavelength_choice=2;



%implementation of FRET
FRET_implementation='on';

