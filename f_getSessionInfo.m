function info = f_getSessionInfo(path) 
%%
% this function returns the information about a given session located in
% the path inputted 
%%
pathSep=regexp(path,filesep,'split');
experimenterName = 'OH';
% animal name
aniName = contains(pathSep,experimenterName);
aniName = pathSep{aniName};
% location
loc = contains(pathSep,'pos');
posLoc = find(loc,1);
loc =  pathSep{loc};
% date
year = '19';
date = contains( pathSep,year);
date =  pathSep{date};

% mainDir
direc = contains(pathSep,'analysis_suite2p');
direc = pathSep(1:find(direc==1)-1);
direc = strjoin(direc,filesep);
%% store in a structure 
info.aniName = aniName;
info.loc = loc;
info.date = date;
info.direc = direc;