% returnCode = 0 iff everything is ok, otherwise -1
% functionName WITHOUT suffix '.m'
function returnCode = createTargetFunction( functionMame, n )
    
    returnCode = -1;
    
    fileName = strcat(functionMame, '.m');
    
    fid = fopen( fileName, 'wt' );
    fprintf( fid, 'function f = %s ( x ) \n' , functionMame);
    fprintf( fid, 'f = double(' );
    
    for i = 1:n
        if(i>1)
            fprintf( fid, ' + '  );
        end
        fprintf( fid, 'x(%d)^2', i  );
    end
    
    fprintf( fid, ');\n'  );
    fprintf( fid, 'end'  );
    
    fclose(fid);
    returnCode = 0;
end

