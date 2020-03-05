%Import and trim alexia walk
ax_alexia = importdata("ax_alexia.txt");
axa = copyPartOfSignal(ax_alexia, 10000, 20000);
ay_alexia = importdata("ay_alexia.txt");
aya = copyPartOfSignal(ay_alexia, 10000, 20000);
az_alexia = importdata("az_alexia.txt");
aza = copyPartOfSignal(az_alexia, 10000, 20000);
gx_alexia = importdata("gx_alexia.txt");
gxa = copyPartOfSignal(gx_alexia, 10000, 20000);
gy_alexia = importdata("gy_alexia.txt");
gya = copyPartOfSignal(gy_alexia, 10000, 20000);
gz_alexia = importdata("gz_alexia.txt");
gza = copyPartOfSignal(gz_alexia, 10000, 20000);
%Import and trim nurudeen walk
ax_nurudeen = importdata("ax_nurudeen.txt"); 
axn = copyPartOfSignal(ax_nurudeen, 10000, 20000);
ay_nurudeen = importdata("ay_nurudeen.txt");
ayn = copyPartOfSignal(ay_nurudeen, 10000, 20000);
az_nurudeen = importdata("az_nurudeen.txt");
azn = copyPartOfSignal(az_nurudeen, 10000, 20000);
gx_nurudeen = importdata("gx_nurudeen.txt");
gxn = copyPartOfSignal(gx_nurudeen, 10000, 20000);
gy_nurudeen = importdata("gy_nurudeen.txt");
gyn = copyPartOfSignal(gy_nurudeen, 10000, 20000);
gz_nurudeen = importdata("gz_nurudeen.txt");
gzn = copyPartOfSignal(gz_nurudeen, 10000, 20000);
%import and trim patrick walk
ax_patrick = importdata("ax_patrick.txt");
axp = copyPartOfSignal(ax_patrick, 10000, 20000);
ay_patrick = importdata("ay_patrick.txt");
ayp = copyPartOfSignal(ay_patrick, 10000, 20000);
az_patrick = importdata("az_patrick.txt");
azp = copyPartOfSignal(az_patrick, 10000, 20000);
gx_patrick = importdata("gx_patrick.txt");
gxp = copyPartOfSignal(gx_patrick, 10000, 20000);
gy_patrick = importdata("gy_patrick.txt");
gyp = copyPartOfSignal(gy_patrick, 10000, 20000);
gz_patrick = importdata("gz_patrick.txt");
gzp = copyPartOfSignal(gz_patrick, 10000, 20000);
%concatentate dimensions
ax = [ axa', axn', axp' ];
ay = [ aya', ayn', ayp' ];
az = [ aza', azn', azp' ];
gx = [ gxa', gxn', gxp' ];
gy = [ gya', gyn', gyp' ];
gz = [ gza', gzn', gzp' ];
WALK_GZ = [ gzn', gzp' ];
%Plot raw data
figure;
subplot(6,1,1);
plot(ax);title('Walk: Alexia, Nurudeen, and Patrick Ax, Ay, Az, Gx, Gy, Gz')
subplot(6,1,2);
plot(ay);
subplot(6,1,3);
plot(az);
subplot(6,1,4);
plot(gx);
subplot(6,1,5);
plot(gy);
hold on
subplot(6,1,6);
plot(gz);
figure;
plot(WALK_GZ);
