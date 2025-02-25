function dtmf_remote_control_gui()
    % Create the main GUI window for the DTMF Remote Control System
    main_window = uifigure('Name', 'DTMF Remote Control System', 'Position', [100, 100, 500, 400]);

    % Define the DTMF keypad layout
    dtmf_keypad = {'1', '2', '3'; '4', '5', '6'; '7', '8', '9'; '*', '0', '#'};
    
    % Create buttons for the DTMF keypad
    for row = 1:4
        for col = 1:3
            key = dtmf_keypad{row, col};
            uibutton(main_window, 'Text', key, 'Position', [50 + (col-1)*80, 300 - (row-1)*60, 60, 50], ...
                'ButtonPushedFcn', @(~, ~) generate_dtmf_tone(key));
        end
    end

    % Add a button to decode an audio file
    decode_button = uibutton(main_window, 'Text', 'Decode Audio File', 'Position', [150, 30, 200, 40], ...
        'ButtonPushedFcn', @(~, ~) decode_audio_file());

    % Create a separate window for spectrum analysis
    spectrum_window = uifigure('Name', 'DTMF Spectrum Analysis', 'Position', [600, 100, 600, 400]);
    
    % Axes for plotting the waveform
    waveform_axes = uiaxes(spectrum_window, 'Position', [50, 200, 500, 150]);
    title(waveform_axes, 'DTMF Signal Waveform');
    xlabel(waveform_axes, 'Time (seconds)');
    ylabel(waveform_axes, 'Amplitude');
    grid(waveform_axes, 'on');
    
    % Axes for plotting the frequency spectrum
    spectrum_axes = uiaxes(spectrum_window, 'Position', [50, 50, 500, 150]);
    title(spectrum_axes, 'DTMF Frequency Spectrum');
    xlabel(spectrum_axes, 'Frequency (Hz)');
    ylabel(spectrum_axes, 'Magnitude');
    grid(spectrum_axes, 'on');
    
    % Label to display the decoded key
    decoded_key_label = uilabel(spectrum_window, 'Text', 'Decoded Key: -', 'Position', [200, 20, 200, 30], ...
        'FontSize', 14, 'FontWeight', 'bold');

    % Function to generate a DTMF tone
    function generate_dtmf_tone(key)
        % Define the DTMF frequency pairs for each key
        dtmf_frequencies = containers.Map({'1','2','3','4','5','6','7','8','9','0','*','#'}, ...
            {[697 1209], [697 1336], [697 1477], [770 1209], [770 1336], [770 1477], ...
            [852 1209], [852 1336], [852 1477], [941 1336], [941 1209], [941 1477]});
        
        % Set the sampling rate and tone duration
        sampling_rate = 8000;
        tone_duration = 0.25;
        time_vector = 0:1/sampling_rate:tone_duration;
        
        % Get the frequencies for the selected key
        frequencies = dtmf_frequencies(key);
        dtmf_tone = sin(2*pi*frequencies(1)*time_vector) + sin(2*pi*frequencies(2)*time_vector);
        
        % Play the generated tone
        sound(dtmf_tone, sampling_rate);
        
        % Plot the waveform
        plot(waveform_axes, time_vector, dtmf_tone);
        title(waveform_axes, ['DTMF Tone for Key ', key]);
        grid(waveform_axes, 'on');
        
        % Plot the frequency spectrum
        signal_length = length(dtmf_tone);
        frequency_spectrum = abs(fft(dtmf_tone));
        frequency_axis = (0:signal_length-1)*(sampling_rate/signal_length);
        plot(spectrum_axes, frequency_axis(1:signal_length/2), frequency_spectrum(1:signal_length/2));
        title(spectrum_axes, 'DTMF Frequency Spectrum');
        grid(spectrum_axes, 'on');
        
        % Update the decoded key label
        decoded_key_label.Text = ['Decoded Key: ', key];
    end

    % Function to decode a DTMF tone from an audio file
    function decode_audio_file()
        % Prompt the user to select an audio file
        [file_name, file_path] = uigetfile('*.wav', 'Select a DTMF Audio File');
        if file_name == 0
            return; % User canceled the file selection
        end
        full_file_path = fullfile(file_path, file_name);
        
        % Read the audio file
        [audio_signal, sampling_rate] = audioread(full_file_path);
        
        % Perform FFT to analyze the frequency components
        signal_length = length(audio_signal);
        frequency_spectrum = abs(fft(audio_signal));
        frequency_axis = (0:signal_length-1)*(sampling_rate/signal_length);
        
        % Find the two highest peaks in the frequency spectrum
        [~, peak_indices] = findpeaks(frequency_spectrum(1:signal_length/2), 'SortStr', 'descend', 'NPeaks', 2);
        detected_frequencies = round(frequency_axis(peak_indices));
        
        % Map the detected frequencies to a DTMF key
        dtmf_key_mapping = {
            697, 1209, '1'; 697, 1336, '2'; 697, 1477, '3';
            770, 1209, '4'; 770, 1336, '5'; 770, 1477, '6';
            852, 1209, '7'; 852, 1336, '8'; 852, 1477, '9';
            941, 1336, '0'; 941, 1209, '*'; 941, 1477, '#'
        };
        
        detected_key = '-';
        for i = 1:size(dtmf_key_mapping, 1)
            if ismember(dtmf_key_mapping{i,1}, detected_frequencies) && ismember(dtmf_key_mapping{i,2}, detected_frequencies)
                detected_key = dtmf_key_mapping{i,3};
                break;
            end
        end
        
        % Update the decoded key label
        decoded_key_label.Text = ['Decoded Key: ', detected_key];
        
        % Plot the waveform and spectrum of the decoded tone
        plot(waveform_axes, (1:signal_length)/sampling_rate, audio_signal);
        title(waveform_axes, 'Decoded DTMF Signal Waveform');
        grid(waveform_axes, 'on');
        
        plot(spectrum_axes, frequency_axis(1:signal_length/2), frequency_spectrum(1:signal_length/2));
        title(spectrum_axes, 'Decoded DTMF Frequency Spectrum');
        grid(spectrum_axes, 'on');
    end
end