
    p. binning                                     = 1;
    p. sz_fft                                      = 512./p.binning;
    %units are mm
    p. lambda                                      = 632.8e-6;
    p. dis_obj2modu                                = 11.5;
    p. dis_modu2ccd                                = 30;
    p. dis_obj2focus                               = 0;
    p. dx_dp                                       = 6.5e-3.*p.binning;
    p. dx_obj                                      = p. lambda.*p.dis_modu2ccd./p.sz_fft./p.dx_dp;
    p. dx_modu                                     = p. lambda.*p.dis_modu2ccd./p.sz_fft./p.dx_dp;

Y = [];
STD_Y = [];
X = [];

load('pos_066_real.mat')
load('pos_066.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_066,pos_066_real);
X(end+1) = 0.66;

load('pos_080_real.mat')
load('pos_080.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_080,pos_080_real);
X(end+1) = 0.8;

load('pos_096_real.mat')
load('pos_096.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_096,pos_096_real);
X(end+1) = 0.96;

load('pos_11_real.mat')
load('pos_11.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_11,pos_11_real);
X(end+1) = 11;

load('pos_13_real.mat')
load('pos_13.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_13,pos_13_real);
X(end+1) = 13;


load('pos_15_real.mat')
load('pos_15.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_15,pos_15_real);
X(end+1) = 15;

load('pos_18_real.mat')
load('pos_18.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_18,pos_18_real);
X(end+1) = 18;

load('pos_20_real.mat')
load('pos_20.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_20,pos_20_real);
X(end+1) = 20;

load('pos_23_real.mat')
load('pos_23.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_23,pos_23_real);
X(end+1) = 23;


load('pos_25_real.mat')
load('pos_25.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_25,pos_25_real);
X(end+1) = 25;

load('pos_28_real.mat')
load('pos_28.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_28,pos_28_real);
X(end+1) = 28;

load('pos_31_real.mat')
load('pos_31.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_31,pos_31_real);
X(end+1) = 31;

load('pos_35_real.mat')
load('pos_35.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_35,pos_35_real);
X(end+1) = 35;

load('pos_38_real.mat')
load('pos_38.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_38,pos_38_real);
X(end+1) = 38;

load('pos_42_real.mat')
load('pos_42.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_42,pos_42_real);
X(end+1) = 42;

load('pos_46_real.mat')
load('pos_46.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_46,pos_46_real);
X(end+1) = 46;

load('pos_51_real.mat')
load('pos_51.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_51,pos_51_real);
X(end+1) = 51;

load('pos_55_real.mat')
load('pos_55.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_55,pos_55_real);
X(end+1) = 55;


load('pos_60_real.mat')
load('pos_60.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_60,pos_60_real);
X(end+1) = 60;


load('pos_66_real.mat')
load('pos_66.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_66,pos_66_real);
X(end+1) = 66;


load('pos_72_real.mat')
load('pos_72.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_72,pos_72_real);
X(end+1) = 72;


load('pos_78_real.mat')
load('pos_78.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_78,pos_78_real);
X(end+1) = 78;


load('pos_85_real.mat')
load('pos_85.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_85,pos_85_real);
X(end+1) = 85;

load('pos_92_real.mat')
load('pos_92.mat');
[total_error,Y(end+1),STD_Y(end+1)] = cal_error(pos_92,pos_92_real);
X(end+1) = 92;


figure;errorbar(X,Y,STD_Y,"Marker",'.',"LineWidth",2.5,"CapSize",10,Color=[252/255,117/255,123/255]);
hold on;line( 0:1:100,ones(101),"LineWidth",2.5,"LineStyle",'--',Color=[204/255,204/255,204/255]);
xlim([-0.5,92]);
ylim([-0.1,1.1]);
xticks([0:10:92]);
yticks([0:0.25:1.1]);

