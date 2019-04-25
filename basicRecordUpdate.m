%	An update on BASICRECORD script by Adnan Vilic (January 2013)
%   , updated by Alexander B. Kristensen (2019) for the
%	purpose of conducting consecutive measurements on the same subject.
%   
%   A folder is created for the subject and a filename is given as
%   '.../trial#.mat' based on present files available in the folder. The
%   value of '#' is an increment of the largest numbered file already found
%   in the folder. Data is saved to the filename. The purpose is to reduce
%   the risk of overwriting a trial from the same subject.
%   A time stamp is created at the beginning and the end of the
%   measurement. Total measurement period equals to /time - 1 second/
%   
%   the 'subject' variable has to be manually updated to avoid overwriting
%   files from other subjects.
%
%   
%   Younes Subhi (2019)



%% File saving info 
clear all;
subject = 'TEST123';
root = strcat('recordings/',subject,'/');    % Root folder for file saving

% Create subject folder if it doesn't exist
if ~exist(root, 'dir')
    mkdir(root);
end

% Create filename in subject folder with number increment of the previous

trialNum = 1;
filename = strcat(root,'trial',num2str(trialNum),'.mat');

while exist(filename)
    trialNum = trialNum+1;
    filename = strcat(root,'trial',num2str(trialNum),'.mat');
end
%% Main application
[ai,samplerate] = initUSBampOnlineUpdate();       % Initialize
sessionStream = [];                         % EEG is stored in this vector
durationPerTrial = 5;                       % Seconds per tick on amp


% stamp beginning time
stamptime = clock

% Ignore first two seconds because of noise when amp is initialized
fprintf('Skipping two first seconds due to noise\n')
while ai.SamplesAcquired < samplerate*2
end
toignore = getdata(ai,samplerate);
fprintf('..Starting real aquisition...\n')
    
% Recording from here on

r=0;
while r<durationPerTrial
   while ai.SamplesAcquired < samplerate*2
   end
   sessionStream = [sessionStream; getdata(ai,samplerate)];
   r= r+1;
   fprintf('sec: %d\n',r);
end

% stamp end time
stoptime = clock
    
% sessionStream = [sessionStream singleData];

fprintf('Recording Finished...\n')
currenttime = datestr(datevec(now),0);  % Timestamp for when recording finished

%% Saving file
FullsingleData = struct('Filename',   filename, ...
    'Subjectname',              '...', ...
    'SamplingFrequency',        samplerate, ...
    'Timestamp',                currenttime, ...
    'SessionStream',            sessionStream);

save(filename, 'FullsingleData');
fprintf('File saved. All done! \n')