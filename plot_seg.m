function [p1,dp] = plot_seg(seg_num)

%subplot za prikaz giba
x = [0.00,0.17,0.17,0.00,-0.17,0.17,0.00,-0.17,-0.17,0.00,0.00,0.00,0.17,0.17,-0.17,-0.17,0.00];
y = [-0.16,-0.16,0.16,-0.16,-0.16,-0.16,-0.16,0.16,-0.16,-0.16,0.16,-0.16,0.16,-0.16,-0.16,0.16,-0.16];


p1 = [x(seg_num) y(seg_num)];   % First Point
p2 = [x(seg_num+1) y(seg_num+1)];       % Second Point
dp = p2-p1;                         % Difference