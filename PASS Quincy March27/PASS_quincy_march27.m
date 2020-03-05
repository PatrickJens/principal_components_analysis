

Ax = importdata("ax.txt"); 
Ay = importdata("ay.txt");
Az = importdata("az.txt");
Gx = importdata("gx.txt");
Gy = importdata("gy.txt");
Gz = importdata("gz.txt");
A = linspace(0,numel(Ax));
G = linspace(0,numel(Gx));

figure;
subplot(6,1,1);
plot(Ax);
subplot(6,1,2);
plot(Ay);
subplot(6,1,3);
plot(Az);
subplot(6,1,4);
plot(Gx);
subplot(6,1,5);
plot(Gy);
subplot(6,1,6);
plot(Gz);
