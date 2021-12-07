% s = 2*r*sin^-1(d/2*r)
% s is arclength
% d is chord length
% r is radius

load 'FIA_Tracks.mat'

Track_FIA = MidOhio_FIA;

% Filtering stage, only for IMSA tracks (Mid Ohio and Road Atlanta)
% Reverse sign, only for IMSA tracks
Track_FIA(:,2) = -movmean(Track_FIA(:,2),30);

% d = sin(s / 2r) * 2r
d = sin( (diff(Track_FIA(:,1))) ./ 2 .* Track_FIA(2:end,2)) .* 2 ./ Track_FIA(2:end,2);

% theta = s / r
theta = diff(Track_FIA(:,1)) .* -Track_FIA(2:end,2);
theta_abs = cumsum(theta);

pts = zeros(size(Track_FIA,1),2);

for k=2:size(pts,1)
    % x
    pts(k,1) = pts(k-1,1) + d(k-1) .* cos(theta_abs(k-1));
    
    % y
    pts(k,2) = pts(k-1,2) + d(k-1) .* sin(theta_abs(k-1));
end

pts(:,3) = zeros(size(Track_FIA,1),1);
pts(:,4) = zeros(size(Track_FIA,1),1);

figure(1)
plot(pts(:,1),pts(:,2))

figure(2)
plot(Track_FIA(:,1),Track_FIA(:,2))
