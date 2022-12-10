# DESEncryption_ECE287
Authors: Blake Rile & Mina Yang

# Background
Encryption is a process of converting information into code to prevent unauthorized access. This skill set is highly demanded nowadays due to safety, security, and other concerns. The DES (Data Encryption Standard) algorithm is based on a symmetric key design (one key for encrypting and decrypting) which is the same way other forms of encryption work, like AES or IDEA. The other way encryption can be designed is asymmetric where there is a public key and a private key that are used to encrypt or decrypt data.

# How it works (High Level)

1. DES takes in plaintext "blocks" of data each with 64 bits, and a 64-bit key used to encrypt/decrypt the data against
2. 16 subkeys are created from the original key
    - The 64-bit key gets compressed into a 56-bit version, removing every 8th bit (known as parity bits) (PC-1)
    - The key is then split in half (left and right)
    - 16 subkeys are created where each one is formed from the previous while using a bit shift register to shift the keys a specific number of places to the left
    - The 16 keys are then compressed into 48-bit versions (PC-2)
3. The 64-bit data gets rearranged (IP)
    - The data then gets split in half (left and right)
*The following happens 16 times and each time is based on the previous.*
    - The left and right sides get flipped and XORed with a special function
4. The special function takes the right side of the data and a subkey which outputs a 32-bit
    - Take the 48 bits and divide them up into 8 sections of 6 bits each.
    - Using the predefined look-up tables the 48 bits turn into the 32-bit output. (S-Boxes)
5. The final permutation takes the 16th right and left and puts them back together as an encrypted 64-bit block of data(IP^-1)

*Reversing the application of subkeys will decrypt the data*


# Description of design
The purpose of this project is to use the DE2-115 board to encrypt any 16-character hexadecimal data users put in (Keys 0-9, a-f on a PS2 Keyboard). In this project, the FSM(finite state machine) is used to control input from the keyboard and then convert it to 4 bits, where 16 groups of 4 bits would create a 64-bit "block". There are two lines of 16-character hexadecimal data for users to put in. The first line is for the data users want to encrypt or the encrypted data the user wants to decrypt. The second line is for the key that is used to encrypt or decrypt the data.  The FSM protects against typing more than the 16 required characters, it also keeps the "backspace" key from removing data when there is no data to remove. You can delete one character or the whole line by clicking "backspace" or "delete" on the keyboard. Once you are satisfied with the data that has been entered, pressing the "enter" key will move to the next line for the key input, and pressing "enter" a second time will display the encrypted or decrypted data. A reset switch can be used to start the program over. Encrypt/Decrypt switch is used to tell the algorithm what order to apply the subkeys (Encrypt or Decrypt). 

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

  - Originally we wanted to use ASCII instead of hexadecimal, but then found out it would make the input control harder and more complicated than using hexadecimal.        Because DES encryption works with 64 bits denoted as "blocks" (this project is working with just 1 block) of data at a time we could further extend this project to accept all ASCII characters and parse the input into the necessary blocks. Using hexadecimal as means of data input works fine for this project.

  - The concatenation operator {} should have the most significant bit on the left and the least significant bit on the right. When we went to use the tables [here](https://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm) they start with the LSB and index at 0. We had to write a simple python script to mirror the tables to start with the MSB so the {} operator would function correctly.

  - In subKey.v the generation of the subkeys does not match the PC-1 and PC-2 tables because of the conversion between bus sizes. (ie. You must subtract the values in the PC-1(64-bit bus => 56-bit bus)(assuming the table index's at 0) table from 63 to get the respective 56 bit compression table. The same is true for PC-2.

  - The FSM inside inputControl.v has a few key protections against user input:
    - When there are no characters displayed on the "data" line (or the "key" line) the FSM prevents the backspace from being registered.
    - Prevents more than 16 hex characters from being input (a full 64-bit buffer).
  

# Conclusion
This project utilized DE2-115 to allow users to encrypt/decrypt 16-character hexadecimal data. We gave the ability for the user to enter their own key as if it was a "password" they are encrypting their data with. A hardcode for the key in the design part will then not be required. In this report, concepts about DES encryption, the design for DES encryption, and the process of using this design are discussed and presented.

# Work Cited - All code is "highlighted" on what was used

## DES Encryption Research (Used to learn how DES Encryption works.)
  - [The DES Algorithm Illustrated.](https://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm)
  - [Implementation of DES Encryption Arithmetic based on FPGA.](https://www.sciencedirect.com/science/article/pii/S2212671613000814?ref=pdf_download&fr=RR-2&rr=774f75f51b708702)
  - [What is DES (data encryption standard)?](https://www.simplilearn.com/what-is-des-article)

## LCD Modules
  - https://johnloomis.org/digitallab/lcdlab/lcdlab1/lcdlab1.html
    - LCD_Display.v
    - LCD_Controller.v
    - Top-Level Module => finalProject.v - "general" layout, instantiations and I/O structure.

## Keyboard (PS2)
  - https://github.com/alecamaracm/Verilog-Game-Engine-with-PowerPoint-designer/blob/master/VerilogExample/
    - keyboard.v => ps2Keyboard.v - added keys for hex characters
  - https://www.eecg.toronto.edu/~jayar/ece241_08F/AudioVideoCores/ps2/ps2.html
    - PS2_Controller.v 

## Other Research
  - https://github.com/ZacharyZampa/ECE287_Project/blob/master/DES_Encryption_Hardware/
    - finalProject.v - generate "for" loop for LCD but there is a custom implementation to clear the screen.
    - inputControl.v - case statement for how to read data from PS2 keyboard.
    - Bit_Converter.v => bin2LCD.v - used to convert from input 4-bit to 9-bit hex for LCD LUT 
