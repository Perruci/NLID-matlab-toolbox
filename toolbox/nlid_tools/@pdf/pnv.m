function [Rval] = pnv(sys,mode, case_flag)
% pnv - returns public properties or vlaues of object sys. 
% sys - object
% mode - mode to return [names/values]
% case - 'lower' returns values as lower case 

% Copyright 1999-2003, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

if nargin < 3,
    case_flag='lower';
end

parent=sys.nldat; % Parent object
Npublic = 1;    % Number of MS specific public properties
AsgnVals = {'Parameters'       };
Rval=pnvmain ( sys,mode, case_flag, parent, Npublic, AsgnVals);


