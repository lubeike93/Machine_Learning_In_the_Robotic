function[]= drawPlots(class_matrix,Clusters_nbr,data,m)
   figure ;
   % hold on ;   
   colors=['b','k', 'r', 'g', 'm' 'y','c'] ;
            
 for i=1:Clusters_nbr
            [r,c]= find(class_matrix ==i); 
             X=[] ; Y=[] ; Z=[] ;
            for k=1:size(r,1)
                X=[X;data(r(k),c(k),1)];
                Y=[Y;data(r(k),c(k),2)];
                Z=[Z;data(r(k),c(k),3)];
            end 
            
              scatter(X,Y,colors(i)); hold on ;  
             
end

    
end 
