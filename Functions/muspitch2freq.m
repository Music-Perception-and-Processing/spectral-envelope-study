function f = muspitch2freq(note)

oct = str2num(note(end)); 
notename = note(1:end-1); 
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
              'B'   'B'  'H';
              ''    ''  '';};
          
chroma = find(max(strcmp(notename, noteTable), [], 2)); 
octave = oct - 4;
T = chroma + 12*octave - 1; 
fC4 = 261.625565300599;  % Middle C (C4) is 261.63 Hz
f = fC4 .* 2 .^ (T / 12);

end