%Person 1 is Alexia
%Person 2 is Borus
%Person 3 is Nurudeen
%Person 4 is Patrick
%Person 5 is Quincy
%Import and trim alexia pass
ax_alexia = importdata("ax1.txt");
axa = copyPartOfSignal(ax_alexia, 2250, 22000);
ay_alexia = importdata("ay1.txt");
aya = copyPartOfSignal(ay_alexia, 2250, 22000);
az_alexia = importdata("az1.txt");
aza = copyPartOfSignal(az_alexia, 2250, 22000);
gx_alexia = importdata("gx1.txt");
gxa = copyPartOfSignal(gx_alexia, 2250, 22000);
gy_alexia = importdata("gy1.txt");
gya = copyPartOfSignal(gy_alexia, 2250, 22000);
gz_alexia = importdata("gz1.txt");
gza = copyPartOfSignal(gz_alexia, 2250, 22000);
%Import and trim Borus pass
ax_borus = importdata("ax2.txt");
axborus = copyPartOfSignal(ax_borus, 10000, 40000);
ay_borus = importdata("ay2.txt");
ayborus = copyPartOfSignal(ay_borus, 10000, 40000);
az_borus = importdata("az2.txt");
azborus = copyPartOfSignal(az_borus, 10000, 40000);
gx_borus = importdata("gx2.txt");
gxborus = copyPartOfSignal(gx_borus, 10000, 40000);
gy_borus = importdata("gy2.txt");
gyborus = copyPartOfSignal(gy_borus, 10000, 40000);
gz_borus = importdata("gz2.txt");
gzborus = copyPartOfSignal(gz_borus, 10000, 40000);
%Import and Trim Nurudeen pass
ax_nurudeen = importdata("ax3.txt"); 
axn = copyPartOfSignal(ax_nurudeen, 30000, 50000);
ay_nurudeen = importdata("ay3.txt");
ayn = copyPartOfSignal(ay_nurudeen, 30000, 50000);
az_nurudeen = importdata("az3.txt");
azn = copyPartOfSignal(az_nurudeen, 30000, 50000);
gx_nurudeen = importdata("gx3.txt");
gxn = copyPartOfSignal(gx_nurudeen, 30000, 50000);
gy_nurudeen = importdata("gy3.txt");
gyn = copyPartOfSignal(gy_nurudeen, 30000, 50000);
gz_nurudeen = importdata("gz3.txt");
gzn = copyPartOfSignal(gz_nurudeen, 30000, 50000);
%Import and Trim Patrick pass
ax_patrick = importdata("ax4.txt");
axp = copyPartOfSignal(ax_patrick, 5000, 22500);
ay_patrick = importdata("ay4.txt");
ayp = copyPartOfSignal(ay_patrick, 5000, 22500);
az_patrick = importdata("az4.txt");
azp = copyPartOfSignal(az_patrick, 5000, 22500);
gx_patrick = importdata("gx4.txt");
gxp = copyPartOfSignal(gx_patrick, 5000, 22500);
gy_patrick = importdata("gy4.txt");
gyp = copyPartOfSignal(gy_patrick, 5000, 22500);
gz_patrick = importdata("gz4.txt");
gzp = copyPartOfSignal(gz_patrick, 5000, 22500);
%Import and Trim Quincy pass
ax_quincy = importdata("ax5.txt");
axquincy = copyPartOfSignal(ax_quincy, 5000, 45000);
ay_quincy = importdata("ay5.txt");
ayquincy = copyPartOfSignal(ay_quincy, 5000, 45000);
az_quincy = importdata("az5.txt");
azquincy = copyPartOfSignal(az_quincy, 5000, 45000);
gx_quincy = importdata("gx5.txt");
gxquincy = copyPartOfSignal(gx_quincy, 5000, 45000);
gy_quincy = importdata("gy5.txt");
gyquincy = copyPartOfSignal(gy_quincy, 5000, 45000);
gz_quincy = importdata("gz5.txt");
gzquincy = copyPartOfSignal(gz_quincy, 5000, 45000);

%concatentate dimensions
ax = [ axa', axborus', axn', axp', axquincy' ];
ay = [ aya', ayborus', ayn', ayp', ayquincy' ];
az = [ aza', azborus', azn', azp', azquincy'  ];
gx = [ gxa', gxborus', gxn', gxp', gxquincy'  ];
gy = [ gya', gyborus', gyn', gyp', gyquincy'  ];
gz = [ gza', gzborus', gzn', gzp', gzquincy'  ];
figure;
subplot(6,1,1);
plot(ax);title('Pass: Alexia, Borus, Nurudeen, Patrick, and Quincy Ax, Ay, Az, Gx, Gy, Gz')
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
plot(gz)
figure;
PASS_GZ = [gzborus', gzp', gzquincy'  ];
plot(PASS_GZ);


