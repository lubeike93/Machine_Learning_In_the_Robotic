function [ par ] = Exercise1( k )

%Load the data
data=load('Data.mat');

%output & Input
Output=transpose(data.Output) ;
Input=transpose(data.Input) ;

% lenghth of matrix
n=20000 ;

minPos_Val_Error=intmax ;
minOri_Val_Error=intmax ;

%varying the p1 p2 from 1 to 6
for i=1:6       

    average_position_validation_error=0 ;
    average_orientation_validation_error=0 ;     

    %cross valdiation from 1 to k

    for K=1:k
    
        start= 1 + (K - 1) * n/k ;
        finish =   K*n/k ;
    
        %1 of the k sets is used for testing Input_test and Output_test
        
        Input_test= Input(start:finish,:);
        Output_test= Output(start:finish,:);
    
        %Other sets are used  for training..Combining all other sets in Input_train_total and Output_train_total
        %Input_train_after and Input_train_before contains data sets after and before training sets
        if(finish == n)
            
            Input_train_after=[] ;
            Out_train_after=[] ;
        else  
            Input_train_after= Input(finish+1:n,:);
            Out_train_after= Output(finish+1:n,:);
        end

          if(start == 1)
            Input_train_total=Input_train_after;
            Output_train_total= Out_train_after;     
          else
            %set for training before testing set
            Input_train_before= Input(1:start-1,:);
            Out_train_before= Output(1:start-1,:);

            Input_train_total=[Input_train_before; Input_train_after];
            Output_train_total=[Out_train_before; Out_train_after];
          end 

          % training set preapred in Input_train_total and Output_train_total
          
        Y= Output_train_total  ;
        v= Input_train_total(:,1) ;
        w= Input_train_total(:,2) ;
        vw=Input_train_total(:,1).*Input_train_total(:,2);
        X=[] ;
        
       %generate the X matrix poly is the polynom
        for poly=1:i
            X= [X,v.^poly, w.^poly, vw.^poly] ;
        end 
        
       X=[ones(size(Input_train_total,1),1), X];

       
%Weight matrix calculated: w*
       w_opt = inv(X' * X) * X' * Y  ;
       
       %Training is done. Validation will start now 
          
       v= Input_test(:,1) ;
       w= Input_test(:,2) ;
       vw=Input_test(:,1).*Input_test(:,2);
       X_valid=[];
       for poly=1:i
            X_valid=[X_valid, v.^poly, w.^poly, vw.^poly] ;
       end 
       X_valid=[ones(size(Input_test,1),1), X_valid] ;
       Y_predictive= X_valid*w_opt ;
       no_of_samples_for_testing=size(X_valid,1);
       
       %Total k validation errors will be there for each polynomial value
       position_error_validation=  sum(sqrt((Y_predictive(:,1) - Output_test(:,1)).^2+(Y_predictive(:,2) - Output_test(:,2)).^2 ))/no_of_samples_for_testing ;
       orientation_error_validation= sum(sqrt((Y_predictive(:,3) - Output_test(:,3)).^2))/no_of_samples_for_testing ;
       
       
        %Average validation error for this polynomial
        %Avergae is changed inside the loop. avg_new = (avg_old*(K-1)+new_value)/K)
       average_position_validation_error=(average_position_validation_error*(K-1)+position_error_validation)/K ;
       average_orientation_validation_error=(average_orientation_validation_error*(K-1)+orientation_error_validation)/K ;
    end 
    
   
   %Setting minimum validation position error for this polynomial value
    if(average_position_validation_error < minPos_Val_Error)
        minPos_Val_Error=average_position_validation_error ;
        P1=i ; %p1 
        
    end 
    
    %Setting minimum validation orientation error for this polynomial value    
    if(average_orientation_validation_error < minOri_Val_Error)
        minOri_Val_Error=average_orientation_validation_error ;
        P2=i ; %p2   
        
    end 
       
end

        
%Re-estimate model parameters for selected_position_polynomial and selected_orientation_polynomial using entire data set
        v= Input(:,1) ;
        w= Input(:,2) ;
        vw=Input(:,1).*Input(:,2);
        Y=Output ;
        
        X1=[] ;
       
        for poly=1:P1
            X1= [X1,v.^poly, w.^poly, vw.^poly] ;
        end 
        X1=[ones(size(Input,1),1), X1];

       %Weight matrix calculated using whole data set for polynomial : selected_position_polynomial
       woptimalForPosition = inv(X1' * X1)*X1' * Y  ;
              
        disp('Selected Position Polynomial');
        disp(P1);
        disp('Selected Position Error');
        disp(average_position_validation_error);
        disp('Position Weight Matrix');
        disp(woptimalForPosition);
    
       
       %Now calculating Weight matrix using whole data set for polynomial : selected_orientation_polynomial
       
       X2=[] ;
       
       for poly=1:P2
            X2= [X2,v.^poly, w.^poly, vw.^poly] ;
        end 
       X2=[ones(size(Input,1),1), X2];
        
       woptimalForOrientation = inv(X2' * X2)*X2' * Y ;
       disp('Selected Orientation Polynomial')
       disp(P2)
       disp('Selected Orientation Error')
       disp(average_orientation_validation_error)
       disp('Orientation Weight Matrix')
       disp(woptimalForOrientation);
        
        par{1} = woptimalForPosition(:,1);
        par{2} = woptimalForPosition(:,2);
        par{3} = woptimalForOrientation(:,3);
        save('params','par')
end
