function FeatureExtraction()
% Code to Search Subdirectories and Files
% Training Data (trD), Testing Data (ttD)

startTime = clock; % noting start time for the feature extraction

pth = genpath(pwd);
pathTest = regexp([pth ';'], '(.*?);', 'tokens');
for k = 1:size(pathTest, 2) - 1
	list{k} = dir([pathTest{1, k}{:} '\*.txt']);
end

samplingRate = 30;
windowSize = 5; % 5 second window 
template = struct('fileName', 'FILE_NAME', 'sma', 0, 'bpA', 0, 'seA', 0, 'minA', 0, 'meanA', 0, 'maxA', 0, 'sdA', 0, 'bpX', 0, 'seX', 0, 'minX', 0, 'meanX', 0, 'maxX', 0, 'sdX', 0, 'bpY', 0, 'seY', 0,  'minY', 0, 'meanY', 0, 'maxY', 0, 'sdY', 0, 'bpZ', 0, 'seZ', 0, 'minZ', 0, 'meanZ', 0, 'maxZ', 0,'sdZ', 0, 'actual' , 'NOT_KNOWN','predicted' , 'NOT_KNOWN'); % Dummy Recrord

% Loop is Started with 2 to avoid the current Directory
trD(5000) = template;
ttD(5000) = template;

windowCounter = 1; % counts the number of windows captured in whole dataset
trDCount = 1; % counts training data
ttDCount = 1; % counts testing data

trRatio = 75; % training data ratio
ttRatio = 100 - trRatio; % testing data ratio (unused)

for di = 2 : numel(list) % di for directory iterator
	disp('****************** New Directory ******************');
	if (~ isempty(list{di})) % if is valid directory

		tempFolder = list{di};
		filesCount = numel(tempFolder);

		for fi = 1 : filesCount % fi for text file iterator

			% extracting activity (folder name) from the path
			fileName = fullfile(tempFolder(fi).folder, tempFolder(fi).name);
			splittedCells = strsplit(tempFolder(fi).folder, '\');
			activity = splittedCells{length(splittedCells)};
			disp(fileName);

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

				% setting labels for activity
				temp.fileName = tempFolder(fi).name;
				temp.actual = activity;
				temp.predicted = activity;

				% temporarily holding windowed vector
				tempX = x(startPos : endPos);
				tempY = y(startPos : endPos);
				tempZ = z(startPos : endPos);

				% extracting features from signals
				[magnitude, temp.sma] = GetVectorFeature(tempX, tempY, tempZ);

				[temp.bpA, temp.seA] = GetSignalFeature(magnitude);
				[temp.bpX, temp.seX] = GetSignalFeature(tempX);
				[temp.bpY, temp.seY] = GetSignalFeature(tempY);
				[temp.bpZ, temp.seZ] = GetSignalFeature(tempZ);

				[temp.minA, temp.meanA, temp.maxA, temp.sdA] = GetStatisticalFeature(magnitude);
				[temp.minX, temp.meanX, temp.maxX, temp.sdX] = GetStatisticalFeature(tempX);
				[temp.minY, temp.meanY, temp.maxY, temp.sdY] = GetStatisticalFeature(tempY);
				[temp.minZ, temp.meanZ, temp.maxZ, temp.sdZ] = GetStatisticalFeature(tempZ);

				% splitting data into training and testing according to the 'trRatio'
				if windowCounter <= trRatio
					trD(trDCount) = temp;
					trDCount = trDCount + 1;
				else
					ttD(ttDCount) = temp;
					ttDCount = ttDCount + 1;
				end

				windowCounter = windowCounter + 1;
				if windowCounter > 100
					windowCounter = 1;
				end

			end
		end
	end
end

trD = trD(1 : trDCount - 1); % shrinking the training vector size to space used
ttD = ttD(1 : ttDCount - 1); % shrinking the testing vector size to space used

struct2csv(trD, 'Training.csv'); % write training vector of structs to csv file
struct2csv(ttD, 'Testing.csv'); % write testing vector of structs to csv file 

endTime = clock; % noting end time for the feature extraction
timeElapsed = etime(endTime, startTime); % calculating time elapsed between end and start (time)
message = strcat('Time Taken in Feature Extraction :', string(timeElapsed));
disp(message);

