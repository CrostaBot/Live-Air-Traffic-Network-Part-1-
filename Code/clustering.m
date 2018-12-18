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

%% Clustering distribution

% clustering coefficient indegree
indegree = full(sum(A,2))
L_indegree = diag(A*triu(A)*A)
C_indegree = zeros(1,N)
C_indegree(indegree>1) = L_indegree(indegree>1)./(2*indegree(indegree>1).*(indegree(indegree>1)- 1))

% clustering coefficient outdegree
outdegree = full(sum(A,1))
outdegree = (outdegree')
L_outdegree = diag(A*triu(A)*A)
C_outdegree = zeros(1,N)
C_outdegree(outdegree>1) = L_outdegree(outdegree>1)./(2*outdegree(outdegree>1).*(outdegree(outdegree>1)-1))

% print
disp(['Mean indegree clustering coefficient = ' num2str(mean(C_indegree(indegree>1)))])
disp(['Mean oudegree clustering coefficient = ' num2str(mean(C_outdegree(outdegree>1)))])

% plot
figure(1) 
subplot(1,2,1) 
grid on 
loglog(indegree, C_indegree, '.') 
hold on  
plot(indegree, mean(C_indegree(indegree>1))*ones(1,N),'-k') 
xlim([min(indegree),max(indegree)]) 
ylabel('C') 
xlabel('k') 
title('Indegree clustering coefficient ') 
subplot(1,2,2) 
grid on 
loglog(outdegree, C_outdegree, '.') 
hold on  
plot(outdegree, mean(C_outdegree(outdegree>1))*ones(1,N),'-k') 
xlim([min(outdegree),max(outdegree)]) 
ylabel('C') 
xlabel('k') 
title('Outdegree clustering coefficient') 
set(gcf, 'Position', [700, 300, 700, 300]) 
