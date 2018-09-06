function [] = diagrams(results)

    x = results.gridSize';
    y = [results.LLVSrunTime results.LBSLSrunTime];
    bar(x,y);
    legend('LLVS','LBSLS');
    xlabel('Number of nodes');
    ylabel('run time [sec]');
    
    N=512;    
    LBSLSaverageHistogram = [(1:N)' , zeros(N,1) , zeros(N,1), zeros(N,2)];
    for row = 1:height(results)
        A = results(row, :).LBSLSdetails.details{1,1};
        A = sortrows(A,[2 3 1]);
        while ~isempty(A)
            stream = A.ck==A.ck(1) & A.lk==A.lk(1);    
            stream = stream(stream>0);
            stream = stream.*(1:size(stream,1))';
            LBSLSaverageHistogram(stream,2) = LBSLSaverageHistogram(stream,2) + 1;
            LBSLSaverageHistogram(stream,3) = (LBSLSaverageHistogram(stream,3) + A.requestRunTime(stream))./LBSLSaverageHistogram(stream,2);
            A([stream],:) = [];
        end
    end
    
    LLVSaverageHistogram = [(1:N)' , zeros(N,1) , zeros(N,1), zeros(N,2)];
    for row = 1:height(results)
        A = results(row, :).LLVSdetails.details{1,1};
        A = sortrows(A,[2 3 1]);
        while ~isempty(A)
            stream = A.ck==A.ck(1) & A.lk==A.lk(1);    
            stream = stream(stream>0);
            stream = stream.*(1:size(stream,1))';
            LLVSaverageHistogram(stream,2) = LLVSaverageHistogram(stream,2) + 1;
            LLVSaverageHistogram(stream,3) = (LLVSaverageHistogram(stream,3) + A.requestRunTime(stream))./LBSLSaverageHistogram(stream,2);
            A([stream],:) = [];
        end
    end
    
    %unifiedHistogram = [LLVSaverageHistogram(:,1), LBSLSaverageHistogram(:,3), LLVSaverageHistogram(:,3)];
    x=LLVSaverageHistogram(:,1);
    LBSLSrunTime = LBSLSaverageHistogram(:,3);
    LLVSrunTime = LLVSaverageHistogram(:,3);
    figure;
    plot(x(LBSLSrunTime>0),LBSLSrunTime(LBSLSrunTime>0),x(LLVSrunTime>0),LLVSrunTime(LLVSrunTime>0));
    xlabel('order of request');
    ylabel('run time [sec]');
    legend('LBSLS','LLVS');
end

