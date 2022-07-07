function f=convert_to_ref_time(fluorescencce_result,time_span,ref_time_step,typeofQD)


convert_num=round(ref_time_step/time_span);

convert_time_length=round(length(fluorescencce_result)/convert_num);

f=zeros(convert_time_length,typeofQD+1);

for i=1:convert_time_length
    f(i,:)=sum(fluorescencce_result((i-1)*convert_num+2:i*convert_num+1,:));
end