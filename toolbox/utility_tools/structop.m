function SS = structop (OPER, S, varargin )
% SS = StructOP (OPER,  S, varargin )
% $Revision: 1.54 $
% Structure operations
% addfield - add a field vaerargin{1) to structure with value varargin{2};
% cast2string - type cast numerical values to string for all fields
% cast2num - type cast strings to numerical values for fields supplied
% in varargin{1}
% cat - concatenate cell array of structures into a single structure
% addfield - addfield varag1 with value varg2
% array - return fields as an array
% cat - concatenate cell array of structures into a single structure
% commalist -
% datenum - convert filed varg1 to number and store in vararg2
% element_cat
% element_eq
% element_member
% element_merge - merge fields vararg3 of vargin1 into S using varargin2 as key. 
%                 arg4 controls warnings true (default) display warning
%                                        false suppress warning
% 
% element_reverse
% element_sort
% element_subasgn
% element_subset -  provides the subsets of a structure created from distinct sets
%           of values for the fields provided in the input fields list.
% element_subsref
% element_transpose
% element_untranspose
% field_length - length of field arg1
% find - return elements meeting specified equalities
%            finds OR values for multiples values
%            finds AND of multiple variables
% group - group values according to values in varg1
% intersect -
% 'isequal' Compares Columns of sturcture S to arg1
%            varg2 is options list of fields to ignore;
% logic_test - return rows where test varg1 on field varg2 is true
% min -
% merge - merge fields of multiple structures
%                  merge field vararg3 of vararg1 into S with index variable vararg2
% member - return elements within a fild whose elements are member of arg2
% max - sets value of field arg1 to its maximum value;
% merge - merge fields of multiple structures
%                  merge field vararg3 of vararg1 into S with index
%                  variable vararg2
% notmember - return elements with field is not a memeber of arg2
% reduce -
% rename - rename fields arg1 to arg2
% set - set field arg1 values with index arg2 to value arg3
% setall - set all vlaues of field arg1 to arg2
% set_empty_field - set emptyy values of field arg1 to arg2;
% setempty - set empty vales of field arg1 to arg2
% sort - sort structure according to keys
% subset -  provides the subsets of a structure created from distinct sets
%           of values for the fields provided in the input fields list.
%           NB works on S.name(n) format. USE element_subset instead.
%           Modify to work on S(n).name format. 
%
%       element_subset.
% % sum - sum elelements of a field.
% substruct - extract substructure elements
% transpose = transpose S(n).elements to S.elements(n).
% unique - return unique value of strucutre element
% unique_element -
% upper - convert field varg1 to upper case
% vect - convert strucutre elements to vector
%
if nargin <2,
    error('structop requires a minimum of two inputs');
end
if iscell(S) & length(S)==1,
    newS=S{1};
    S=newS;
end
switch lower(OPER),
    case 'addfield'
        SS=S;
        for i=1:2:length(varargin),
            VAR=varargin{i};
            VAL=varargin{i+1};
            nval=length(SS);
            for j=1:nval,
                SS(j).(VAR)=VAL;
            end
        end
    case 'array'
        VAR=varargin{1};
        nVar=length(VAR);
        nVal=length(S);
        SS=zeros(nVal,nVar);
        for i=1:nVar,
            SS(:,i)=[S.(VAR{i})];
        end

    case 'cast2string'
        if ~iscell(S),
            jTemp{1}=S;
            S=jTemp;
        end
        nEl=length(S{1});
        fieldName=fieldnames(S{1});
        nFields=length(fieldName);
        %% Generate subsets defined by unique values of first element of fieldName
        for iEl=1:nEl,
            for iField=1:nFields,
                if isnumeric(S{1}(iEl).(fieldName{iField}))
                    S{1}(iEl).(fieldName{iField})=num2str(S{1}(iEl).(fieldName{iField}));
                end
            end
        end
        SS=S;

    case 'cast2num'
        nEl=length(S);
        fieldName=varargin{1};
        nFields=length(fieldName);

        for iField=1:nFields,
            for iEl=1:nEl
                nElArray=length(S(iEl).(fieldName{iField}));
                tempArray=0;
                for iElArray=1:nElArray
                    tempArray(iElArray)=str2num(S(iEl).(fieldName{iField}){iElArray});
                end
                S(iEl).(fieldName{iField})=tempArray;
            end
        end
        SS=S;

    case 'cat'
        if ~iscell(S),
            SS=S;
            return
        end
        %
        % Determine dimension for cat
        if nargin==3,
            dim=varargin{1};
        else
            [nrow,ncol]=size(S{1});
            if nrow==1 & ncol>1,
                dim=2;
            elseif nrow>1 & ncol==1,
                dim=1;
            elseif nrow==1 & ncol==1,
                dim=1;
            else
                error('Dimension missmatch');
            end
        end
        for i=1:length(S),
            if i==1,
                SS=S{1};
            else
                SS=cat(dim,SS,S{i});
            end
        end

    case 'commalist'
        field=varargin{1};
        if ischar(S(1).(field)),
            SS=quote(S(1).(field));
            for i=2:length(S),
                SS= [ SS ','  quote(S(i).(field)) ];
            end
        else
            SS=num2str(S(1).(field));
            for i=2:length(S),
                SS= [ SS ','  num2str(S(i).(field)) ];
            end
        end

    case 'datenum'
        VARIN = varargin{1};
        VAROUT= varargin{2};
        SS=S;
        for i=1:length(S),
            dStr=SS(i).(VARIN);
            dNum=CMB_DateNum(dStr);
            SS(i).(VAROUT)=dNum;
        end

    case 'element_cat' % concatenate elements of varg1 and varg2.
        [fieldName, fieldLen, nField]=checkFields( S, true);
        [fieldName2, fieldLen2]=checkFields( varargin{1}, true);
        if length(setxor(fieldName,fieldName2)) ~= 0,
            error ('element_cat: fieldnames are not the same');
        end
        for i=1:nField,
            x=structop('element_values',S,fieldName{i}); % Do not use [] becuase of empty fields
            y=structop('element_values',varargin(1),fieldName{i}); % Do not use [] becuase of empty fields
            SS.(fieldName{i})=[x y ];
        end

    case 'element_eq' % Return indices of element varg1 is equal to arg2;
        [fieldName, fieldLen, nField]=checkFields( S, true);
        testField=varargin{1};
        testVal= varargin{2};
        if iscell(S.(testField)),
            SS=find(strcmp(S.(testField),testVal));
        else
            SS=find([S.(testField)]==testVal);
        end


    case 'element_merge' % merge fields vararg3 into elements of vararg1 into S with index variable vararg2
        % Check input arguments
        if nargin <5,
            error('element_merge requirest 5 input arguments ');
        elseif nargin ==5,
            warningFlag=true;
        else
            warningFlag=varargin{4};
        end
        % both structures must by of form S.elements(n);
        % Check field lengths
        [fieldName, fieldLen]=checkFields( S, true);
        [fieldName2, fieldLen2]=checkFields( varargin{1}, true);
        SS=S;
        nRow=length(S);
        mergeStruct=varargin{1};
        mergeKeyField=varargin{2};
        mergeFields=varargin{3};
        if ischar(mergeFields),
            mergeFields= {mergeFields};
        end
        % Check that all key fields in the merge strucutre are in the 
        % structure to be merged into 
        a=S.(mergeKeyField);
        b=mergeStruct.(mergeKeyField);
        if ~isempty(setdiff(b,a)) & warningFlag,
            warning('element:merge: arg2 contains key values  not in S');
        end           
        mergeIdx=hindex('init');
        keyValues=mergeStruct.(mergeKeyField);
        hindex('put',mergeIdx,keyValues);
        for iRow=1:nRow,
            jMerge=hindex('get',mergeIdx,[S(iRow).(mergeKeyField)]);
            kMerge=find(~isnan(jMerge));
            if length(kMerge)~=length(jMerge) & warningFlag,
                warning(['element_merge: S has key values not in arg2. Missing values set to null']);
            end
            for j=1:length(mergeFields),
                for k=1:length(jMerge),
                     varClass=class(mergeStruct.(mergeFields{j}));
                    if ~isnan (jMerge(k)),
                       
                      temp=mergeStruct.(mergeFields{j})(jMerge(k));
                      switch varClass
                          case {'double', 'logical'}
                              SS(iRow).(mergeFields{j})(k)=temp;
                          case 'cell'
                               SS(iRow).(mergeFields{j})(k)=temp;
                          otherwise
                              error(['type not supported:' class(temp)]);
                      end
                    else
                        switch varClass
                            case 'double'
                              SS(iRow).(mergeFields{j})(k)=nan;
                            case 'cell'
                                 SS(iRow).(mergeFields{j}){k}='null';
                        end
                    end
                end
            end
        end


    case 'element_reverse' % Reverse elements of a s.Name(n) structure array
        [fieldName, fieldLen, nField]=checkFields( S, true);
        I=fieldLen:-1:1;
        SS=structop('element_subsref', S, I);
    case 'element_sort' % Sort fields in order of fieldName(s) in vararg1
        [fieldName, fieldLen, nField]=checkFields( S, true);
        SV=S;
        sortVar=varargin{1};
        if ~iscell(sortVar),
            sortVar={sortVar};
        end
        el=[SV.(sortVar{1})];
        % Check for nans and empty fields
        if iscell(el),
            for j=1:length(el)
                if isempty(el{j})
                    el{j}=' ';
                end
            end
            % elc=char(el);
            % i=find(isnan(elc(:,1)));
            i=[];
        else
            i=find(isnan(el));
        end
        if length(i)>0,
            error(['Cannot sort. Nans present in field:' sortVar{1}]);
        end
        %
        uval = unique(el);
        nval=length(uval);
        [ssort,isort]=sort(el);
        els=el(isort);
        for iField=1:nField,
            curField=fieldName{iField};
            SS.(curField)=SV.(curField)(isort);
        end
        if length(sortVar)==1 | length(SS.(curField))==1,
            return
        else
            curSortVar=sortVar{1};
            n=length(sortVar)-1;
            newarg(1:n)= sortVar(2:end);
            sortValues=unique(SS.(curSortVar));
            for iVal=1:length(sortValues),
                jVal=structop('element_eq',SS,curSortVar, sortValues(iVal));
                sSort=structop('element_subsref',SS,jVal);
                sTemp=structop('element_sort',sSort,newarg);
                if iVal==1,
                    sOut=sTemp;
                else
                    sOut=structop('element_cat',sOut,sTemp);
                end
            end
            SS=sOut;
        end



    case 'element_subsasgn' % subscripted assigne,  returns elements arg2 of field arg1 to arg3 ;
        fieldName=fieldnames(S);
        asgnField=varargin{1};
        % Check that field exists
        if ~any(strcmp(fieldName,asgnField)),
            error(['element_subsasgn: field does not exist: ' asgnField]);
        end
        asgnElement=varargin{2};
        asgnVal=varargin{3};
        if length(asgnVal)==1,
            asgn
            Val=asgnElement*0 + asgnVal;
        elseif length(asgnVal) ~= length(asgnElement),
            error('element_subsasgn: Number of values must match thenumber of indices');
        end
        SS=S;
        SS.(asgnField)(asgnElement)=asgnVal;

     case 'element_subset' % Operates on transposed data
        if ~iscell(S),
            jTemp{1}=S;
            S=jTemp;
        end
        nEl=length(S);
        fieldName=varargin{1};
        if ~iscell(fieldName),
            fieldName={fieldName};
        end
        nSet=length(fieldName);
        curSet=fieldName{1};
        %% Generate subsets defined by unique values of first element of fieldName
        k=0;
        for iEl=1:nEl,
            setVal=unique([S{iEl}.(curSet)]);
            for iVal=1:length(setVal),
                curVal=setVal(iVal);
                if iscell([S{iEl}.(curSet)]),
                    kTemp=find(strcmp(S{iEl}.(curSet),curVal));
                else
                    kTemp=find([S{iEl}.(curSet)]==curVal);
                end
                k=k+1;
                SS{k}=structop('element_subsref',S{iEl},kTemp);
            end
        end
        %% If there is only one element in the set list we are done
        if nSet==1,
            return
            % Otherwise shorten the list and recurse
        else
            SS= structop('subset',SS, fieldName(2:end));
        end

    
    case 'element_subsref' % subscripted reference, returns elements of S defined by varargin{1};

        fname=fieldnames(S);
        iElements=varargin{1};
        nFields=length(fname);
        for i=1:nFields,
            var=fname{i};
            if length(S.(var))==1,
                SS.(var)=S.(var);
            else
                SS.(var)=S.(var)(iElements);
            end
        end

    case 'element_transpose' % transpose S(n).element to S.element(n)
        [fieldName, fieldLen, nField]=checkFields( S, false);
        nRow=length(S);

        for j=1:nField,
            x=S(1).(fieldName{j});
            if ischar(x),
                for iRow=1:nRow,
                    SS.(fieldName{j})(iRow)={S(iRow).(fieldName{j})};
                end
            elseif isnumeric(x) | islogical(x) | iscell(x),
                SS.(fieldName{j}) = [S.(fieldName{j})];
            else
                error('transpose only supports elements which are characters, logical, or numeric');
            end
        end

    case 'element_untranspose' % untranspose S.element(n) to S(n).element
        [fieldName, fieldLen, nField]=checkFields( S, false);
        nRow=length(S(1).(fieldName{1}));

        for j=1:nField,
            x=S(1).(fieldName{j});
            if iscell(x),
                for iRow=1:nRow,
                    SS(iRow).(fieldName{j})=S.(fieldName{j}){iRow};
                end
            elseif ischar(x) | isnumeric(x) | islogical(x)
                for iRow=1:nRow,
                    SS(iRow).(fieldName{j})=S.(fieldName{j})(iRow);
                end
            else
                error('untranspose only supports elements which are characters, logical, or numeric');
            end
        end

    case 'element_values' % Return values in field arg1 of S
        % handle nans and empty fields
        [fieldName, fieldLen, nField]=checkFields( S, true);
        outputFieldName=varargin{1};
        SS(1:fieldLen)=S.(outputFieldName);



    case 'field_length'
        VAR=varargin{1};
        for i=1:length(S),
            SS(i)=length(S(i).(VAR));
        end

    case {'find' ,'match'}  % Finds "and" combinations of variable/value pairs
        F=S;
        if length(F)==0,
            SS=F;
            return
        end
        for i=1:2:nargin-2,
            VAR=varargin{i};
            VAL=varargin{i+1};
            nVal=length(VAL);
            k=[];
            if isnumeric (F(1).(VAR)),
                % Warning: only works for scalars
                for j=1:length(VAL),
                    k=[k find([F.(VAR)]==VAL(j)) ];
                end
            elseif ischar (F(1).(VAR)),  % Character string
                n=length(F);
                [d{1:n}]=deal(F.(VAR));
                ktemp=zeros(1,n);
                if ischar(VAL),
                    switch lower(OPER)
                        case 'find'
                            ktemp=strcmp(VAL,d);
                            k=find(ktemp);
                        case 'match'
                            k=strmatch(VAL,d);
                    end
                elseif iscell(VAL),
                    for j=1:length(VAL),
                        ktemp=ktemp | strcmp(VAL{j},d);
                        k=find(ktemp);
                    end
                end
            elseif islogical(F(1).(VAR)),
                for j=1:length(VAL),
                    k=[k find([F.(VAR)]==VAL(j)) ];
                end
            else
                error ('data type not supported');
            end
            FT=F(k);
            F=FT;
            if length(F)==0,
                break
            end
        end
        SS=F;
        if nargout==2,
            I=i;
        end


    case 'group' %Group values common to a key variable
        VAR=varargin{1};
        ST=structop('sort',S, VAR);
        fnames=fieldnames(ST);
        cnt=0;
        flag=false;
        keyValue=ST(1).(VAR);
        for i=1:length(ST),
            if flag, % flag is true if current value equals previous value
                for j=1:length(fnames),
                    if ischar(ST(i).(fnames{j})),
                        k=length(SS(cnt).(fnames{j}))+1;
                        SS(cnt).(fnames{j}){k}=  ST(i).(fnames{j});
                    else
                        SS(cnt).(fnames{j})= [SS(cnt).(fnames{j}) ST(i).(fnames{j})];
                    end
                end
            else % New Value
                cnt=cnt+1;
                previousVAL=ST(i).(VAR);
                for j=1:length(fnames),
                    if ischar(ST(i).(fnames{j})) ,
                        SS(cnt).(fnames{j}){1}=  ST(i).(fnames{j});
                    else
                        SS(cnt).(fnames{j})=ST(i).(fnames{j});
                    end
                end
                keyValue=SS(cnt).(VAR);
            end
            SS(cnt).(VAR)=keyValue;
            if i==length(ST),
                break
            end
            if ischar(previousVAL),
                flag=strcmp(previousVAL,ST(i+1).(VAR));
            else
                flag=ST(i+1).(VAR)==previousVAL;
            end
        end

    case 'logic_test' % return rows where field function vararg1 (s.(vararg2) is true
        FNC=varargin{1};
        VAR=varargin{2};
        j=[];
        cmd=[ FNC '(S(i).(VAR))'];
        for i=1:length(S),
            if eval(cmd),
                j=[j i];
            end
        end
        SS=S(j);

    case 'intersect' % Compute intersction for cell array of structures
        if ~iscell(S),
            S={S};
        end
        N=length(S);
        VAR = varargin{1};
        SS= [S{1}.(VAR)];
        for i=2:N,
            SS= intersect(SS,[S{i}.(VAR)]);
        end
        
    case 'isequal'  % Compares Columns of sturcture S to arg1
                    % varg2 is options list of fileds to ignore;
        S2=varargin{1};
        nS=length(S);
        nS2=length(S2);
        if length(varargin)==2,
            S=rmfield(S,varargin{2});
            S2=rmfield(S2,varargin{2});
        end
        for iS=1:nS,
            for jS2=1:nS2;
                SS(iS,jS2)=isequal(S(iS),S2(jS2));
            end
        end

    case 'merge' % merge field vararg3 of vararg1 into S with index variable vararg2
        S1=varargin{1}; % Structure to merge from
        mergeVar = varargin{2}; % Key value
        mergeField=varargin{3};
        if ischar(mergeField),
            mergeField= {mergeField};
        end
        nField=length(mergeField);
        mergeValS1=structop('vector',S1,mergeVar);
        mergeValS=structop('vector',S,mergeVar);
        nMerge=length(mergeValS1);
        SS=S;
        for iMerge=1:nMerge,
            mergeValCur=mergeValS1(iMerge);
            if isnumeric(mergeValCur),
                mergeIndex=find(mergeValS==mergeValCur);
            elseif iscell(mergeValS1(iMerge)),
                mergeIndex=find(strcmp(mergeValS, mergeValCur));
            end
            for iField=1:nField,
                field=mergeField{iField};
                for j=1:length(mergeIndex),
                    k=mergeIndex(j);
                    SS(k).(field)=S1(iMerge).(field);
                end
            end
        end


    case { 'element_member' 'element_notmember'} % Return structure  elements where field elements are/are members of fieldlist
        if nargin<4,
            error('structop notmember requries 4 inputs: oper, struct, fieldname, memberlist)');
        end
        testField=varargin{1};
        testSet=varargin{2};
        switch OPER
            case 'element_member'
                j=find(ismember(S.(testField), testSet));
            case 'element_notmember'
                j=find(~ismember(S.(testField), testSet));
        end
        SS=structop('element_subsref',S,j);




    case {'member' 'notmember'} % Return structure  elements where field is not a member of fieldlist
        if nargin<4,
            error('structop notmember requries 4 inputs: oper, struct, fieldname, memberlist)');
        end
        VAR=varargin{1};
        VAL=varargin{2};
        j=0;
        for i=1:length(S),
            if length(S(i).(VAR))>1 & ~ischar(S(i).(VAR)),
                error('structop member/notmember does not support multiple values');
            end
            memberFlag=ismember(S(i).(VAR),VAL);
            if (strcmp(OPER,'member') & memberFlag )|  (strcmp(OPER,'notmember') & ~memberFlag),
                j=j+1;
                if j==1,
                    SS=S(i);
                else
                    SS(j)=S(i);
                end
            end
        end

    case 'rename' % rename field arg1 to arg2
        fnames=fieldnames(S);
        iold=1:2:length(varargin);
        inew=iold+1;
        nChange=length(iold);
        SS=S;
        nVal=length(S);
        for i=1:nVal;
            for j=1:nChange,
                oldField=varargin{iold(j)};
                newField=varargin{inew(j)};
                SS(i).(newField)=SS(i).(oldField);
            end
        end
        SS=rmfield(SS,varargin(iold));

    case 'reduce'
        n=length(S);
        var=varargin{1};
        SS=S(1).(var)(:);
        for i=2:n,
            SS=cat(1,SS,S(i).(var)(:));
        end;

    case 'round' %  set all values of filed arg1 to arg2;
        % Make sure field exists
        SS=S;
        for i=1:2:length(varargin),
            var=varargin{i};
            decimals=varargin{i+1};
            specifier=['%3.' num2str(decimals) 'f'];
            if ~any(strcmp(fieldnames(S),var)),
                error([' Field name does not exist: ' var ]);
            end
            for j=1:length(SS),
                SS(j).(var)=sprintf(specifier,SS(j).(var));
            end
        end



    case 'set' %  field values
        var=varargin{1}; % field name to set
        idx=varargin{2}; % index
        val=varargin{3}; % new value
        % Make sure field exists
        if ~any(strcmp(fieldnames(S),var)),
            error([' Field name does not exist: ' var ]);
        end

        if length(val)==1,
            val=idx*0 + val;
        end
        if length(idx) ~= length(val),
            error(' index and value vectors are not the same length');
        end
        SS=S;
        for i=1:length(idx),
            j=idx(i);
            SS(j).(var)=val(i);
        end

    case 'setall' %  set all values of filed arg1 to arg2;
        % Make sure field exists
        SS=S;
        for i=1:2:length(varargin),
            var=varargin{i};
            val=varargin{i+1};
            if ~any(strcmp(fieldnames(S),var)),
                error([' Field name does not exist: ' var ]);
            end
            for j=1:length(SS),
                SS(j).(var)=val;
            end
        end

    case 'set_empty_field' %  set emtpy fields to a vlaue
        var=varargin{1}; % field name to set
        val=varargin{2}; % new value
        % Make sure field exists
        if ~any(strcmp(fieldnames(S),var)),
            error([' Field name does not exist: ' var ]);
        end
        SS=S;
        for i=1:length(S),
            if isempty(S(i).(var));
                SS(i).(var)=val;
            end
        end

    case { 'sort'  'sort_descend'} % Sort field in order of fieldName(s) in varaqrg1
            sortMode='ascend';
            if strcmp(lower(OPER),'sort_descend'),
                sortMode='descend';
            end
        SV=S;
        sortVar=varargin{1};
        if ~iscell(sortVar),
            sortVar={sortVar};
        end
        el=structop('vector',SV,sortVar{1});
        if iscell(el),
            for j=1:length(el)
                if isempty(el{j})
                    el{j}=' ';
                end
            end
            elc=char(el);
            i=find(isnan(elc(:,1)));
        else
            i=find(isnan(el));
        end
        if length(i)>0,
            error(['Cannot sort. Nans present in field:' varargin{iarg}]);
        end
        uval = unique(el);
        nval=length(uval);
        if iscell(el),
            [ssort,isort]=sort(el);
            if strcmp(OPER,'sort_descend'),
                isort=rev(isort);
            end
        else    
            [ssort,isort]=sort(el,2,sortMode);
        end
        
        els=el(isort);
        SS=SV(isort);
        if length(sortVar)==1 | length(SS)==1,
            return
        else
            n=length(sortVar)-1;
            newarg(1:n)= sortVar(2:end);
            for ival=1:nval,
                if isnumeric(uval(ival)) | islogical(uval(ival)),
                    jval=find(els==uval(ival));
                elseif iscell(uval(ival)),
                    jval=find(strcmp(els,uval(ival)));
                end
                S1= structop(OPER,SS(jval), newarg);

                SS(jval)=S1;
            end
        end

    case 'cell2string'  % extract elements specified in vararg1
        % vararg1 is either a field name or cell array of field names
        fieldName=varargin{1};
        if ~iscell(fieldName),
            fieldName={fieldName};
        end
        SS=S;
        for i=1:length(S),
            for j=1:length(fieldName)
                var=fieldName{j};
                SS(i).(var)=S(i).(var){1};
            end
        end

    case 'subset' % Operates on transposed data
        if ~iscell(S),
            jTemp{1}=S;
            S=jTemp;
        end
        nEl=length(S);
        fieldName=varargin{1};
        if ~iscell(fieldName),
            fieldName={fieldName};
        end
        nSet=length(fieldName);
        curSet=fieldName{1};
        %% Generate subsets defined by unique values of first element of fieldName
        k=0;
        for iEl=1:nEl,
            setVal=unique([S{iEl}.(curSet)]);
            for iVal=1:length(setVal),
                curVal=setVal(iVal);
                if iscell([S{iEl}.(curSet)]),
                    kTemp=find(strcmp(S{iEl}.(curSet),curVal));
                else
                    kTemp=find([S{iEl}.(curSet)]==curVal);
                end
                k=k+1;
                SS{k}=structop('element_subsref',S{iEl},kTemp);
            end
        end
        %% If there is only one element in the set list we are done
        if nSet==1,
            return
            % Otherwise shorten the list and recurse
        else
            SS= structop('subset',SS, fieldName(2:end));
        end

    case 'substruct'  % extract elements specified in vararg1
        % vararg1 is either a field name or cell array of field names
        fieldName=varargin{1};
        if ~iscell(fieldName),
            fieldName={fieldName};
        end
        for i=1:length(S),
            for j=1:length(fieldName)
                var=fieldName{j};
                SS(i).(var)=S(i).(var);
            end
        end

    case 'min' % Mainimum  value of field arg1 for each row
        SS=S;
        nVar=nargin-2;
        for iVar=1:nVar,
            VAR=varargin{iVar};
            for i=1:length(S),
                SS(i).(VAR)=min([SS(i).(VAR)]);
            end
        end

    case 'max' % Maximum value of field arg1 for each row
        SS=S;
        nVar=nargin-2;
        for iVar=1:nVar,
            VAR=varargin{iVar};
            for i=1:length(S),
                SS(i).(VAR)=max([SS(i).(VAR)]);
            end
        end

    case 'sum'
        SS=S;
        nVar=nargin-2;
        for iVar=1:nVar,
            VAR=varargin{iVar};
            for i=1:length(S),
                SS(i).(VAR)=sum([SS(i).(VAR)]);
            end
        end

    case 'unique' % return unique elements of a structure
        var=varargin{1};
        if length(S)==0,
            SS=[];
            return
        end
        if isnumeric (S(1).(var)) | islogical(S(1).(var)),
            SS=[S.(var)];
            j=find(~isnan(SS));
            SS=unique(SS(j));

        elseif ischar(S(1).(var)),
            [SS{1:length(S)}]=deal(S.(var));
            SS=unique(SS);

        else
            error ('bad type');
        end
        return

    case 'unique_element' % return unique elements of a structure
        SS=S;
        nVar=nargin-2;
        for iVar=1:nVar,
            var=varargin{iVar};
            if length(S)==0,
                return
            end
            if isnumeric(S(1).(var)),
                for j=1:length(S),
                    SS(j).(var)=unique(S(j).(var));
                end
            else
                error ('bad data type for this option');
            end
        end
        return

    case 'upper' % Convert values in fields arg1 to upper case
        SS=S;
        if length(S)==0,
            return
        end
        for j=1:length(varargin),
            var=varargin{j};
            if ~ischar(S(1).(var)),
                error([ ' Field ' var ' is not of type char' ]);
            end
            for i=1:length(SS),
                SS(i).(var)=upper(SS(i).(var));
            end
        end

    case 'vector' % convert fields of structure to a vector
        var=varargin{1};
        if isempty(S),
            SS=[];
            return
        end
        if isnumeric (S(1).(var)) | islogical(S(1).(var)),
            for i=1:length(S), % Use loop to avoid problems with null entries
                if isempty(S(i).(var)),
                    SS(i)=nan;
                else
                    SS(i)=[S(i).(var)];
                end
            end
        elseif ischar(S(1).(var)),
            [SS{1:length(S)}]=deal(S.(var));
        else
            error('data type not supported');
        end
    otherwise
        error(['Operation not defined:' OPER ]);
end

function [fieldName, fieldLen , nField] = checkFields (S, error_flag)
% Check that all filelds in S have the same length
% Trigger and error if error_glaf is true
if isempty(S),
    error (['Structure is empty']);
end
        
fieldName=fieldnames(S);
nField=length(fieldName);
for i=1:nField,
    fieldLen(i)=length([S.(fieldName{i})]);
end
fieldLen=unique(fieldLen);
if length(fieldLen) >1 & error_flag,
    error('Fields have different lengths');
end