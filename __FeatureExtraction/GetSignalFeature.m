function [bpower, se] =  GetSignalFeature(signal)
	bpower = bandpower(signal);
	se = SampEn(signal, 1, 2);
end