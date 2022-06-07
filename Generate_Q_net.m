function [networkSys,Generated_qd_distance,position_value]=Generate_Q_net(it_num,Q_type_seq,cell_num,qdot_lifetime,...
                                                         quantum_eff,qd_size,quantum_type_number,...
                                                         folder_name,refrac,kai2,Na)




%各量子ドットのFRET効率（ドナーとアクセプタの重なり積分，ae2.2 matlab参照）
%縦→横へのエネルギー遷移の時の効率J(i,j): iの蛍光からjの吸光の重なり
 J =[1.7e+15    9.0e+15 0;
     2.9e+16    2.0e+16 0;
     0          0       0];




[Generated_qd_distance, position_value]=distance_matrix_fix(cell_num,qd_size,folder_name,Q_type_seq,it_num);
% 
% Generated_qd_distance=gpuArray(Generated_qd_distance);
% networkSys=gpuArray(zeros(cell_num^2));

% networkSys=zeros(cell_num^2);
integral_spect=zeros(cell_num^2);
quantum_eff_matrix=zeros(cell_num^2);
qdot_lifetime_matrix=zeros(cell_num^2);


networkSys=zeros(cell_num^2);


for k=1:cell_num^2
    disp(k)
    for l=1:cell_num^2
        if k~=l
        integral_spect(k,l)=J(Q_type_seq(k),Q_type_seq(l));
%         qdot_lifetime_matrix(l,:)=qdot_lifetime(Q_type_seq(l));
        end
%         quantum_eff_matrix(k,:)=quantum_eff(Q_type_seq(k));
    end
end

for k=1:cell_num^2
    disp(k)
    qdot_lifetime_matrix(k,:)=qdot_lifetime(Q_type_seq(k));
    quantum_eff_matrix(:,k)=quantum_eff(Q_type_seq(k));
end
        
R6_0=9.*quantum_eff_matrix*log(10)/(128*pi^5*refrac^4*Na)*kai2.*integral_spect*10^17;%[10^3*nm^4*cm^2=10^17nm^6]
R_0=nthroot(R6_0,6);
networkSys_new=(1./qdot_lifetime_matrix).*(R6_0./Generated_qd_distance.^6);

networkSys_new(isnan(networkSys_new))=0;


for i=1:cell_num^2
    for j=i:cell_num^2
        if i==j
            networkSys(i,j)=0;
        else
            for k=1:length(quantum_type_number)
                for l=1:length(quantum_type_number)
                    if Q_type_seq(i)==k&&Q_type_seq(j)==l
                        networkSys(i,j)=FRET_distribution(Generated_qd_distance(i,j),J(k,l),quantum_eff(k),qdot_lifetime(l),refrac,kai2,Na);
                        if isnan(networkSys(i,j))==1
                            networkSys(i,j)=0;
                        end
                        networkSys(j,i)=FRET_distribution(Generated_qd_distance(j,i),J(l,k),quantum_eff(l),qdot_lifetime(k),refrac,kai2,Na);
                        if isnan(networkSys(j,i))==1
                            networkSys(j,i)=0;
                        end
                    end
                end
            end
        end
    end
end



networkSys
 