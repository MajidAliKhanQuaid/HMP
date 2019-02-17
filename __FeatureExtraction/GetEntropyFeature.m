function [bpower, seSignal] = GetSignalFeature(signal)
	bpower = bandpower(signal);
	seSignal = SampEn(sx, 1, 2);
end