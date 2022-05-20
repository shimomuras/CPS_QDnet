function QD_type_sequence=QD_type_definition(QD_type_sequence,change_prob,quantum_type_number)




%ネットワーク内の量子ドットの組成
for i=1:length(QD_type_sequence)
    dice_num=rand(1);
    
    while true
        if dice_num<change_prob
            pre_QD_num=QD_type_sequence(i);
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
        if  quantum_type_number(QD_type_sequence(i))~=0
            break;
        else
            QD_type_sequence(i)=pre_QD_num;
        end
    end
    
end


    for i=1:length(QD_type_sequence)
        if quantum_type_number(QD_type_sequence(i))==0
            while true
                fix_dice=randi(length(quantum_type_number));
            if quantum_type_number(fix_dice)~=0
                break;
            end
            end
            QD_type_sequence(i)=fix_dice;
        end
    end
    