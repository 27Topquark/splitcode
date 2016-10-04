clc

clear all
close all
%Extracted from Kalman_Data_version2

load Feet_position_allframes

mask_front = (Front~=0);
mask_front = mask_front(:,1);

mask_hind = (Hind~=0);
mask_hind = mask_hind(:,1);

%% Extracting distance from the centre

centre = [262,203];
fun1 = @(a,b) (a-b).*(a-b);
sqr_front  = bsxfun(fun1,Front,centre);
sqr_hind = bsxfun(fun1,Hind,centre);
sqr_front = sqrt(sqr_front(:,1) + sqr_front(:,2));
sqr_hind = sqrt(sqr_hind(:,1) + sqr_hind(:,2));

%will have to mask for the zero values in Front and Hind vectors as they
%will simply be the distance from origin

%% Extracting angle from the centre

%Method: acosd(dot(vec1,vec2)/(norm(vec1)*norm(vec2));
vec1  = [262 203 0] - [1 203 0];

VEC2_front = bsxfun(@minus,[centre 0],[Front zeros(777,1)]);
VEC2_hind = bsxfun(@minus,[centre 0],[Hind zeros(777,1)]);

angles_front = zeros(size(VEC2_front,1),1);
angles_hind = zeros(size(VEC2_hind,1),1);

for i = 1:1:size(VEC2_front,1)
    angles_front(i) = acosd(dot(vec1,VEC2_front(i,:))/(norm(vec1)*norm(VEC2_front(i,:))));
    angles_hind(i) = acosd(dot(vec1,VEC2_hind(i,:))/(norm(vec1)*norm(VEC2_hind(i,:))));
end

%% Correcting with masks
angles_front = angles_front.*mask_front;
sqr_front = sqr_front.*mask_front;
angles_hind = angles_hind.*mask_hind;
sqr_hind = sqr_hind.*mask_hind;

%% Plotting
plot_front_angles = angles_front(angles_front~=0);
plot_hind_angles = angles_hind(angles_hind~=0);
figure(1),plot(1:size(plot_front_angles,1),plot_front_angles);
figure(2),plot(1:size(plot_hind_angles,1),plot_hind_angles);

plot_sqr_front = sqr_front(sqr_front~=0);
plot_sqr_hind = sqr_hind(sqr_front~=0);
figure(3),plot(1:size(plot_sqr_front,1),plot_sqr_front);
figure(4),plot(1:size(plot_sqr_hind,1),plot_sqr_hind);

figure(5),plot(1:size(plot_front_angles,1),plot_front_angles,'r','LineWidth',1);
hold on;
plot(1:size(plot_hind_angles,1),plot_hind_angles,'b','LineWidth',1);
legend('Front paw','Hind paw');
hold off


figure(6),plot(1:size(plot_sqr_front,1),plot_sqr_front,'r','LineWidth',1);
hold on
plot(1:size(plot_sqr_hind,1),plot_sqr_hind,'b','LineWidth',1);
legend('Front paw','Hind paw');
hold off





