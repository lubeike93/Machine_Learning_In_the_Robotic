function [New_Means]= updateMeans(class_matrix,Clusters_nbr,gestures_Data)      
    for k=1:Clusters_nbr
       [rows,columns]= find(class_matrix == k); %positons with ith cluster ;
       if(size(rows,1) == 0)
           continue ;
       end 
       X=[] ; Y=[] ;Z=[] ;
       for i=1:size(rows,1)
         X= [X;gestures_Data(rows(i),columns(i),1)];
         Y=[Y; gestures_Data(rows(i),columns(i),2)];
         Z=[Z;gestures_Data(rows(i),columns(i),3)];  
       end 
         New_Means(k,1)=mean(X) ;
         New_Means(k,2)=mean(Y);
         New_Means(k,3)=mean(Z);
      
    end

end  
