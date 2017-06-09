% returnCode = 0 iff everything is ok, otherwise -1
% functionName WITHOUT suffix '.m'
% 
% function [c,ceq] = circlecon(x)
% c = x(1) + x(2) + x(3) - 1;
% ceq = [];
%
function returnCode = createConFunction( functionMame, n )
    
    returnCode = -1;
    
    fileName = strcat(functionMame, '.m');
    
    fid = fopen( fileName, 'wt' );
    fprintf( fid, 'function [c,ceq] = %s ( x ) \n' , functionMame);
    fprintf( fid, 'c = double([' );
    
    for i = 1:n
        if(i>1)
            fprintf( fid, ' + '  );
        end
        fprintf( fid, 'x(%d)', i  );
    end
    
    fprintf( fid, '-1'  );
    fprintf( fid, ']);\n'  );
    fprintf( fid, 'ceq = double([]);\n'  );
    fprintf( fid, 'end'  );
    
    fclose(fid);
    returnCode = 0;
end

