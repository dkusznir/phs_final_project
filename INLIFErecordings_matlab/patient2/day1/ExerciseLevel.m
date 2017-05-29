clear all;
clc;
%% Read Data & Print their ranges
[x, y] = read_data('Data_ActivityRawType.csv');
[m, n] = read_data('Data_ActivityStepsPerMinute.csv');
[p, q] = read_data('Data_HeartRate.csv');

x = fix(x/1000);
m = fix(m/1000);
p = fix(p/1000);

x_min = int32(x(1));
x_max = int32(x(length(x)));
m_min = int32(m(1));
m_max = int32(m(length(m)));
p_min = int32(p(1));
p_max = int32(p(length(p)));
str = ['x_min ';'x_max ';'m_min ';'m_max ';'p_min ';'p_max '];
num = num2str([x_min;x_max;m_min;m_max;p_min;p_max]);
range = [str,num]

%% Data Check & Correction
gap = x(2)-x(1)
for ii = 3:length(x)
    if x(ii)-x(ii-1) == gap
        
    else
        fprintf('Something Wrong! At timestamp %d\tNo. %d\n',x(ii),find(x==x(ii)));
        fprintf('%d\t%d\n',x(ii-1),x(ii));
        y = y';
        num_add = fix((x(ii)-(x(ii-1)))/gap)+1;
        y_debug = [y(1:ii-1),zeros(1,num_add-1)+7,y(ii:length(y))];
        y = y_debug';
        x = x';
        diff = x(ii-1)+gap*num_add-x(ii);
        x_debug = [x(1:ii-1),(x(ii-1)+gap):gap:x(ii)-gap+diff,x(ii:length(x))+diff];
        x = x_debug';
        m = m+39;
        p = p+39;
    end
end

%% Reset Undefined Ex-Level
X = [1:length(x)];
A = find(y>6);
y(A,1)=7;

%% HR file Reshape
% Calculate corresponding number of samples in Ex-Level
temp_1 = X(min(find(x>p(1))));
temp_2 = length(x);
num_sam = temp_2-temp_1;
HR_step = fix(length(p)/num_sam);
Q = zeros(1,num_sam);
for ii = 1:num_sam
    Q(ii) = mean(q((ii*HR_step-HR_step+1):ii*HR_step));
end
Q = [zeros(1,temp_1),Q,zeros(1,length(X)-temp_1-length(Q))];
Q = Q';

%% Ex-Level Plot & HR calculation corresponding to different levels
subplot(4,1,1);
b = [0,6,6,0];
HR_sum = zeros(8,1);
HR = zeros(8,2);
HR(:,1) = [0:7];
counter = 0;
for ii=0:7
    B = find(y==ii);
    str = {'Red1';'Red3';'Red5';'LightYellow';'DarkBlue';'LightBlue';'LightGreen';'White'};
    for jj = 1:length(B)
        if B(jj) == X(length(X))
            
        else
            a = [X(B(jj)),X(B(jj)),X(B(jj)+1),X(B(jj)+1)];
            figure (1);
            c = fill(a,b,rgb(str(ii+1,:)));
            hold on;
            set(c,'EdgeColor','None');
            % find corresponding HR
            HR_temp = Q(X(B(jj)));
            if HR_temp == 0
                
            else
                HR_sum(ii+1) = HR_sum(ii+1)+Q(X(B(jj)));
                counter = counter+1;
            end
        end
    end
    HR(ii+1,2) = fix(HR_sum(ii+1)/counter);
    counter = 0;
end

%%-------------------------------------------------------------------------
%% Day-Night Label Plot
temp = fix(4*length(X)/12);
a = [0,0,temp,temp];
b = [6,7,7,6];
c = fill(a,b,rgb('MidnightBlue'));
set(c,'EdgeColor','None');
text(5,6.5,'Night','FontSize',20,'Color','white');
text(temp+5,6.5,'Day','FontSize',20);
temp = fix(10*length(X)/12);
a = [temp,temp,length(x),length(x)];
c = fill(a,b,rgb('MidnightBlue'));
set(c,'EdgeColor','None');
text(5,6.5,'Night','FontSize',20,'Color','white');

%%-------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% x-Axis
xlim([1,length(x)]);
name = {'10:00PM','2:00AM','6:00AM','10:00AM','2:00PM','6:00PM','10:00PM'};
step = fix(length(X)/6);
kk = 1:7;
value = [1,kk*step];
set(gca,'XTick',value,'XTickLabel',name,'XGrid','on');
%%-------------------------------------------------------------------------

%% Step Plot
% Set Step plot x-range
temp_1 = X(min(find(x>m(1))));
temp_2 = X(max(find(x<=m(length(m)))));
M = [X(temp_1):(X(temp_2)-X(temp_1))/(length(m)-1):X(temp_2)];
M = M';
% make a plot
nn = n/(max(n)/6);
stairs(M,nn,'b');
% y-Axis
ylim([0,7]);
grid on;
set(gca,'YAxisLocation','right');
set(gca,'YTick',[0:7],'YTickLabel',[0:20:140],'YGrid','on');

%%-------------------------------------------------------------------------
%% Labels
xlabel('time','FontSize',15);
ylabel('steps','FontSize',15);
title('Patient2 10/31/2016-11/01/2016 Record','FontSize',15);
%%-------------------------------------------------------------------------

%% plot separate figures
% Ex-Level
subplot(4,1,2);
b = [0,6,6,0];
for ii=0:7
    B = find(y==ii);
    for jj = 1:length(B)
        if B(jj) == X(length(X))
            break;
        else
            a = [X(B(jj)),X(B(jj)),X(B(jj)+1),X(B(jj)+1)];
            figure (1);
            c = fill(a,b,rgb(str(ii+1,:)));
            hold on;
            set(c,'EdgeColor','None');
        end
    end
end
%%-------------------------------------------------------------------------
temp = fix(4*length(X)/12);
a = [0,0,temp,temp];
b = [6,7,7,6];
c = fill(a,b,rgb('MidnightBlue'));
set(c,'EdgeColor','None');
text(5,6.5,'Night','FontSize',20,'Color','white');
text(temp+5,6.5,'Day','FontSize',20);
temp = fix(10*length(X)/12);
a = [temp,temp,length(x),length(x)];
c = fill(a,b,rgb('MidnightBlue'));
set(c,'EdgeColor','None');
text(5,6.5,'Night','FontSize',20,'Color','white');
xlabel('time','FontSize',15);
ylabel('Exercise Level','FontSize',15);
%%-------------------------------------------------------------------------
xlim([1,length(x)]);
set(gca,'XTick',value,'XTickLabel',name,'XGrid','on');
ylim([0,7]);
grid on;
set(gca,'YAxisLocation','left');
set(gca,'YTick',[0:7],'YTickLabel',[0:7],'YGrid','on');

% Step
subplot(4,1,3);
stairs(M,nn,'b');
xlim([1,length(x)]);
set(gca,'XTick',value,'XTickLabel',name);
ylim([0,7]);
set(gca,'YAxisLocation','right');
set(gca,'YTick',[0:7],'YTickLabel',[0:20:140]);
%%-------------------------------------------------------------------------
xlabel('time','FontSize',15);
ylabel('steps','FontSize',15);
%%-------------------------------------------------------------------------

% HR
subplot(4,1,4);
plot(X,Q);
xlim([1,length(x)]);
set(gca,'XTick',value,'XTickLabel',name);
%%-------------------------------------------------------------------------
xlabel('time','FontSize',15);
ylabel('HR (beats/min)','FontSize',15);
%%-------------------------------------------------------------------------