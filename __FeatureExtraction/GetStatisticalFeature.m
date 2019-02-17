function [fmin, fmean, fmax, fsd] = GetStatisticalFeature(signalComponent)
	fmin = min(signalComponent);
	fmax = max(signalComponent);
	fmean = mean(signalComponent);
	fsd = std(signalComponent);
end