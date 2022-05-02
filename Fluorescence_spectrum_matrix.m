function flu=Fluorescence_spectrum_matrix(flu540,flu580,min_eff,abs_area,QD_wavelength)

% clear all



abs_area=abs_area./max(abs_area);

peak_540=QD_wavelength(1);
peak_580=QD_wavelength(2);

flu_value_540=flu540(:,2)./sum(flu540(:,2));
flu_value_580=flu580(:,2)./sum(flu580(:,2));

flu_val540=number_conversion_flu(peak_540);
flu_val580=number_conversion_flu(peak_580);

                 f = [flu_value_540(flu_val540) flu_value_580(flu_val540);
                      flu_value_540(flu_val580) flu_value_580(flu_val580)];
                  
% f_abs_consider=zeros(length(f));
% for i=1:length(f)
%     f_abs_consider(:,i)=f(:,i)./abs_area(i);
% end
%                   
% %各量子ドットのエネルギー総和
% Q_efficiency_comp=sum(f);
% 
% %還元率
% concversion_eff=Q_efficiency_comp./abs_area;

%各量子どっと，蛍光変換効率
%一番低い量子効率の物を最小の変換効率として定義（40%，今回は540のもの)
flu=min_eff.*f;


