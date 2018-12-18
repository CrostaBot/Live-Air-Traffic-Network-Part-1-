close all
clear all
clc

%% Import data

G = importdata('dataset_1.txt', '\t', 4)

%% Adjacency matrix

N = max(max(G.data))
A = sparse(G.data(:,2),G.data(:,1),ones(size(G.data,1),1),N,N)
Au = 1*(A+A'>0)  
clear G

% remove nodes which are NOT connected
pos = find(sum(Au)~=0) 
A = A(pos,pos) 
Au = Au(pos,pos) % remove nodes which are not connected 
N = size(A,1) 

% find the largest connected component
e1 = [1; zeros(N-1,1)] 
exit = false 
while(~exit)
    e1_old = e1 
    e1 = 1*(Au*e1+e1>0) 
    exit = (sum(e1-e1_old)==0) 
end
pos = find(e1) 
A = A(pos,pos) 
N = size(A,1) 


%% Assortativity

% degrees
d_in = sum(A,2) 
d_out = sum(A)' 

% averages of neighbours
k_oo = (A'*d_out)./d_out 
k_oi = (A'*d_in)./d_out 
k_ii = (A*d_in)./d_in 
k_io = (A*d_out)./d_in 

% extract averages
u_out = unique(d_out) 
for k = 1:length(u_out)
    k_nnoo(k) = mean(k_oo(d_out==u_out(k))) 
    k_nnoi(k) = mean(k_oi(d_out==u_out(k))) 
end
u_in = unique(d_in) 
for k = 1:length(u_in)
    k_nnio(k) = mean(k_io(d_in==u_in(k))) 
    k_nnii(k) = mean(k_ii(d_in==u_in(k))) 
end

% do the linear fittings
p = polyfit(log(u_out(2:end)'),log(k_nnoo(2:end)),1) 
disp(['Assortativity factor out-out ' num2str(p(1))])
p = polyfit(log(u_in(2:end)'),log(k_nnio(2:end)),1) 
disp(['Assortativity factor in-out ' num2str(p(1))])
p = polyfit(log(u_out(2:end)'),log(k_nnoi(2:end)),1) 
disp(['Assortativity factor out-in ' num2str(p(1))])
p = polyfit(log(u_in(2:end)'),log(k_nnii(2:end)),1) 
disp(['Assortativity factor in-in ' num2str(p(1))])

% plot
figure(1)
subplot(2,2,1)
loglog(d_out,k_oo,'.') 
hold on
loglog(u_out,k_nnoo,'r.') 
hold off
grid
xlabel('k_{out}')
ylabel('k_{nn,out}')
title('out --> out')
subplot(2,2,2)
loglog(d_out,k_oi,'.') 
hold on
loglog(u_out,k_nnoi,'r.') 
hold off
grid
xlabel('k_{out}')
ylabel('k_{nn,in}')
title('out --> in')
subplot(2,2,4)
loglog(d_in,k_ii,'.') 
hold on
loglog(u_in,k_nnii,'r.') 
hold off
grid
xlabel('k_{in}')
ylabel('k_{nn,in}')
title('in --> in')
subplot(2,2,3)
loglog(d_in,k_io,'.') 
hold on
loglog(u_in,k_nnio,'r.') 
hold off
grid
xlabel('k_{in}')
ylabel('k_{nn,out}')
title('in --> out')
