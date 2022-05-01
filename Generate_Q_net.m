function [Q_type_seq,networkSys,...
    Generated_qd_distance,position_value]=Generate_Q_net(quantum_type_number,quantum_number,qdot_lifetime,...
                                                         quantum_eff,square_distance,qd_size,...
                                                         folder_name,QD_net_number,spectrum_method,...
                                                         refrac,kai2,Na,sccatering_method,scattering_param,...
                                                         QD_type_rate)
% 
% clear all
% close all
% quantum_type_number=5;
% quantum_number=3;
% square_distance=20;
% qd_size=6;
% data_size=1;
% 
% data_parameter
% qdot_lifetime=fluorescence_lifetime;
% quantum_eff=Qdot_eff;

%�e�ʎq�h�b�g��FRET�����i�h�i�[�ƃA�N�Z�v�^�̏d�Ȃ�ϕ��Cae2.2 matlab�Q�Ɓj
%�c�����ւ̃G�l���M�[�J�ڂ̎��̌���J(i,j): i�̌u������j�̋z���̏d�Ȃ�
 J =[1.7e+15    9.0e+15;
     2.9e+16    2.0e+16];

networkSys=zeros(quantum_number);
Q_type_seq=zeros(quantum_number,1);


%�l�b�g���[�N���̗ʎq�h�b�g�̑g��
for i=1:quantum_number
    while true
        %�ǂ�QD���g���邩�̒��I�D�ݒ�Ƃ��Ă����ނ�QD���Ȃ����while�𔲂��o���Ȃ�
        dice_num=rand(1);
        if dice_num<QD_type_rate
            donor_num=1;
        else
            donor_num=2;
        end
        if quantum_type_number(donor_num)==1
            break;
        else
            continue;
        end
    end
    Q_type_seq(i)=donor_num;
    if i==quantum_number&&spectrum_method==1&&sum(quantum_type_number)~=1
        if sum(Q_type_seq)==quantum_number
            Q_type_seq(quantum_number)=2;
        elseif sum(Q_type_seq)==quantum_number*2
            Q_type_seq(quantum_number)=1;
        end
    end
            
end



[Generated_qd_distance, position_value]=distance_matrix_0(quantum_number,square_distance,qd_size,Q_type_seq,folder_name,QD_net_number,sccatering_method,scattering_param);

for i=1:quantum_number
    for j=i:quantum_number
        if i==j
            networkSys(i,j)=0;
        else
            for k=1:length(quantum_type_number)
                for l=1:length(quantum_type_number)
                    if Q_type_seq(i)==k&&Q_type_seq(j)==l
                        networkSys(i,j)=FRET_distribution(Generated_qd_distance(i,j),J(k,l),quantum_eff(k),qdot_lifetime(l),refrac,kai2,Na);
                        networkSys(j,i)=FRET_distribution(Generated_qd_distance(j,i),J(l,k),quantum_eff(l),qdot_lifetime(k),refrac,kai2,Na);
                    end
                end
            end
        end
    end
end



%networkSys
 