classdef oppMatrix < oppSpot
%OPPMATRIX   Convert a distributed matrix into a pSpot operator.
%
%   oppMatrix(A,DESCRIPTION) creates an operator that performs
%   matrix-vector multiplication with matrix A. The optional parameter
%   DESCRIPTION can be used to override the default operator name when
%   printed.
%
%   Note: divide is only supported if the matrix is square.

%   Copyright 2009, Ewout van den Berg and Michael P. Friedlander
%   See the file COPYING.txt for full copyright information.
%   Use the command 'spot.gpl' to locate this file.

%   http://www.cs.ubc.ca/labs/scl/spot
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = private)
        matrix = {}; % Underlying matrix
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function op = oppMatrix(A,description)
       %opMatrix  Constructor.
          if nargin < 1
             error('At least one argument must be specified.')
          end
          if nargin > 2
             error('At most two arguments can be specified.')
          end
          
          % Check if input is a distributed matrix
          if ~isdistributed(A)
             error('Input argument must be distributed.');
          else
              if ~strcmp(classUnderlying(A),'double')
                  error('Input argument must be a distributed matrix.');
              end
          end
          
          % Check description parameter
          if nargin < 2, description = 'pMatrix'; end

          % Create object
          op = op@oppSpot(description, size(A,1), size(A,2));
          op.cflag  = ~isreal(A);
          op.sweepflag  = true;
          op.matrix = A;
       end % function opMatrix
      
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function str = char(op)
       %char  Create character array from operator.
          if isscalar(op)
             v = op.matrix;
             str = strtrim(evalc('disp(v)'));
          else
             str = char@opSpot(op);
          end          
       end % function char

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function x = double(op)
       %double  Convert operator to a double.
          x = op.matrix;
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function x = drandn(op)
       %drandn  pseudorandom vector in the domain of op
          x = drandn@opSpot(op);
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function x = rrandn(op)
       %drandn  pseudorandom vector in the domain of op
          x = rrandn@opSpot(op);
       end
       
    end % Methods


    methods ( Access = protected )
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function y = multiply(op,x,mode)
       %multiply  Multiply operator with a vector.
          if mode == 1
              y = op.matrix * x;
           else
              y = op.matrix' * x;
           end
       end % function multiply
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function x = divide(op,b,mode)
       %divide  Solve a linear system with the operator.
          if mode == 1
             x = op.matrix \ b;
          else
             x = op.matrix' \ b;
          end
       end % function divide

end % methods
   
end % Classdef
