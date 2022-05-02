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
% %�e�ʎq�h�b�g�̃G�l���M�[���a
% Q_efficiency_comp=sum(f);
% 
% %�Ҍ���
% concversion_eff=Q_efficiency_comp./abs_area;

%�e�ʎq�ǂ��ƁC�u���ϊ�����
%��ԒႢ�ʎq�����̕����ŏ��̕ϊ������Ƃ��Ē�`�i40%�C�����540�̂���)
flu=min_eff.*f;


