function [wav,k] = wavdir()
% get wav files from current directory

d = dir;
L = length(d);
wav.name = 0;
k = 0;
for l = 1:L
    if size(d(l).name,2) > 4
        if strcmp(d(l).name(end-3:end), '.wav') | ...
                strcmp(d(l).name(end-2:end), '.au') | ...
                strcmp(d(l).name(end-4:end), '.aiff') | ...
                strcmp(d(l).name(end-3:end), '.mp3') | ...
                strcmp(d(l).name(end-3:end), '.m4a')
                
            wav(k+1).name = d(l).name;
            k = k + 1;
        end
    end
end

        
        
    

