
function print_All_MU_Duration_Statistics_ByAge(selection,MU_Data,options)
    
    % Calculate MU Amplitude
    [MU_PtP, ~] = loop_Over_Trials_FromTable(MU_Data,options.Analysis(1));
    MU_PtP.MU_Duration  = cell2mat(MU_PtP.MU_Duration);
    MU_PtP.MU_Duration  = 1000*MU_PtP.MU_Duration;
    
    % Merge tables
    MU_Data  = append_FileID_Tag(MU_Data,options);
    MU_PtP   = append_FileID_Tag(MU_PtP,options);
    
    if isequal(MU_Data.FileID_Tag,MU_PtP.FileID_Tag)
    	MU_Data = [MU_Data, MU_PtP(:,5)];
    end
    
    SID = MU_Data.SID(1); 
    
    ind = MU_Data.TargetForce == '100%MVC';
    MU_Data(ind,:) = [];
    
    % Median
    MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Duration','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','AgeCategory'});
    MU_Median = sortrows(MU_Median,{'SID','TargetForce_N'},{'ascend','ascend'});
     
    options.Plot = get_Plot_Options_Median_AbsoluteUnits();
    create_Figure_FromTable(MU_Median, options);  
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    % IQR
    MU_IQR = varfun(@iqr,MU_Data,'InputVariables','MU_Duration','GroupingVariables',{'SID','ArmType','ArmSide','TargetForce','TargetForce_N','AgeCategory'});
    MU_IQR = sortrows(MU_IQR,{'SID','TargetForce_N'},{'ascend','ascend'});
       
    options.Plot = get_Plot_Options_IQR_AbsoluteUnits();
    create_Figure_FromTable(MU_IQR, options);  
    print_FigureToWord(selection,['Subject = ' SID char(13)],'WithMeta')
    close(gcf);
    
    selection.InsertBreak;
end


function PlotOptions = get_Plot_Options_Median_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'AgeCategory'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7209    0.1551    0.1679    0.1012];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'median_MU_Duration'};
    PlotOptions.YLabel          = 'Median MU Duration (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All subjects: ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end


function PlotOptions = get_Plot_Options_IQR_AbsoluteUnits()

    PlotOptions.SubplotBy       = {'ArmType'}; 
    PlotOptions.GroupBy         = {'SID'};
    PlotOptions.ColorBy         = {'AgeCategory'};
    PlotOptions.Colors          = [];
    PlotOptions.AdditionalPlots = [];
    PlotOptions.LegendLocation  = [0.7352    0.7647    0.1679    0.1012];   
    PlotOptions.LineWidth       = 1.5;
    PlotOptions.LineStyle       = '-';
    PlotOptions.Marker          = 'o';
    PlotOptions.FontSize        = 12;
    PlotOptions.XVar            = {'TargetForce_N'};
    PlotOptions.XLabel          = 'TargetForce_N';
    PlotOptions.XLim            = [];
    PlotOptions.YVar            = {'iqr_MU_Duration'};
    PlotOptions.YLabel          = 'IQR MU Duration (mV)';
    PlotOptions.YLim            = [];
    PlotOptions.Title           = @(inputdata,options)['All subjects: ' char(inputdata.(options.Plot.SubplotBy{1})(1))] ;  
    PlotOptions.TitleSize       = 16; 
end
  
%     MU_Median = varfun(@median,MU_Data,'InputVariables','MU_Amplitude','GroupingVariables',{'TargetForce','TargetForce_N'});  
%     figure; 
%     [n0,x0] = hist(MU_Data.MU_Amplitude);
%     bar(x0,n0); hold on;
%     plot(x0,n0,'-o')
%    