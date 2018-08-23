function[distortionMatrix]= calculateDistortion(gesture_data,current_means,classMatrix,currentNumberOfClasses)

distortionMatrix=zeros(size(current_means,1),1);
for k=1:currentNumberOfClasses  
    [rows,columns] = find(classMatrix == k);
    X=[] ;Y=[] ; Z=[] ;
    for i=1:size(rows)
       X=[X;gesture_data(rows(i),columns(i),1)];
       Y=[Y;gesture_data(rows(i),columns(i),2)];
       Z=[Z;gesture_data(rows(i),columns(i),3)];           
    end
    val=0 ;
    data=[X-current_means(k,1),Y-current_means(k,2),Z-current_means(k,3)];
    for j=1:size(rows)
        val=val+sqrt(data(j,1)*data(j,1)+data(j,2)*data(j,2)+data(j,3)*data(j,3)) ;
    end 
   distortionMatrix(k,1)=val/size(rows,1) ;
end 
        
end   
