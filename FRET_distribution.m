function FRET_speed=FRET_distribution(distance,integral_spect,quantum_eff,lifetime,refrac,kai2,Na)
% close all
% clear all
% quantum_type_number=5;
% quantum_number=3;
% square_distance=20;
% qd_size=6;
% data_size=1;
% data_parameter
% quantum_eff=Qdot_eff;
% distance=6;%[nm]
% integral_spect=4.487*10^15;%[M^-1*cm^-1*nm^4]
% quantum_eff=0.4;%[a.u]
% lifetime=20*10^-9;%[s]
% 
% 

% choice_parameter;
% data_parameter;

%  Na=6.022*10^23;%アボカドロ数[mol^-1]
%  n=1.44;%屈折率．今回は空気中を想定
%  kai2=2/3;%等方的に配向していると過程．平均なのでアリかと

% 
% J =[ 4.487    6.106    4.672    7.464    4.993;
%      4.010    5.405    4.375    7.724    5.122;
%      4.858    5.127    5.012    8.293    5.530;
%      6.134    6.196    4.007    10.16    6.277;
%      6.836    6.925    4.749    9.098    6.516;];
% 
% J=J*10^15;%[M^-1*cm^-1*nm^4]

% FRET_distance=zeros(length(J));
% 
% 
% for i=1:length(quantum_eff)
%     for j=1:length(quantum_eff)
%     FRET_distance(i,j)=9*quantum_eff(i)*log(10)/(128*pi^5*n^4*N_a)*kai2*J(i,j)*10^17;
%     FRET_distance(i,j)=nthroot(FRET_distance(i,j),6);
%     end
% end
%フェルスター距離
% FRET_distance=[6.78,7.14,6.83,7.38,6.90;
%                5.73,6.02,5.81,6.39,5.97;
%                7.23,7.29,7.26,7.90,7.38;
%                4.95,4.96,4.61,5.39,4.97;
%                4.21,4.22,3.96,4.420,4.18];


R6_0=9*quantum_eff*log(10)/(128*pi^5*refrac^4*Na)*kai2*integral_spect*10^17;%[10^3*nm^4*cm^2=10^17nm^6]
R_0=nthroot(R6_0,6);
FRET_speed=(1/lifetime)*(R6_0/distance^6);

%FRET_speed_2=9000*log(10)/(128*pi^5*n^4*N_a)*(kai2*quantum_eff^2/lifetime)/distance^6*integral_spect;

%FRET_speed=(1/(1+distance^6/R6_0)/lifetime);
%y=(quantum_eff*integral_spect*R_0)/(lifetime*distance^6);
%y=(integral_spect*quantum_eff)*(R_0/distance)/lifetime;
%量子効率は本文で記述