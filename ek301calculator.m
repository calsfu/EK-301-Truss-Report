j = input("How many joints ");
m = 2*j-3;
C = zeros(j, m);
X = zeros(1, j);
Y = zeros(1, j);
Sx = zeros(j,3);
Sy = zeros(j, 3);
for i = 1:m 
    prompt = sprintf("Which two joints is M%d touching. (type 1 then enter): ", i);
    r1 = input(prompt);
    r2 = input('');
    C(r1, i) = 1;
    C(r2, i) = 1;
end
for i = 1:j
    prompt = sprintf("What is x of J%d: ", i);
    x = input(prompt);
    prompt = sprintf("What is y of J%d: ", i);
    y = input(prompt);
    X(i) = x;
    Y(i) = y;   
end
L = zeros(j*2,1); 
W = input("What is the load: ");
no = input("What joint is the load on: ");
L(no+j) = W;
xy = input("Which joint is pin: ");
x = input("Which joint is roller: ");
Sy(x, 3) = 1;
Sy(xy, 2) = 1;
Sx(xy, 1) = 1;
save('TrussDesign3_Cole_A3.mat','C','Sx','Sy','X','Y','L');
ek301;