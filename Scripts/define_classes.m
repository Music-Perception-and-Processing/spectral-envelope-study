%% define analysis scope
clear an
% instrument families
an.fam.Vocals = fliplr({'VocalBass', 'VocalBaritone', 'VocalTenor', 'VocalAlto', 'VocalMSoprano', 'VocalSoprano', 'VocalCSoprano'}); 
an.fam.Strings = fliplr({'Bass', 'Cello', 'Viola', 'Violin'});
an.fam.Flutes = fliplr({'FluteBass', 'FluteAlto', 'Flute', 'FlutePiccolo'});
an.fam.Recorders = fliplr({'RecorderBass', 'RecorderTenor', 'RecorderAlto', 'RecorderSoprano'}); 
an.fam.Clarinets = fliplr({'ClarinetContrabass', 'ClarinetBass', 'ClarinetBassethorn', 'ClarinetBb', 'ClarinetEb'});
an.fam.Saxophones = fliplr({'SaxophoneBass', 'SaxophoneBaritone', 'SaxophoneTenor', 'SaxophoneAlto', 'SaxophoneSoprano'});
an.fam.Oboes = fliplr({'Heckelphone', 'OboeEnglishHorn', 'OboeFrench'}); 
an.fam.Bassoons = fliplr({'BassoonContra', 'Bassoon'}); 
an.fam.Trumpets = fliplr({'TrumpetBass', 'Cornet', 'TrumpetC', 'TrumpetPiccolo'}); 
an.fam.Trombones = fliplr({'TromboneContrabass', 'Cimbasso', 'TromboneBass', 'TromboneTenor', 'TromboneAlto'}); 
an.fam.Horns = ({'HornViennese', 'Horn'}); 
an.fam.Tubas = ({'Flugelhorn', 'Wagnertuba', 'Euphonium', 'Tuba', 'TubaContrabass'});
an.fam.Test = {'Test1', 'Test2'}; 

an.fam.Keys = fliplr({'Bosendorfer', 'Cembalo', 'OrganManualklavFlutes', 'OrganManualklavPlenum'}); 
an.fam.Pluckedstring = fliplr({'GuitarConcert', 'Harp'}); % this can be extended for study 2 with impulsive sounds
an.fam.Harmonicperc = fliplr({'VibraphoneMotorOff', 'Marimbaphone', 'Xylophone', 'Celesta', 'Glockenspiel'}); 
an.fam.Inharmonicperc = fliplr({'PercussionTubularBells', 'PercussionPlateBells', 'PercussionGongs'}); 

% get all the names straight
an.names.Vocals = fliplr({'Bass', 'Barit', 'Tenor', 'Alto', 'MSopr', 'Sopr', 'CSopr'}); 
an.names.Strings = fliplr({'Bass', 'Cello', 'Viola', 'Violin'});
an.names.Flutes = fliplr({'Bass', 'Alto', 'CFlute', 'Piccolo'});
an.names.Recorders = fliplr({'Bass', 'Tenor', 'Alto', 'Soprano'}); 
an.names.Clarinets = fliplr({'Contrab', 'Bass', 'Basseth', 'Bb', 'Eb'});
an.names.Saxophones = fliplr({'Bass', 'Baritone', 'Tenor', 'Alto', 'Soprano'});
an.names.Oboes = fliplr({'Heckelphone', 'EnglishHorn', 'FrenchOboe'}); 
an.names.Bassoons = fliplr({'ContraBassoon', 'Bassoon'}); 
an.names.Trumpets = fliplr({'Bass', 'Cornet', 'C', 'Piccolo'}); 
an.names.Trombones = fliplr({'Contrabass', 'Cimbasso', 'Bass', 'Tenor', 'Alto'}); 
an.names.Horns = ({'VienneseH', 'FrenchHorn'}); 
an.names.Tubas = ({'Flugelhorn', 'Wagnertuba', 'Euphonium', 'Tuba', 'ContrbTuba'});
an.names.Test = {'Test1', 'Test2', 'Impulse'}; 

an.names.Keys = fliplr({'Bosendorfer', 'Cembalo', 'OrganFlutes', 'OrganPlenum'}); 
an.names.Pluckedstrings = fliplr({'ConcertGuitar', 'Harp'}); % this can be extended for study 2 with impulsive sounds
an.names.Harmonicperc = fliplr({'Vibraphone', 'Marimbaphone', 'Xylophone', 'Celesta', 'Glockenspiel'}); 
an.names.Inharmonicperc = fliplr({'TubularBells', 'PlateBells', 'Gongs'}); 

% articulations
an.art.Strings = 'det';
an.art.Vocals = 'susAA'; 
an.art.Flutes = 'sus';
an.art.Recorders = 'sus'; 
an.art.Clarinets = 'sus'; 
an.art.Saxophones = 'susVib';
an.art.Oboes = 'sus'; 
an.art.Bassoons = 'sus';
an.art.Trumpets = 'sus'; 
an.art.Trombones = 'sus'; 
an.art.Horns = 'sus';
an.art.Tubas = 'sus';
an.art.Keys = 'tones'; 
an.art.Pluckedstring = 'sus'; 
an.art.Harmonicperc = 'tones'; 
an.art.Inharmonicperc = 'tones'; 
an.art.Test = 'tones';