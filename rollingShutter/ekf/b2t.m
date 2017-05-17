function theta_r = b2t(beta)

% generate theta(beta)

theta_r = zeros(3,9);
theta_r(1,1:3) = beta';
theta_r(2,4:6) = beta';
theta_r(3,7:9) = beta';