# DESEncryption_ECE287
Authors: Blake Rile & Mina Yang

# Background
Encryption is a process of converting information into code to prevent unauthorized access. This technic is highly demanded nowadays due to safety, security and other concerns. The DES algorithm is one of the choices of doing encryption. And for sure it has already been widely used in the world to help people protect information and transfer information.
"The DES (Data Encryption Standard) algorithm is a symmetric-key block cipher created in the early 1970s by an IBM team and adopted by the National Institute of Standards and Technology (NIST). The algorithm takes the plain text in 64-bit blocks and converts them into ciphertext using 48-bit keys(Simplilearn, 2022)".
"The combination of substitutions and permutations is called a product cipher.(Liu et al., 2013)".


# Description of design
The purpose of this project is to use the DE2-115 board to encrypt any 16 character hexdecimal data users put in. Users can use a PS2 keyboard to enter numbers 0 through 9 and letters a through f. The numbers and letters entered by users will show up on the LCD display on the DE2 board. There are two lines of 16 character hexdecimal data for users to put in. The first line is for the data users want to protect. The second line is for the keys utilized to help encrypt data. The encrypted/decrypted version will also be displayed on LCD screen after all inputs are done. FSM(finite state machine) is created to control inputs. 16 character hexdecimal is the maximum numbers of character for each line. Any input after the 16th input will not be recorded. You can delete one character or the whole line by cliking "backspace" or "delete" on the keyboard. However, once you 

# Results
## Video
Embed [video](https://youtu.be/Ym-LmnOO4iQ):

https://user-images.githubusercontent.com/26750211/206052698-0069672b-5c3f-4e43-a49b-e843c6a514ac.mp4

## Keyboard (Characters Implemented)

![keyboard](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/ADA9E3D1-1EA5-4CD7-AB0C-AB4BDDC28ADE.jpeg)

## Encryption

![data](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/8C3A09E2-A0E6-43C5-886E-B25E34DD9EA3.jpeg)
![encrypted](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/CE7B11B5-C53D-4BC9-9FE4-083282F1F910.jpeg)
## Decryption

![decrypt](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/018FD2D3-563B-49D3-80A7-05B9F7265807.jpeg)
![done](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/393CCF37-ADD0-453E-A9DB-014CDE445011.jpeg)

# Problems & Solutions

  - Originally we wanted to use ASCII instead of hexdecimal, but then found out it will make the inputControl harder and more complicated than using hexdecimal.        Because DES encryption works with 64 bits denoted as "blocks" (this project is working with just 1 block) of data at a time we could further extend on this project to accept all ASCII characters and parse the input into the necessary blocks. Using hexadecimal as means of data input works fine for this project.

  - The concatonation operator {} should have the most significant bit on the left and the least significant bit on the right. When we went to use the tables [here](https://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm) they start with the LSB and index at 0. We had to write a simple python script to mirror the tables to start with the MSB so the {} operator would function correctly.

  - In subKey.v the generation of the subkeys does not match the PC-1 and PC-2 tables because of the conversion between bus sizes. (ie. You must subtract the values in the PC-1(64 bit bus => 56 bit bus)(assuming the table index's at 0) table from 63 to get the respective 56 bit compression table. The same is true for PC-2.

  - The FSM inside inputControl.v has a few key protections against user input:
    - When there is no characters deplayed on the "data" line (or the "key" line) the FSM prevents the backspace from being registed.
    - Prevents more that 16 hex characters from being input (a full 64 bit buffer).
  

# Conclusion
This project utilized DE2-115 to allow users encrypt/decrypt 16 character hexdecimal data. We asked users to enter key so that they can choose whichever key features they would like. Hardcode for the key in the design part will then not be required. FSM is utilized for controlling input.


# Work Cited - All code is "highlighted" on what was used

## DES Encryption Research (Used to learn how DES Encryption works.)
  - [The DES Algorithm Illustrated.](https://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm)
  - [Implementation of DES Encryption Arithmetic based on FPGA.](https://www.sciencedirect.com/science/article/pii/S2212671613000814?ref=pdf_download&fr=RR-2&rr=774f75f51b708702)
  - [What is DES (data encryption standard)?](https://www.simplilearn.com/what-is-des-article)

## LCD Modules
  - https://johnloomis.org/digitallab/lcdlab/lcdlab1/lcdlab1.html
    - LCD_Display.v
    - LCD_Controller.v
    - Top-Level Module => finalProject.v - "general" layout, instanciations and I/O structure.

## Keyboard (PS2)
  - https://github.com/alecamaracm/Verilog-Game-Engine-with-PowerPoint-designer/blob/master/VerilogExample/
    - keyboard.v => ps2Keyboard.v - added keys for hex characters
  - https://www.eecg.toronto.edu/~jayar/ece241_08F/AudioVideoCores/ps2/ps2.html
    - PS2_Controller.v 

## Other Research
  - https://github.com/ZacharyZampa/ECE287_Project/blob/master/DES_Encryption_Hardware/
    - finalProject.v - generate "for" loop for LCD but there is custom implementation to clear screen.
    - inputControl.v - case statement for how to read data from PS2 keyboard.
    - Bit_Converter.v => bin2LCD.v - used to convert from input 4 bit to 9 bit hex for LCD LUT 

