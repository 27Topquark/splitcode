%Updated on October 4th 2016

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
% Front_new = Zero_fill(Front);
% Front_new = Front_new';
Front = Front';
Front_new = Front;
% Hind = Hind';
% Front = Front';
% Hind_x = Hind(1,:);
% Hind_y = Hind(2,:);
% Front_x = Front(1,:);
% Front_y = Front(2,:);

% Hind_new = [Hind_x(Hind_x ~= 0); Hind_y(Hind_y ~= 0)];
% Front_new = [Front_x(Front_x ~= 0); Front_y(Front_y~=0)];

% Hind_new = Hind;
% Front_new = Front;

%% Running Kalman parameter initialisation
%Running Kalman smoother
% TRADITIONAL VERSION
%[model_smooth_hind_allframes,llh] = ldsEm(Hind_new,model_init_hind);
[model_smooth_front_allframes,llh] = ldsEm(Front_new,model_init_front);

%[nu_hind_allframes ,u_hind_allframes, Ezz, Ezy, llh] = ...
 %   kalmanSmoother(Hind,model_smooth_hind_allframes);

[nu_front_allframes, u_front_allframes ,Ezz, Ezy, llh] = ...
    kalmanSmoother2(Front,model_smooth_front_allframes);



%% EXPERIMENTAL VERSION
 %[model_smooth_hind_allframes_NEW,llh,ii] = ldsEm_modified(Hind_new,model_init_hind,'H',frame_state);
 %[model_smooth_front_allframes_NEW,llh,ii] = ldsEm_modified(Front_new,model_init_front,'F',frame_state);

%  [model_smooth_hind_allframes_NEW,llh] = ldsEm(Hind_new,model_init_hind);
%  [model_smooth_front_allframes_NEW,llh] = ldsEm(Front_new,model_init_front);
% 
% [nu_hind_allframes_NEW, u_hind_allframes_NEW, Ezz, Ezy ,llh] = ...
%     kalmanSmoother_modified(Hind,model_smooth_hind_allframes_NEW,'H',frame_state);
% 
% [nu_front_allframes_NEW, u_front_allframes_NEW, Ezz, Ezy, llh] = ...
%     kalmanSmoother_modified(Front,model_smooth_front_allframes_NEW,'F',frame_state);


