# **DTMF Remote Control GUI**  

A MATLAB-based GUI application for generating and decoding DTMF (Dual-Tone Multi-Frequency) signals. This project allows users to generate DTMF tones for specific keypad presses and decode them back into corresponding keys.  

## **Features:**  

✅ **DTMF Tone Generation** – Press a button on the keypad to generate the corresponding DTMF signal.  

✅ **Real-time Waveform and Spectrum Analysis** – View the signal waveform and its frequency spectrum.  

✅ **DTMF Decoding** – The GUI analyzes the frequency components of a played DTMF tone and determines the corresponding key.


## **HOW IT WORKS:**

1. *DTMF Encoding:*
   - When a key is pressed in the GUI, the corresponding pair of frequencies is generated.  
   - The tone is created by summing two sine waves at the respective frequencies.  
   - The tone is played through the computer's audio output.  

2. *DTMF Decoding:*  
   - The generated tone is analyzed using FFT to determine its frequency components.  
   - The two dominant frequencies are identified and matched to the corresponding DTMF key.  

3. *GUI Interaction:*  
   - The main GUI provides a keypad for generating DTMF tones.  
   - The spectrum analysis GUI displays the waveform and frequency spectrum of the generated tone.  
   - The decoded key is displayed in real-time.  


 ## **KEY CONCEPTS DEMONSTRATED:**

1. *Signal Generation:*  
   - Generating sine waves at specific frequencies to create DTMF tones.  

2. *Fast Fourier Transform (FFT):*  
   - Analyzing the frequency components of a signal using FFT.  

3. *Frequency Matching:*  
   - Identifying the dominant frequencies in a signal and mapping them to predefined values.  

4. *GUI Development:*  
   - Creating interactive GUIs using MATLAB's App Designer components (`uifigure`, `uibutton`, `uiaxes`, etc.).  
