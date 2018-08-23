function [ output_args ] = Exercise3_kmeans( gestures_Data,InitialClusterLabels, Clusters_nbr )



current_means=InitialClusterLabels;
previous_means=zeros(size(InitialClusterLabels,1),size(InitialClusterLabels,2));
zero_matrix= zeros(size(InitialClusterLabels,1),size(InitialClusterLabels,2));

if(Clusters_nbr >7 )
    return ;    
end 
    
min_error_allowed=10 ^ -6;
current_total_error=intmax  ;
noOfPositions=size(gestures_Data,1);
noOfgestures=size(gestures_Data,2);
current_distortion=0 ;

class_matrix =zeros(noOfPositions, noOfgestures);
min_distance_matrix= zeros(noOfPositions,noOfgestures); 
count =0 ;



% while(isequal(current_means-previous_means,zero_matrix) == 0)
while (current_total_error > min_error_allowed)
    count=count+1 ;
    for i=1:noOfPositions       
        for j=1:noOfgestures
          val=gestures_Data(i,j,:) ;
          gesture_position=  reshape(val,1,3);
          dmin=intmax ;
          for k=1:Clusters_nbr         
              diff= gesture_position- current_means(k,:) ;
              d_current=norm(diff,2);
              if(d_current < dmin)
                 dmin=d_current ;  
                 class_matrix(i,j)= k ;
                 min_distance_matrix(i,j)=dmin ; %only for debugging
             end         
          end           
        end       
   end
  previous_means=current_means ;
  current_means= updateMeans(class_matrix,Clusters_nbr,gestures_Data);
  
  if(count ~= 1)
    last_distortion=current_distortion ; 
  end 
  
  current_distortion=calculatetotal_distortion(class_matrix,current_means, gestures_Data,Clusters_nbr);      
  
  if(count ~= 1)
     current_total_error= abs(last_distortion-current_distortion) ;
  end
  
end
  display_string = ['Iteration: ',num2str(count),' Diff Distortion :',num2str(current_total_error)];
  disp(display_string);
  drawPlots(class_matrix,Clusters_nbr,gestures_Data,current_means);
  
end
  


 

