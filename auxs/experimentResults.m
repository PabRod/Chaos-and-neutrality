classdef experimentResults < handle
    %EXPERIMENTRESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = private)
        
        id; % Experiment id
        
        %% Time seriess
        ts; % Times
        ys; % States
        
        %% Problem parameters
        predation_Matrix;
        competition_Matrix;
        competition_par; % Parameter used for generating the random competition matrix
        
        %% Simulation parameters
        stabil_time;
        
        %% Chaos indicators
        lyap_time; % Numerical time for computing the Lyapunov exponent
        lyap_pert; % Initial perturbation for computing the Lyapunov exponent
        max_Lyapunov_results; % Results of the maximum Lyapunov exponent test
        max_Lyapunov; % Value of the maximum Lyapunov exponent
        
        z1_results; % Results of the z1 test
        z1_par = NaN; % Parameter of the z1 test
        p;
        q;
        
    end
    
    properties(Access = private)
       
        chaos_tests_results = {'Undecisive', 'Constant', 'Cyclic', 'Chaotic'};
        
    end
    
    methods(Access = public, Hidden = true)
        
        function obj = experimentResults(idIn, tsIn, ysIn, predation_MatrixIn, ... 
                competition_MatrixIn, competition_parIn, stabil_timeIn, ... 
                lyap_timeIn, lyap_pertIn, max_LyapunovIn)
            % Main constructor
            obj.id = idIn;
            
            obj.ts = tsIn;
            obj.ys = ysIn;
            
            obj.predation_Matrix = predation_MatrixIn;
            obj.competition_Matrix = competition_MatrixIn;
            obj.competition_par = competition_parIn;
            
            obj.stabil_time = stabil_timeIn;
            
            obj.lyap_time = lyap_timeIn;
            obj.lyap_pert = lyap_pertIn;
            obj.max_Lyapunov = max_LyapunovIn;
            
        end
        
    end
    
    methods(Access = public)
        
        function [n_Preys, n_Preds] = Dims(this)
            % Returns the dimensions of the system
            n_Preys = size(this.predation_Matrix, 2);
            n_Preds = size(this.predation_Matrix, 1);
        end
        
        function steps = TimeSteps(this)
            % Returns the simulation's time steps
            steps = numel(this.ts);
        end
        
        function ExecuteChaosTests(this)
           this.MaxLyapResults;
           this.z1Results;
        end
        
        function ResetChaosTests(this)
            this.max_Lyapunov_results = [];
            this.z1_results = [];
            this.z1_par = NaN;
        end
        
        function [res, maxLyap] = MaxLyapResults(this)
            if isnan(this.max_Lyapunov)
                
                this.max_Lyapunov_results = this.chaos_tests_results{1}; % Undecisive if NaN
                
            elseif isempty(this.max_Lyapunov_results) % Execute only if not done before
                
                if this.max_Lyapunov > 0
                    this.max_Lyapunov_results = this.chaos_tests_results{4}; % Chaotic
                else
                    this.max_Lyapunov_results = this.chaos_tests_results{2}; % Constant
                end
                
            end
            
            res = this.max_Lyapunov_results;
            maxLyap = this.max_Lyapunov;
        end
        
        function [res, k, p, q] = z1Results(this)
            
            if isempty(this.z1_results)
                resStruct = z1test(this.ys);
                this.z1_results = resStruct.disp;
                this.z1_par = resStruct.k;
                if ~strcmp(resStruct.disp, 'Constant')
                   this.p = resStruct.p;
                   this.q = resStruct.q;
                else
                    this.p = NaN;
                    this.q = NaN;
                end
            end
            
            res = this.z1_results;
            k = this.z1_par;
            p = this.p;
            q = this.q;
            
        end
        
        function PlotTimeSeries(this)
            % Plots all time series
            plot(this.ts, this.ys);
        end
        
        function PlotZ1Results(this)
            plot(this.p, this.q);
        end
        
    end
    
end