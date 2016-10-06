% Demo to extract frames and get frame means from a movie
% and save individual frames to separate image files.
% Then rebuilds a new movie by recalling the saved images from disk.
% Also computes the mean gray value of the color channels.
% And detects the difference between a frame and the previous frame.
% Illustrates the use of the VideoReader and VideoWriter classes.

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.).
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 22;

%% 
movieFullFileName = 'FILE0003-0.7_edit.mp4';
try
	videoObject = VideoReader(movieFullFileName);
	% Determine how many frames there are.
	numberOfFrames = videoObject.NumberOfFrames;
	vidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	% Prepare a figure to show the images in the upper half of the screen.
	figure;
	% 	screenSize = get(0, 'ScreenSize');
	% Enlarge figure to full screen.
	set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
	
	% Ask user if they want to write the individual frames out to disk.
	promptMessage = sprintf('Do you want to save the individual frames out to individual disk files?');
	button = questdlg(promptMessage, 'Save individual frames?', 'Yes', 'No', 'Yes');
	if strcmp(button, 'Yes')
		writeToDisk = true;
		
		% Extract out the various parts of the filename.
		[folder, baseFileName, extentions] = fileparts(movieFullFileName);
		% Make up a special new output subfolder for all the separate
		% movie frames that we're going to extract and save to disk.
		% (Don't worry - windows can handle forward slashes in the folder name.)
		folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
		outputFolder = sprintf('%s/Movie Frames from %s', folder, baseFileName);
		% Create the folder if it doesn't exist already.
		if ~exist(outputFolder, 'dir')
			mkdir(outputFolder);
		end
	else
		writeToDisk = false;
	end
	
	% Loop through the movie, writing all frames out.
	frame = 1;
	while frame <= numberOfFrames
		% Extract the frame from the movie structure.
		thisFrame = read(videoObject, frame,'Native');
		frame = frame + 1;
		% Display it
		hImage = subplot(2, 2, 1);
		image(thisFrame);
		caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
		title(caption, 'FontSize', fontSize);
		drawnow; % Force it to refresh the window.
		
		% Write the image array to the output file, if requested.
		if writeToDisk
			% Construct an output image file name.
			outputBaseFileName = sprintf('Frame %4.4d.png', frame);
			outputFullFileName = fullfile(outputFolder, outputBaseFileName);
			
		
			frameWithText = getframe(gca);
		
			imwrite(frameWithText.cdata, outputFullFileName, 'png');
		end
		
	
	
	
	
	% Exit if they didn't write any individual frames out to disk.
	if ~writeToDisk
		return;
	end
	


end
catch ME
	% Some error happened if you get here.
	strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end