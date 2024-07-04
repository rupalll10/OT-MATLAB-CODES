%algebraic method
c=[3 -5];
a=[1 1;1 -2 6 -7];
b=[8;-3]
m=size(a,1) %no of constraints
n=size(a,2) %no of variables
s_no=nchoosek(n,m) %max no of basic sol
t=nchoosek(1:n,m) %define pairs (m at a time) 1:4,2
sol=[];
if n>=m
for i=1:s_no
    y=zeros(n,1);
    x=a(:,t(1,:))\b;
    if all(x>=0& x~=-inf) %feasibility cond
        y(t(1,:))=x;
        sol=[sol y];
    end
end
else
    error('eq larger than constraints')
end
z=c*sol;
[zmax,zindex]=max(z);
bfs=sol(:,zindex);
optimal=[bfs' zmax]; %b transpose
optimal_bfs=array2table(optimal);
optimal_bfs.Properties.VariableNames(1:size(optimal_bfs,2))={'x1','x2','x3','x4','value of z'}