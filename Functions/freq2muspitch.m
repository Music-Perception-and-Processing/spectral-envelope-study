function note = freq2muspitch(f)
fC4 = 261.625565300599;  % Middle C (C4) is 261.63 Hz
ff = fC4*2^(round(12*log2(f/fC4))/12); % round according to pitch grid
octave = floor(log2(ff/fC4) + 4);
chroma = mod(round(12*log2(f/fC4)), 12); 
noteTable = { 'C'   'C'  'C';
              'C#'  'Db' 'CIS';
              'D'   'D'  'D';
              'D#'  'Eb' 'DIS';
              'E'   'E'  'E';
              'F'   'F'  'F';
              'F#'  'Gb' 'FIS';
              'G'   'G'  'G';
              'G#'  'Ab' 'GIS';
              'A'   'A'  'A';
              'A#'  'Bb' 'AIS';
              'B'   'B'  'H';};
note = strcat(noteTable{chroma+1,3},num2str(octave));           
end