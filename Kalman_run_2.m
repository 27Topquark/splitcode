%Updated on October 6th 2016

%% Preparing initial model
clc
clear all
close all
load model_init
load Feet_position_allframes
model_init_front = model_init;
model_init_front.mu0 = [Front(1,1);Front(1,2)];
model_init_hind = model_init;
model_init_hind.mu0 = [Hind(1,1);Hind(1,2)];

%% Kalman Data Preparation
Front = Front';
Hind = Hind';

%% Running Kalman parameter initialisation
%Running Kalman smoother
% TRADITIONAL VERSION
[model_smooth_hind_allframes,llh] = ldsEm(Hind,model_init_hind);
[model_smooth_front_allframes,llh] = ldsEm(Front,model_init_front);

[nu_hind_allframes ,u_hind_allframes, Ezz, Ezy, llh] = ...
    kalmanSmoother2(Hind,model_smooth_hind_allframes);

[nu_front_allframes, u_front_allframes ,Ezz, Ezy, llh] = ...
    kalmanSmoother2(Front,model_smooth_front_allframes);

%% Save
clearvars -except nu_front_allframes nu_hind_allframes u_hind_allframes u_front_allframes
save Kalman_smoothed_allframes


