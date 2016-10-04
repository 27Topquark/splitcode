%Kalman Data Preparation
clc
clear all
close all
load Feet_position_allframes
load model_init
Hind = Hind';
Front = Front';
Hind_x = Hind(1,:);
Hind_y = Hind(2,:);
Front_x = Front(1,:);
Front_y = Front(2,:);

Hind_new = [Hind_x(Hind_x~=0); Hind_y(Hind_y~=0)];
Front_new = [Front_x(Front_x~=0); Front_y(Front_y~=0)];

%% Running Kalman parameter initialisation
%% Running Kalman smoother
[model_smooth_hind_allframes,llh] = ldsEm(Hind_new,model_init);
[model_smooth_front_allframes,llh] = ldsEm(Front_new,model_init);

[nu_hind_allframes u_hind_allframes Ezz Ezy llh] = ...
    kalmanSmoother(Hind_new,model_smooth_hind_allframes);

[nu_front_allframes u_front_allframes Ezz Ezy llh] = ...
    kalmanSmoother(Front_new,model_smooth_front_allframes);

