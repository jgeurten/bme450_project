%Shot 4 
launch_params = [8.858 2.8 .38 -6.13 0.464]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')


% Shot 6
launch_params = [9.253, 3.0374, 0.3043	-14.494	0.469]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')




% Shot 8
launch_params = [8.36, 2.9324, 0.6625 -7.854	0.474]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')

% Shot 10
launch_params = [6.264, 3.9898, 1.911	-14.837	0.553]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')


% Shot 11
launch_params = [7.236, 3.3389, 2.759	-17.885	0.460]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')


%Shot 15:
launch_params = [8.236, 2.3389, 0.859 25.885 0.224]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')

%Shot 17 
launch_params = [10.172 1.707 1.8091 -53.86 0.158]; 
[x, final,t] = simPuckTrajectory(launch_params);

figure, plot3(x(1:final,4), x(1:final, 5), x(1:final,6), 'LineWidth', 3)
ylim([0 2])
xlabel('Forward Distance (m)')
ylabel('Vertical Distance (m)')
zlabel('Side Distance (m)')





