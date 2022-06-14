function show_QDnet(OS_name,position_value,qd_size,cell_num,Q_type_seq,count)

%mac
switch OS_name
case 'mac'
    calib_scale=72/96;
case 'windows'
     calib_scale=1;
end

clf
square_distance=qd_size*(cell_num+1);
fig=gcf;
fig.Units='points';
fig.InnerPosition=[100 100 400 400];
sz=(qd_size/2*450/square_distance*calib_scale)^2*pi;


for i=1:length(Q_type_seq)
    if Q_type_seq(i)==1
        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','b','MarkerEdgeColor','b')
    elseif Q_type_seq(i)==2
        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','g','MarkerEdgeColor','g')
    elseif Q_type_seq(i)==3
        scatter(position_value(i,1),position_value(i,2),sz,'MarkerFaceColor','None','MarkerEdgeColor','None')
    end
    if i~=length(Q_type_seq)
        hold on
    end
end
% 
xlabel('Posiiton [nm]')
ylabel('Posiiton [nm]')

xlim([0,square_distance])
ylim([0,square_distance])
title(strcat('Iteration: ',num2str(count)))

% disp('dekita')
% close(gcf)