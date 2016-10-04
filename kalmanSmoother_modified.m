function [nu, U, Ezz, Ezy, llh] = kalmanSmoother_modified(X,model,foot,frame_state)
%This Kalman smoother has been modified to incorporate Steve's comment
%about blowing up the covairance matrices and setting the 0 points to the
%previous point and then continuing

%The EM algorithm for fitting the model though has not been modified !
%Confirm about this from Steve.
% Kalman smoother (forward-backward algorithm for linear dynamic system)
% Input:
%   X: d x n data matrix
%   model: model structure
%   foot: To enable the program to know which foot data has been sent
% Output:
%   nu: q x n matrix of latent mean mu_t=E[z_t] w.r.t p(z_t|x_{1:T})
%   U: q x q x n latent covariance U_t=cov[z_t] w.r.t p(z_t|x_{1:T})
%   Ezz: q x q matrix E[z_tz_t^T]
%   Ezy: q x q matrix E[z_tz_{t-1}^T]
%   llh: loglikelihood.

A = model.A; % transition matrix 
G = model.G; % transition covariance
C = model.C; % emission matrix
S = model.S;  % emision covariance
mu0 = model.mu0; % prior mean
P0 = model.P0;  % prior covairance

n = size(X,2);
q = size(mu0,1);
mu = zeros(q,n);
V = zeros(q,q,n);
P = zeros(q,q,n); % C_{t+1|t}
Amu = zeros(q,n); % u_{t+1|t}
llh = zeros(1,n);
I = eye(q);

% forward
% Checking for zero entry into an X column
if (X(1,1) == 0 && X(2,1) == 0)
    switch foot
        
        case 'F'
            X(1,1) = 146;
            X(2,1) = 128;
            new_frame_state.tag(1) = 'F';
            
        case 'H'
            X(1,1) = 409;
            X(2,1) = 182;
            new_frame_state.tag(1) = 'H';
    end
    
    P0 = 10*P0;
else
    new_frame_state.tag(1) = frame_state.tag(1);
    
end
PC = P0*C';
R = (C*PC+S);
K = PC/R;
mu(:,1) = mu0+K*(X(:,1)-C*mu0);
V(:,:,1) = (I-K*C)*P0;
P(:,:,1) = P0;  % useless, just make a point
Amu(:,1) = mu0; % useless, just make a point
llh(1) = logGauss(X(:,1),C*mu0,R);

for i = 2:n   
    state = 1;
    if (X(1,i) == 0 && X(2,i) == 0)
    switch foot
        
        case 'F'
                  frametag = new_frame_state.tag(i-1);
                  init = 1;
                  j = i-init;
                  
                  %By design there will be atleast one frame with one of
                  %those letters
                  
                  while ((frametag~='F' && frametag~='B') && j > 0)
                      init = init + 1;
                      j = i - init;
                      frametag = new_frame_state.tag(j);
                  end
                  if j>0
                      new_frame_state.tag(i) = 'F';
                      X(1,1) = X (1,j);
                      X(2,1) = X(2,j);
                  else
                      disp('FAILURE');
                      break;
                      
                  end
                  state = 4;  
            
        case 'H'
            frametag = new_frame_state.tag(i-1);
                  init = 1;
                  j = i-init;
                  
                  %By design there will be atleast one frame with one of
                  %those letters
                  frametag = char(frametag);
                  while ((frametag~='H' && frametag~='B') && j > 0)
                      init = init + 1;
                      j = i - init;
                      frametag = new_frame_state.tag(j);
                  end
                  if j>0
                      new_frame_state.tag(i) = 'F';
                      X(1,1) = X(1,j);
                      X(2,1) = X(2,j);
                  else
                      disp('FAILURE');
                      break;
                      
                  end
                  state = 4;
    end
    
    
    else
        new_frame_state.tag(i) = frame_state.tag(i);
        state = 1;
    end

    [mu(:,i), V(:,:,i), Amu(:,i), P(:,:,i), llh(i)] = ...
        forwardStep(X(:,i), mu(:,i-1), state*V(:,:,i-1), A, G, C, S, I);
end
llh = sum(llh);


% backward
nu = zeros(q,n);
U = zeros(q,q,n);
Ezz = zeros(q,q,n);
Ezy = zeros(q,q,n-1);

nu(:,n) = mu(:,n);
U(:,:,n) = V(:,:,n);
Ezz(:,:,n) = U(:,:,n)+nu(:,n)*nu(:,n)';
for i = n-1:-1:1  
    [nu(:,i), U(:,:,i), Ezz(:,:,i), Ezy(:,:,i)] = ...
        backwardStep(nu(:,i+1), U(:,:,i+1), mu(:,i), V(:,:,i), Amu(:,i+1), P(:,:,i+1), A);
end

function [mu, V, Amu, P, llh] = forwardStep(x, mu0, V0, A, G, C, S, I)
P = A*V0*A'+G;                                              % 13.88
PC = P*C';
R = C*PC+S;
K = PC/R;                                                   % 13.92
Amu = A*mu0;
CAmu = C*Amu;
mu = Amu+K*(x-CAmu);                                        % 13.89
V = (I-K*C)*P;                                             % 13.90
llh = logGauss(x,CAmu,R);                                   % 13.91


function [nu, U, Ezz, Ezy] = backwardStep(nu0, U0, mu, V, Amu, P, A)
J = V*A'/P;                                                 % 13.102
nu = mu+J*(nu0-Amu);                                        % 13.100
U = V+J*(U0-P)*J';                                          % 13.101
Ezy = J*U0+nu0*nu';                                         % 13.106 
Ezz = U+nu*nu';                                             % 13.107