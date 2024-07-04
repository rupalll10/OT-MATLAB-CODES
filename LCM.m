LCM
%% Input Phase
Cost=[5 2 4 3;6 4 9 5; 2 3 8 1]
A=[30 40 55] %ROW
B=[15 20 40 50]%COLUMN
%% To check unbalanced/balanced Problem
if sum(A)==sum(B)
    fprintf('Given Transportation Problem is Balanced \n')
else
   fprintf('Given Transportation Problem is Unbalanced \n') 
   if sum(A)<sum(B)
       Cost(end+1,:)=zeros(1,size(B,2))
       A(end+1)=sum(B)-sum(A)
   elseif sum(B)<sum(A)
   Cost(:,end+1)=zeros(1,size(A,2))
       B(end+1)=sum(A)-sum(B)  
   end
end
ICost=Cost
X=zeros(size(Cost))   % Initialize allocation
[m,n]=size(Cost)      % Finding No. of rows and columns
BFS=m+n-1             % Total No. of BFS
%% Finding the cell(with minimum cost) for the allocations
for i=1:size(Cost,1)
    for j=1:size(Cost,2)
hh=min(Cost(:))   % Finding minimum cost value
[Row_index, Col_index]=find(hh==Cost)  % Finding position of minimum cost cell
x11=min(A(Row_index),B(Col_index))
[Value,index]=max(x11)            % Find maximum allocation
ii=Row_index(index)       % Identify Row Position
jj=Col_index(index)        % Identify Column Position
y11=min(A(ii),B(jj))        % Find the value
X(ii,jj)=y11
A(ii)=A(ii)-y11
B(jj)=B(jj)-y11
Cost(ii,jj)=Inf
    end
end
%% Print the initial BFS
fprintf('Initial BFS =\n')
IBFS=array2table(X)
disp(IBFS)
%% Check for Degenerate and Non Degenerate
TotalBFS=length(nonzeros(X))
if TotalBFS==BFS
    fprintf('Initial BFS is Non-Degenerate \n')
else
    fprintf('Initial BFS is Degenerate \n')
end
%% Compute the Initial Transportation cost
InitialCost=sum(sum(ICost.*X))
fprintf('Initial BFS Cost is = %d \n',InitialCost)
 
