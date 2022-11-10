%{
C = [1 1 0 0 0 0 0;1 0 1 0 1 1 0;0 1 1 1 0 0 0;0 0 0 1 1 0 1;0 0 0 0 0 1 1];
Sx = [1 0 0;0 0 0;0 0 0;0 0 0;0 0 0];
Sy = [0 1 0;0 0 0;0 0 0;0 0 0;0 0 1];%each row is joint. col 1 is Sx1 (pin), col 2 and 3 are Sy1 (pin) and Sy2 (roller)
X = [0 12 6 18 24];
Y = [0 0 6 4 0];
L = [0;0;0;0;0;0;27.2;0;0;0];%first half horizontal, second vert. Each row is joint
%}
%load("TrussDesign1_Cole_A3.mat")
[j, m] = size(C);
A = zeros(2*j, m);
totallength = 0;
for c = 1:m
    a1 = 0;
    a2 = 0;
    for r = 1:j
        if(C(r,c) == 1) 
            if(a1 == 0)
                a1 = r;
            else
                a2 = r;
            end
        end
    end
    dis = sqrt((X(a2) - X(a1))^2 + (Y(a2) - Y(a1))^2);
    totallength = totallength + dis;
    A(a1,c) = (X(a2) - X(a1))/dis;
    A(a2,c) = (X(a1) - X(a2))/dis;
    A(a1 + j,c) = (Y(a2) - Y(a1))/dis;
    A(a2 + j,c) = (Y(a1) - Y(a2))/dis;
end
S = [Sx;Sy];
A = [A S];
T = A\L;
fprintf('EK301, Section A3, Truss me bro: Cole R., Henry N., Gosoo P., 11/9/2022\n');
fprintf("Load: %f oz\n", L(L~=0));
fprintf("Member forces in oz\n");
format = 'm%d: %.3f (%c)\n';
max = 0;
critm = 0;
for i = 1:(numel(T)-3)
    if(T(i) < 0) 
        Torc = 'C';
        if(abs(T(i)) > max)
            max = T(i);
            critm = i;
        else
        end
    else
        Torc = 'T';
    end
    fprintf(format, i, abs(T(i)), Torc);
end
mem = (find(C(:,critm) == 1))';
p1 = mem(1);
p2 = mem(2);
L = sqrt((X(p1) - X(p2))^2 + (Y(p1) + Y(p2))^2);
pcrit = 2945/L^2;
Wmax = -pcrit/L;
fprintf("Reaction forces in oz:\n")
fprintf("Sx1: %.2f\n", T(numel(T) - 2));
fprintf("Sy1: %.2f\n", T(numel(T) - 1));
fprintf("Sy2: %.2f\n", T(numel(T)));
cost = j*10 + totallength;
fprintf("Cost of truss: $%.2f\n", cost);
fprintf("Theoretical max load/cost ration in oz/$: %f\n", abs(Wmax/cost));