%% Pre-processing
clear all
clc
close all

addpath ../../../Utilities
addpath ../../../Utilities/modeling

%% Run
Hunchback;
Kruppel;
Giant;
Knirps;

%% Plot results
save_plots = 0;
PlotResults_gap_gene;

%% Post-processing
rmpath ../../../Utilities
rmpath ../../../Utilities/modeling