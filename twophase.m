
var = {'x1', 'x2', 'x3', 's1', 's2', 'a1', 'a2', 'sol'};
a = [3, -1, -1, -1, 0, 1, 0;
     1, -1, 1, 0, -1, 1, 0];
b = [3;2];
A = [a b];
bv = [ 6, 7];
cost = [0, 0, 0, 0, 0, -1, -1, 0];
zjcj = cost(bv) * A - cost;
simp_table = [A; zjcj];
array2table(simp_table, 'VariableNames', var)
while 1
    zc = zjcj(1, end-1);
    if any(zc > 0)
        [entering_val, pvt_col] = max(zc);
        for i = 1 : size(A, 1)
            if A(i, pvt_col) > 0
                ratio(i) = A(i, end)/A(i, pvt_col);
            else
                ratio(i) = inf;
            end
        end
        [leaving_var, pvt_row] = min(ratio);
        
    end
end