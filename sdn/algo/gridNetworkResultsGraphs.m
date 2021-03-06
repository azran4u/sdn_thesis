function [runTimeHandler, revenueHandler] = gridNetworkResultsGraphs(results)
    
    x = unique(results.numOfRcv);
    
    lbsRunTimeArray = [];
    llvsRunTimeArray = [];
    
    lbsRevenueArray = [];
    llvsRevenueArray = [];
    
    for n = 1 : length(x)
        xi = x(n);
        rows = results.numOfRcv == xi;
        vars = {'rep','lbsResults','llvsResults'};
        t = results(rows,vars);
        
        lbsRunTime = t.lbsResults.runTime;        
        llvsRunTime = t.llvsResults.runTime;
                
        lbsRunTimeArray = [lbsRunTimeArray ; [xi; min(lbsRunTime); max(lbsRunTime); mean(lbsRunTime)]'];
        llvsRunTimeArray = [llvsRunTimeArray ; [xi; min(llvsRunTime); max(llvsRunTime); mean(llvsRunTime)]'];
        
        lbsTotalRevenue = t.lbsResults.totalRevenue;
        llvsTotalRevenue = t.llvsResults.totalRevenue;
        
        lbsRevenueArray = [lbsRevenueArray ; [xi; min(lbsTotalRevenue); max(lbsTotalRevenue); mean(lbsTotalRevenue)]'];
        llvsRevenueArray = [llvsRevenueArray ; [xi; min(llvsTotalRevenue); max(llvsTotalRevenue); mean(llvsTotalRevenue)]'];
    end
    
    numberOfRequests = lbsRunTimeArray(:,1);
    
    runTimeHandler = figure('Color','white');
    plot(numberOfRequests, lbsRunTimeArray(:,4),'-.r*', numberOfRequests, llvsRunTimeArray(:,4));
%     title('Run time as a function of #requests');
    xlabel('Number of requests');
    ylabel('Run Time [sec]');
    legend({'LBS','LLVS'},'Location','northwest');
    
    revenueHandler = figure;
    plot(numberOfRequests, lbsRevenueArray(:,4), '-.r*', numberOfRequests, llvsRevenueArray(:,4));
%     title('Revenue as a function of #requests');
    xlabel('Number of requests');
    ylabel('Revenue');
    legend({'LBS','LLVS'},'Location','northwest');
end

