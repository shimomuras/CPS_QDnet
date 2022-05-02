function QD_type_sequence=QD_type_definition(QD_type_sequence,diff_rate)




%ネットワーク内の量子ドットの組成
for i=1:length(QD_type_sequence)
    dice_num=rand(1);
    if dice_num>diff_rate
        if QD_type_sequence(i)==1
            QD_type_sequence(i)=round(2+rand(1));
        elseif QD_type_sequence(i)==2
            data_dice_num=rand(1);
            if data_dice_num>=0.5
                QD_type_sequence(i)=3;
            else
                QD_type_sequence(i)=1;
            end
        elseif QD_type_sequence(i)==3
            QD_type_sequence(i)=round(2-rand(1));
        end
    end
end


