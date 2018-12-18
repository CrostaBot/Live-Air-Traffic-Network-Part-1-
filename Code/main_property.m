close all
clear all
clc

%% Import data

G = importdata('dataset_1.txt', '\t', 4) 

%% Adjacency matrix

G.data = G.data + 1 
N = max(max(G.data)) 
A = sparse(G.data(:,2),G.data(:,1),ones(size(G.data,1),1),N,N) 
clear G 

%% Moments and average of the degree distribution 

% indegree 
indegree = full(sum(A,2)) 

mean_indegree = mean(indegree) 
second_moment_indegree = mean(indegree.^2) 
third_moment_indegree = mean(indegree.^3) 

% outdegree
outdegree = full(sum(A,1)) 

mean_outdegree = mean(outdegree) 
second_moment_outdegree = mean(outdegree.^2) 
third_moment_outdegree = mean(outdegree.^3) 

% print the results
disp(['Mean indegree = ' num2str(mean_indegree)]) 
disp(['Second moment indegree = ' num2str(second_moment_indegree)]) 
disp(['Third moment indegree = ' num2str(third_moment_indegree)]) 
disp(['Mean outdegree = ' num2str(mean_outdegree)]) 
disp(['Second moment outdegree = ' num2str(second_moment_outdegree)]) 
disp(['Third moment outdegree = ' num2str(third_moment_outdegree)]) 

%% Hub

disp(['Bigger hub indegree = ' num2str(max(indegree))]) 
disp(['Bigger hub outdegree = ' num2str(max(outdegree))]) 

% Airport with more links has been computed in live_air_traffic.py

%% Natural and structural cutoff

disp(['Natural cutoff indegree = ' num2str(max(indegree))]);
disp(['Natural cutoff outdegree = ' num2str(max(outdegree))]);
disp(['Structural cutoff = ' num2str(sqrt(N*mean_outdegree))]);

%% Inhomogeneity ratio

disp(['Inhomogeneity ratio indegree = ' num2str(second_moment_indegree/mean_indegree)]) 
disp(['Inhomogeneity ratio outdegree = ' num2str(second_moment_outdegree/mean_outdegree)]) 

%% Giant component

G = digraph(A) 

bins = conncomp(G) 
size_giant_component = hist(bins) 

% print the size of the giant component
disp(['Nodes of the giant component = ' num2str(max(size_giant_component))]) 

%% Distances

% Mean distance and diameter
distances = distances(G) 
mean_distance = mean(mean(distances(distances < Inf))) 
diameter = max(max(distances(distances < Inf))) 

% print the results
disp(['Average distance = ' num2str(mean_distance)]) 
disp(['Diameter = ' num2str(diameter)]) 
