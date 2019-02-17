function [x, y, z] = FilterSensorData(nx, ny, nz)
	n = 3; % order of the median filter
	x = medfilt1(nx, n);
    y = medfilt1(ny, n);
    z = medfilt1(nz, n);
end