function networkSys=Generate_Q_net(Generated_qd_distance,Q_type_seq,cell_scale,qdot_lifetime,...
                                                         quantum_eff,...
                                                         refrac,kai2,Na)




%各量子ドットのFRET効率（ドナーとアクセプタの重なり積分，ae2.2 matlab参照）
%縦→横へのエネルギー遷移の時の効率J(i,j): iの蛍光からjの吸光の重なり
 J =[1.7e+15    9.0e+15 0;
     2.9e+16    2.0e+16 0;
     0          0       0];




% 
% Generated_qd_distance=gpuArray(Generated_qd_distance);
% networkSys=gpuArray(zeros(cell_num^2));

% networkSys=zeros(cell_num^2);
integral_spect=zeros(cell_scale);
quantum_eff_matrix=zeros(cell_scale);
qdot_lifetime_matrix=zeros(cell_scale);




for k=1:cell_scale
    for l=1:cell_scale
        if k~=l
        integral_spect(k,l)=J(Q_type_seq(k),Q_type_seq(l));
%         qdot_lifetime_matrix(l,:)=qdot_lifetime(Q_type_seq(l));
        end
%         quantum_eff_matrix(k,:)=quantum_eff(Q_type_seq(k));
    end
        qdot_lifetime_matrix(:,k)=qdot_lifetime(Q_type_seq(k));
    quantum_eff_matrix(:,k)=quantum_eff(Q_type_seq(k));
end

% for k=1:cell_num^2
% %     disp(k)
%     qdot_lifetime_matrix(:,k)=qdot_lifetime(Q_type_seq(k));
%     quantum_eff_matrix(:,k)=quantum_eff(Q_type_seq(k));
% end




R6_0=9.*quantum_eff_matrix*log(10)/(128*pi^5*refrac^4*Na)*kai2.*integral_spect*10^17;%[10^3*nm^4*cm^2=10^17nm^6]
% R_0=nthroot(R6_0,6);
networkSys=(1./qdot_lifetime_matrix).*(R6_0./Generated_qd_distance.^6);

networkSys(isnan(networkSys))=0;


