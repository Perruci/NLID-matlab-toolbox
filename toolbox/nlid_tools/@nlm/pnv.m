function [Rval] = pnv(sys,mode, case_flag);
% pnv - returns public properties or vlaues of object sys. 
% sys - object
% mode - mode to return [names/values]
% case - 'lower' returns values as lower case 

% Copyright 1999-2003, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see copying.txt and gpl.txt 

if nargin < 3,
    case_flag='lower';
end
parent=sys.nltop; % Parent object
Npublic = 5;    % Number of MS specific public properties
AsgnVals = { 'CELL model elements' ; ...
        'CELL input name(s)' ; ...
        'REAL - parameters values used to generte model' ; ...
        'CELL - name(s) of output variable(s)' ; ...
        'STRING - notes'};

Rval=pnvmain ( sys,mode, case_flag, parent, Npublic, AsgnVals);

