function [ref_signal,test_signal,irr_wavelength_list]=load_decay_data(data_no,test_wavelength,total_data_num)



start_irr_position=1500;
end_irr_position=3000;

header_data_name='lifetime_data/network_10bai_25%';
footer_data_name='.xlsx';




switch test_wavelength
    case 400
        irr_wavelength_list=[425 450]*10^-9;
        ref_sig_1=xlsread(strcat(header_data_name,'_w425_',num2str(data_no),footer_data_name));
        ref_sig_2=xlsread(strcat(header_data_name,'_w450_',num2str(data_no),footer_data_name));
        tes_sig=xlsread(strcat(header_data_name,'_w400_',num2str(data_no),footer_data_name));

    case 425
        irr_wavelength_list=[400 450]*10^-9;
        ref_sig_1=xlsread(strcat(header_data_name,'_w400_',num2str(data_no),footer_data_name));
        ref_sig_2=xlsread(strcat(header_data_name,'_w450_',num2str(data_no),footer_data_name));
        tes_sig=xlsread(strcat(header_data_name,'_w425_',num2str(data_no),footer_data_name));
    case 450
        irr_wavelength_list=[400 425]*10^-9;
        ref_sig_1=xlsread(strcat(header_data_name,'_w400_',num2str(data_no),footer_data_name));
        ref_sig_2=xlsread(strcat(header_data_name,'_w425_',num2str(data_no),footer_data_name));
        tes_sig=xlsread(strcat(header_data_name,'_w450_',num2str(data_no),footer_data_name));
end



ref_signal_1=smooth(ref_sig_1(start_irr_position:end_irr_position,2));
ref_signal_2=smooth(ref_sig_2(start_irr_position:end_irr_position,2));
test_signal=smooth(tes_sig(start_irr_position:end_irr_position,2));

[~,posi_1]=max(ref_signal_1);
[~,posi_2]=max(ref_signal_2);
[~,posi_3]=max(test_signal);

ref_signal_1=ref_signal_1(posi_1-1:posi_1+total_data_num-1);
ref_signal_2=ref_signal_2(posi_2-1:posi_2+total_data_num-1);
test_signal=test_signal(posi_3-1:posi_3+total_data_num-1);
%

ref_signal_1=ref_signal_1/max(ref_signal_1);
ref_signal_2=ref_signal_2/max(ref_signal_2);
test_signal=test_signal/max(test_signal);

ref_signal=horzcat(ref_signal_1,ref_signal_2);