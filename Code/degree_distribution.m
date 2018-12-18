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

%% Indegree distribution

% distribution
d = full(sum(A,1))
d = d(d>0)
k = unique(d)
pk = histc(d,k)
pk = pk/sum(pk)

% cumulative distribution
Pk = cumsum(pk,'reverse') 

% log binning
klog = 10.^(0:0.1:ceil(log10(max(k)))) 
pklog = histc(d,klog)' 
pklog = pklog/sum(pklog)  

% plot
figure(1)
subplot(1,2,1)
set(gcf, 'Position', [700, 300, 700, 300])
loglog(k,pk,'.')
grid
xlabel('k')
ylabel('PDF')
title('LINEAR BINNING')
subplot(1,2,2)
loglog(k,Pk,'.')
grid
xlabel('k')
ylabel('CCDF')
title('CUMULATIVE')

%% ML fitting indegree distribution

kmin = 8
d2 = d(d>=kmin)  
gamma_in = 1+1/mean(log(d2/kmin)) 
disp(['gamma ML = ' num2str(gamma_in)])

% plot
figure(1)
subplot(1,2,1)
set(gcf, 'Position', [700, 300, 700, 300])
hold on
s1 = k.^(-gamma_in)  
loglog(k,s1/s1(15)*pk(15)) 
hold off
axis([xlim min(pk/2) 2*max(pk)])
subplot(1,2,2)
hold on
s1 = k.^(1-gamma_in)  
loglog(k,s1/s1(35)*Pk(35)) 
hold off
axis([xlim min(Pk/2) 2])

%% Outdegree distribution

% distribution
d = full(sum(A,2))
d = d(d>0)
k = unique(d)
pk = histc(d,k)
pk = pk/sum(pk)

% cumulative distribution
Pk = cumsum(pk,'reverse') 

% log binning
klog = 10.^(0:0.1:ceil(log10(max(k)))) 
pklog = histc(d,klog)' 
pklog = pklog/sum(pklog)  

% plot
figure(2)
subplot(1,2,1)
set(gcf, 'Position', [700, 300, 700, 300])
loglog(k,pk,'.')
grid
xlabel('k')
ylabel('PDF')
title('LINEAR BINNING')
subplot(1,2,2)
loglog(k,Pk,'.')
grid
xlabel('k')
ylabel('CCDF')
title('CUMULATIVE')

%% ML fitting outdegree distribution

kmin = 13 
d2 = d(d>=kmin)  
gamma_out = 1+1/mean(log(d2/kmin)) 
disp(['gamma ML = ' num2str(gamma_out)])

% plot
figure(2)
subplot(1,2,1)
set(gcf, 'Position', [700, 300, 700, 300])
hold on
s1 = k.^(-gamma_out)  
loglog(k,s1/s1(20)*pk(20)) 
hold off
axis([xlim min(pk/2) 2*max(pk)])
subplot(1,2,2)
hold on
s1 = k.^(1-gamma_out) 
loglog(k,s1/s1(33)*Pk(33)) 
hold off
axis([xlim min(Pk/2) 2])
