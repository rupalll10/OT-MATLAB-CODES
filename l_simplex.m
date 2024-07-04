clc
clear all
C=[1 -3 2];
A=[3 -1 2 ;-2 4 0 ;-4 3 8 ];
B=[7;12;10];
S=eye(size(A,1));
A=[A S B];
Cost=[-1 3 -2 0 0 0 0];
No_of_variables=3;
BV=No_of_variables+1:1:(size(A,2)-1);
ZjCj=Cost(BV)*A-Cost;
ZCj=[ZjCj;A];
Simplex_Table = array2table(ZCj);
Simplex_Table.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','S1','S2','S3','Solution'}
Run=true;
while Run
    if any(ZjCj<0)
        fprintf('The current BFS is not optimal')
        fprintf('\n-------The next Iteration-------\n')
        disp('old Basic Variables= ')
        disp(BV)
        %TO FIND ENTERING VARIABLE
        ZC=ZjCj(1:end-1);
        [EnterCol,Pvt_Col]=min(ZC);
        fprintf('The most -ve element in Zj-Cj is %d corresponding to column %d \n', EnterCol,Pvt_Col);
        fprintf('Entering variable is %d \n', Pvt_Col)
        %TO FIND LEAVING VARIABLE
        Sol=A(:,end);
        column=A(:,Pvt_Col)
        if all (column<=0)
            error('LPP has unbounded solution. All entries are of <=0 type in column %d',Pvt_Col)
        else
            %FINDING MINIMUM RATIO
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i)=Sol(i)./column(i);
                else
                    ratio(i) = inf;
                end
            end
                [MinRatio,Pvt_Row]=min(ratio);
                fprintf('Min ratio corresponding to pivot row is %d \n',Pvt_Row)
                fprintf('Leaving variable is %d \n',BV(Pvt_Row))
        end
        BV(Pvt_Row)=Pvt_Col;
        disp('New Basic Variables(BV)=')
        disp(BV)
        Pvt_key=A(Pvt_Row,Pvt_Col);
        %UPDATING TABLE
        A(Pvt_Row,:)=A(Pvt_Row,:)./Pvt_key;
        for i=1:size(A,1);
            if i~=Pvt_Row
                A(i,:)=A(i,:)-A(i,Pvt_Col).*A(Pvt_Row,:);
            end
            ZjCj=ZjCj-ZjCj(Pvt_Col).*A(Pvt_Row,:);
            ZCj=[ZjCj;A];
            Simplex_Table = array2table(ZCj);
            Simplex_Table.Properties.VariableNames(1:size(ZCj,2))={'x1','x2','x3','S1','S2','S3','Solution'}
            BFS=zeros(1,size(A,2));
            BFS(BV)=A(:,end);
            BFS(end)=sum(BFS.*Cost);
            current_BFS=array2table(BFS);
            current_BFS.Properties.VariableNames(1:size(BFS,2))={'x1','x2','x3','S1','S2','S3','Solution'}
        end
    else
        Run=false;
        fprintf('The current BFS is optimal')
    end
end