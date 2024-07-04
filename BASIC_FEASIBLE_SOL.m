Var={'x1','x2','s2','s3','A1','A2','sol'};
M=1000;
cost=[-2 1 0 0 -M -M 0];
A=[3 1 0 0 1 0 3; 4 3 -1 0 0 1 6;1 2 0 1 0 0 3]
s=eye(size(A,1))
BV=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end
B=A(:,BV);
A=inv(B)*A;
zjcj=cost(BV)*A-cost;
ZCj=[zjcj;A];
Simplex_Table = array2table(ZCj);
Simplex_Table.Properties.VariableNames(1:size(ZCj,2))= Var
Run=true;
while Run
    if any(zjcj<0)
        fprintf('The current BFS is not optimal')
        fprintf('\n-------The next Iteration-------\n')
        disp('old Basic Variables= ')
        disp(BV)
        %TO FIND ENTERING VARIABLE
        ZC=zjcj(1:end-1);
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
            zjcj=zjcj-zjcj(Pvt_Col).*A(Pvt_Row,:);
            ZCj=[zjcj;A];
            Simplex_Table = array2table(ZCj);
            Simplex_Table.Properties.VariableNames(1:size(ZCj,2))=Var
            BFS=zeros(1,size(A,2));
            BFS(BV)=A(:,end);
            BFS(end)=sum(BFS.*cost);
            current_BFS=array2table(BFS);
            current_BFS.Properties.VariableNames(1:size(BFS,2))=Var
        end
    else
        Run=false;
        fprintf('The current BFS is optimal')
    end
end
finalbfs=zeros(1,size(A,2));
finalbfs(bv)=A(:,end);
finalbfs(end)=sum(finalbfs.*cost);
optimalbfs=array2table(finalbfs);
optimalbfs.Properties.VariableNames(1:size(optimalbfs,2))=Var

