function [x, y, z] = GetSensorData(fileName)
	dataFile = fopen(fileName, 'r');
	data = fscanf(dataFile, '%d\t%d\t%d\n', [3, inf]);

	x = data(1, :);
	y = data(2, :);
	z = data(3, :);
    
    fclose(dataFile);
end