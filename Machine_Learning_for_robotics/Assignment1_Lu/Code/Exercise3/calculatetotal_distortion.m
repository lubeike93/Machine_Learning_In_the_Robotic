function [total_distortion]= calculatetotal_distortion(class_matrix,current_means,gestures_Data,Clusters_nbr)

% this function calculate the total of the distortion
    total_distortion=0 ;
    for k=1:Clusters_nbr
       [r,c,p]= find(class_matrix == k); 
       X=[] ;Y=[] ;Z=[] ;
       
       for k=1:size(r,1)
          X=[X; gestures_Data(r(k),c(k),1)];
          Y=[Y; gestures_Data(r(k),c(k),2)];
          Z=[Z;gestures_Data(r(k),c(k),3)];
       end
       %m=[mean(X),mean(Y),mean(Z)];
       data=[X,Y,Z];
       diff=[X-mean(X), Y-mean(Y), Z-mean(Z)];
      
       for i=1:size(data,1)
           total_distortion=total_distortion+norm(diff(i,:)) ;
       end 
    
    end          
end 
