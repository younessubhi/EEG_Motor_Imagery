%% by Paula Sanchez Lopez (2019)

% Prepare environment
clc;clear;close all

cd C:\experiment % windows specific

warning('off', 'Images:initSize:adjustingMag');
figure('units','normalized','outerposition',[0 0 1 1]);
imshow('Start.png')

pause(10)

runtimer = timer;
runtimer.StartDelay = 0;
runtimer.StartFcn = @initTimer;
runtimer.TimerFcn = @wholerun;
runtimer.Period = 128;
runtimer.TasksToExecute = 1;
runtimer.ExecutionMode = 'fixedRate';

diary off
diary Subject01

elapsedtime = tic;

start(runtimer)
wait(runtimer)
pause(9)
delete(runtimer)

toc(elapsedtime)

diary off
disp('Finished')


function wholerun(src, event)

src.UserData = src.UserData + 1;

t1 = timer;
t2 = timer;
t3 = timer;

t2.StartDelay = 2;
t3.StartDelay = 6;

t1.StartFcn = @(~,thisEvent)disp(['Start run ' num2str(src.UserData) ' at '...
    datestr(thisEvent.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);

t1.TimerFcn = @(~,~)imshow('Cross.png');
t2.TimerFcn = @trial;
t3.TimerFcn = @(~,~)imshow('Rest.png');

t3.StopFcn = @endofrun;

t1.Period = 8;
t2.Period = 8;
t3.Period = 8;

trialsPerRun = 1;
t1.TasksToExecute = trialsPerRun;
t1.ExecutionMode = 'fixedRate';
t2.TasksToExecute = trialsPerRun;
t2.ExecutionMode = 'fixedRate';
t3.TasksToExecute = trialsPerRun;
t3.ExecutionMode = 'fixedRate';

rng(src.UserData)
start(t1)
start(t2)
start(t3)
%wait(t1)
%wait(t2)
%wait(t3)
%delete(t1)
%delete(t2)
%delete(t3)
end

function initTimer(src, event)
src.UserData = 0;
disp('Start run')
end

function trial(src, event)
cues = {'Task1.PNG','Task2.PNG','Task3.PNG','Task4.PNG'};
imshow(cues{randi([1 4],1,1)})
end

function endofrun(src,event)
disp(['End run at '...
    datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')])
imshow('2break.png')
pause(100)
imshow('Start.png')
end
