function [] = Exercise3_nubs( gesture_data, Clusters_number )


current_means=zeros(Clusters_number,3);
if(Clusters_number >7 )
    return ;    
end 

%Mean of first cluster, classMatrix has value 1 for all points

current_means(1,:)=[mean2(gesture_data(:,:,1)), mean2(gesture_data(:,:,2)), mean2(gesture_data(:,:,3))];
classMatrix=ones(size(gesture_data,1),size(gesture_data,2));
currentNumberOfClasses= 1 ;

distortionMatrix=calculateDistortion(gesture_data,current_means,classMatrix,currentNumberOfClasses);


for i=1:Clusters_number-1
   [r,c]= find (distortionMatrix == max(distortionMatrix));
   class_highest_distortion=r;
   [classMatrix]=  binaryDivisionOfClass(class_highest_distortion,classMatrix,gesture_data,current_means,currentNumberOfClasses);
   currentNumberOfClasses=currentNumberOfClasses+1 ;
   %Calculate new means
   current_means= updateMeans(classMatrix,currentNumberOfClasses,gesture_data) ;
   
   distortionMatrix=calculateDistortion(gesture_data,current_means,classMatrix,currentNumberOfClasses);
   %drawPlots(classMatrix,currentNumberOfClasses,gesture_data);
end

drawPlots(classMatrix,currentNumberOfClasses,gesture_data);


end 




    



 


