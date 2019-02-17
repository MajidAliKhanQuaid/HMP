function FeatureBandPower()

	samplingRate = 30;
	windowSize = 5; % 5 second window 

	fileName = 'C:\Users\MajidAliKhanQuaid\Documents\MATLAB\HMP\Brush_teeth\Accelerometer-2011-04-11-13-29-54-brush_teeth-f1.txt';

	% reading accelerometer file
	[noisy_x, noisy_y, noisy_z] = GetSensorData(fileName);

	% filtering accelerometer data
	[x, y, z] = FilterSensorData(noisy_x, noisy_y, noisy_z);

	sampleCount = length(x);
	seconds = length(x) / samplingRate; % No of seconds of data
	windows = seconds / windowSize; % No of windows present in current data
	windowWidth = windowSize * samplingRate; % width of window in terms of samples

	% initializing bounding window parameters, needed in feature extraction
	startPos = 0;
	endPos = 0;

	for index = 1 : windows % index refers to as window count

		% setting bounding window parameters, needed in feature extraction
		endPos = endPos + windowWidth;
		startPos = (endPos - windowWidth) + 1;

		% temporarily holding windowed vector
		tempX = x(startPos : endPos);
		tempY = y(startPos : endPos);
		tempZ = z(startPos : endPos);

		bpX = bandpower(tempX);
		bpY = bandpower(tempY);
		bpZ = bandpower(tempZ);

	end

end