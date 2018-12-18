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

tf = issymmetric(A)

if (tf == 1)
    disp('Matrix is symmetric')
else
    disp('Matrix is asymettric')
end

figure(1)
spy(A)
