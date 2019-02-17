function [magnitude, sma] = GetVectorFeature(x, y, z)
	magnitude = sqrt(x.^2 + y.^2 + z.^2);
	sma = sum(x) + sum(y) + sum(z);
end