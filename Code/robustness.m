close all
clear all
clc

%% Import data

G = importdata('dataset_3.txt', '\t', 4) 

%% Adjacency matrix

G.data = G.data + 1 
N = max(max(G.data)) 
A = sparse(G.data(:,2),G.data(:,1),ones(size(G.data,1),1),N,N) 
clear G 

%% Robustness to random failure

G = digraph(A)

bins = conncomp(G);
size_giant_component = max(hist(bins)); 

prob_infinity_0 = size_giant_component/N
prob_infinity = zeros(1,N)

for i = 1:N
    remove_node = randi(numnodes(G))
    G = rmnode(G,remove_node)
    bins = conncomp(G);
    size_giant_component = max(hist(bins))
    prob_infinity(i) = size_giant_component/N
end

figure(1)
plot((1:N)/(N),(prob_infinity)/(prob_infinity_0), 'g')

%% Robustness to attacks

% indegree
G = digraph(A)

bins = conncomp(G);
size_giant_component = max(hist(bins)); 

prob_infinity_0 = size_giant_component/N
prob_infinity = zeros(1,N)

for i = 1:N
    tonii = indegree(G)
    [~, remove_node] = max(tonii)
    G = rmnode(G,remove_node)
    bins = conncomp(G);
    size_giant_component = max(hist(bins)) 
    prob_infinity(i) = size_giant_component/N 
end

figure(1)
hold on
plot((1:N)/(N),(prob_infinity)/(prob_infinity_0))

% outdegree
G = digraph(A)

bins = conncomp(G);
size_giant_component = max(hist(bins)); 

prob_infinity_0 = size_giant_component/N
prob_infinity = zeros(1,N)

for i = 1:N
    tonio = outdegree(G)
    [~, remove_node] = max(tonio)
    G = rmnode(G,remove_node)
    bins = conncomp(G);
    size_giant_component = max(hist(bins)) 
    prob_infinity(i) = size_giant_component/N 
end

figure(1)
hold on
plot((1:N)/(N),(prob_infinity)/(prob_infinity_0), 'r')
xlabel('f')
ylabel('p_{\infty}(f)/p_{\infty}(0)');
legend('Random failures','Attacks indegree','Attacks outdegree')
title('ROBUSTNESS')
