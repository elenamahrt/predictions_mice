function prefs = GeneratePreferences_EM(animal_type, ...
    animal_string, ...
    experiment_string, ...
    cell_string,...
    Model,...
    respStart,...
    respStop)
%
%function prefs = GeneratePreferences(animal_number,
%                                     experiment_letter,
%                                     cell_depth)
%
%   INPUT ARGUMENTS
%   animal_type         The type of animal used in the experiment.
%                       Example: 'bat' or 'mouse'
%   animal_string       The descriptor of the animal used for the experimental
%                       data, in string format.
%                       Example: '7'
%   experiment_string   The descriptor of the specific experiment used for the
%                       experimental data, in string format.
%                       Example: 'c'
%   cell_string         The descriptor of the cell used for the experimental data.
%                       The electrode depth is a good choice.
%                       Example: '1440'
%
%   OUTPUT ARGUMENTS
%   prefs               The preferences used throughout the Bat2Matlab
%                       execution.
%
%GeneratePreferences generates a structure containing all of the
%global preferences used throughout the execution of Bat2Matlab.

animal_type = num2str(animal_type);
animal_string= num2str(animal_string);
experiment_string= num2str(experiment_string);
cell_string= num2str(cell_string);
%Save the start and stop of the evoked response times
prefs.respStart = respStart;
prefs.respStop = respStop;

if exist('animal_type','var')
    %Test description
    
    if experiment_string =='1'
        experiment_string = 'a';
    elseif experiment_string =='2'
        experiment_string = 'b';
    elseif  experiment_string =='3'
        experiment_string = 'c';
    elseif  experiment_string =='4'
        experiment_string = 'd';
    elseif  experiment_string =='5'
        experiment_string = 'e';
    elseif experiment_string =='0'
        experiment_string = '';
    else
        error('experiment_string incorrectly specified')
    end
    
    prefs.animal_type = animal_type;
    prefs.animal_string = animal_string;
    prefs.experiment_string = experiment_string;
    prefs.cell_string = cell_string;
    prefs.invert_color = 0;
    
    %Path definitions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    basePath = 'C:\Users\emahrt\Documents\mice_predictions\';
    
    % Don't forget to check if the LowPass filter is on or
    %not! (In 'GenerateStimulus.m' script)
    
    stimPath = ['stimuli\' Model '\'];
    dataPath = 'data\';
    extractDataPath = 'data\extractedData\';
    
    prefs.bat2matlab_directory = basePath;
    
    if strmatch('Bat',animal_type)
        prefs.audio_directory = [prefs.bat2matlab_directory stimPath];
        base_batlab_data_path = [prefs.bat2matlab_directory dataPath];
    elseif strmatch('Mouse',animal_type)
        prefs.audio_directory = [prefs.bat2matlab_directory stimPath];
        base_batlab_data_path = [prefs.bat2matlab_directory dataPath];
    else
        error('Incorrect animal type specified in GeneratePreferences()');
    end
    prefs.Bat2Matlab_data_filepath = [prefs.bat2matlab_directory extractDataPath animal_type animal_string experiment_string '.mat'];
    prefs.raw_data_filepath = [base_batlab_data_path '' animal_type '' animal_string '\' animal_type animal_string experiment_string '.raw'];
    %    prefs.xml_data_filepath = [base_batlab_data_path '' animal_type '' animal_string '\' animal_type animal_string experiment_string '-alltests.xml'];
    prefs.output_data_filepath = [prefs.bat2matlab_directory '\Output\' animal_type '\' animal_type animal_string experiment_string '_' cell_string];
    prefs.output_data_filepath
    prefs.cache_dir = [prefs.output_data_filepath '\cache'];
    prefs.cell_id = [animal_type animal_string experiment_string '_' cell_string];
    prefs.cell_id4_plot = prefs.cell_id; prefs.cell_id4_plot(strfind(prefs.cell_id4_plot,'_')) = '.';
    prefs.pst_data_filepath = [base_batlab_data_path '\' animal_type '' animal_string '\' animal_type animal_string experiment_string '.pst'];
    
    %Generate the required directories for processing
    warning off
    mkdir(prefs.output_data_filepath);
    mkdir(prefs.cache_dir);
    warning on
end

prefs.speaker_calibration_file = 'speaker_calibration_8_27_06'; %This is a Matlab file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options used for speaker callibration and dB SPL normalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%20 micro-Pascals for dB SPL conversion
prefs.dB_SPL_ref = 0.00002;
%16-bit audio dynamic range
prefs.dbRange = 96.3296;
%Approximate maximum output of speaker in dB SPL
prefs.dbMax = 100;
%Approximate maximum output of speaker in dB SPL minus maximum dynamic range of 16 bit audio.
% prefs.dbMin = dbMax-dbRange;
prefs.dbMin = 0;
%This allows the setting of a threshold below which everything is set to zero.
prefs.model_data_dbMin = prefs.dbMin;
%Approximate maximum output of speaker in dB SPL\Hz
prefs.spectrogram_dbMax = 84.5665;
%Approximate maximum output of speaker in dB SPL\Hz minus maximum dynamic range of 16 bit audio.
prefs.spectrogram_dbMin = prefs.spectrogram_dbMax-prefs.dbRange;
% prefs.spectrogram_dbMin = 0;
%Decide whether to use absolute or relative color scaling when plotting the spectrogram.
prefs.spectrogram_absolute_scaling = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spectrogram calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The number of times to evaluate the spectrogram in the frequency domain.
prefs.spectrogram_freq_samples = 2^10; %Low numbers result in very low frequency resolution on spectrogram (think of as FFT size). big numbers take TONS of memory
%The density of sampling in the time domain
% prefs.spectrogram_time_samples_per_millisecond = 1\2;
% prefs.spectrogram_time_samples_per_millisecond = 2;
prefs.spectrogram_time_samples_per_millisecond = 5;
%Frequency range for spectrogram
prefs.spectrogram_range = [0 120000];
%Window length (in seconds)
% prefs.spectrogram_window_length = 0.0001;
% prefs.spectrogram_window_length = 0.0005;
% prefs.spectrogram_window_length = 0.0015; %Happy medium? Default
prefs.spectrogram_window_length = 0.002; %Best so far
% prefs.spectrogram_window_length = 0.0025;
% prefs.spectrogram_window_length = 0.003;
% prefs.spectrogram_window_length = 0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Time calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.spike_time_filter_cutoff = 50000; %600;
prefs.spike_time_power_exponent = 2;
prefs.spike_time_peak_threshold = 0.11; %Default
prefs.spike_time_refractory_period = 2.0;%0.7; %Milliseconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Rate calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.spike_rate_sampling_frequency = NaN; %defaults to trace.samplerate_ad;
prefs.spike_rate_sampling_frequency = 8000;
prefs.spike_rate_cutoff_frequency = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for spectrogram peak finding calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.num_harmonics = 6;
%Peak detection noise floor as a fraction of the highest peak
prefs.harmonic_peak_detection_noise_floor = 0.2;
prefs.frequency_cutoff_ratio = 175; %Higher values smooth more

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for model data generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.model_num_data_rows_per_cell = 2^7;
prefs.model_time_samples_per_millisecond = 1/2; %Default = no idea why, but for a 4 ms time bin, this need to be '1/4'. for 0.5 ms time bin this needs to be '1/2'
% prefs.model_time_samples_per_millisecond = 1; %Default
prefs.model_spectral_integration = 0; %0:Rectangular 1:Gaussian

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Histogram generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prefs.histogram_bin_width = 1;
prefs.histogram_bin_width = 2; %Default
% prefs.histogram_bin_width = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for the calculation of the frequency intervals to integrate over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.max_interval_width = 4000;
prefs.default_intervals = [10000:2000:98000 ; 12000:2000:100000]';
prefs.default_sampled_frequencies = [11000:2000:99000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for harmonic peak calculation as a fraction of the highest peak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for VR metric calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.exponential_decay = 10; %Milliseconds
%The sample frequency of the signal reconstituted from thespike times
prefs.filtered_exponential_sample_frequency = 1000; %Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Options for Spike Train Filtering (Gaussian kernal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prefs.filtered_gaussian_sample_frequency = 1000; %Hz
% prefs.filtered_gaussian_stdev = 2; %In milliseconds
prefs.filtered_gaussian_stdev = 3; %In milliseconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Global options for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note: Calling the colormap functions creates a figure if there is not
%already one created. Here we check to see if a figure exists already.
%If not, delete the figure generated by the colormap function.
figure_exists = get(0,'CurrentFigure');
prefs.force_plot_visible = true;
prefs.colormap = jet;prefs.colormap_name = 'jet';
% prefs.colormap = hot;prefs.colormap_name = 'hot';
% prefs.colormap = gray;prefs.colormap_name = 'gray';
% prefs.colormap = gray;prefs.colormap_name = 'bone';
% prefs.colormap = parula;prefs.colormap_name = 'parula';
% prefs.colormap = flipud(prefs.colormap); %Use this to reverse colormap
% prefs.colormap = brighten(prefs.colormap, .3); %to make colors brighter, # should be 0 to 1; to make darker # should be -1 to 0
if isempty(figure_exists)
    close;
end
