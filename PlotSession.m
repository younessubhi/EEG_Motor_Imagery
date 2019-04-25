N = 4

figure(1)
for k = 1:N
    subplot(N,1,k)
    plot(FullsingleData.SessionStream(:,k))
end