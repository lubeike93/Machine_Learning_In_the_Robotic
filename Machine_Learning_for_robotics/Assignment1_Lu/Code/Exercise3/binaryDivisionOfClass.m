function[classMatrix] = binaryDivisionOfClass(classNumber,classMatrix,gesture_data,current_means,currentNumberOfClasses)
   
   [rows,columns] = find(classMatrix == classNumber);
   X=[] ;Y=[] ; Z=[] ;
   for i=1:size(rows)
       X=[X;gesture_data(rows(i),columns(i),1)];
       Y=[Y;gesture_data(rows(i),columns(i),2)];
       Z=[Z;gesture_data(rows(i),columns(i),3)];           
   end
   
   data_of_classNumber=[X,Y,Z];
   
   %Calculate eigen vectors of covariance matrix 
   covMatrix=cov(data_of_classNumber);
   [V,D]= eigs(covMatrix,1);
   p_eig_vector = V(:,1)';
     
   c_means=current_means(classNumber,:); 
   center1 = c_means-p_eig_vector;
   center2= c_means+p_eig_vector;
   
   for i=1:size(rows)
       positionNo=rows(i);
       gestureNo=columns(i);
      
       point= [gesture_data(positionNo,gestureNo,1),gesture_data(positionNo,gestureNo,2),gesture_data(positionNo,gestureNo,3)];
       
       dist1=norm((point-center1),2);
       dist2=norm((point-center2),2);
       
       if(dist1 < dist2)
         classMatrix(positionNo,gestureNo)=currentNumberOfClasses+1 ; 
       end 
   end   
   
   
 
      
end 