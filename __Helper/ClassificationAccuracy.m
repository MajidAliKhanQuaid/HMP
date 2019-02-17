function [accuracy] = ClassificationAccuracy(data)
	totalRecords = height(data);
	match = 0;

	for index = 1 : totalRecords
        actual = data.actual(index);
        predicted = data.predicted(index);
        if actual == predicted
        	match = match + 1;
        end
	end
	accuracy = (match * 100) / totalRecords;
end