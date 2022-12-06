# DESEncryption_ECE287
Authors: Blake Rile & Mina Yang

# Background
Encryption is highly demanded due to safety, security and various other reasons. Now the DES algorithm is widely used in the world to help people protect information.
"The DES (Data Encryption Standard) algorithm is a symmetric-key block cipher created in the early 1970s by an IBM team and adopted by the National Institute of Standards and Technology (NIST). The algorithm takes the plain text in 64-bit blocks and converts them into ciphertext using 48-bit keys(Simplilearn, 2022)".
"The combination of substitutions and permutations is called a product cipher.(Liu et al., 2013)".


# Description of design
The purpose of this project is to use the DE2-115 board to encrypt any 16 character hexdecimal data users put in. Users can use a PS2 keyboard to enter numbers 0 through 9 and letters a through f. The numbers and letters entered by users will show up on the LCD display on the DE2 board. There are two lines of 16 character hexdecimal data for users to put in. The first line is for the data users want to protect. The second line is for the keys utilized to help encrypt data. The encrypted/decrypted version will also be displayed on LCD screen after all inputs are done. FSM(finite state machine) is also created to control inputs.


# Problems & Solutions
-Originally we wanted to use 8 ASCII instead of hexdecimal, but then found out it will make the input control harder and more complicated than using hexdecimal. Besides that, we need to create a separate module to convert ASCII into hexdecimal. Hence, use hexdecimal is more efficient.

-The concatonation operator {} should have the most significant bit on the left and the least significant bit on the right. However,when we did it, data inserted oppositely. We then manually reverse the data.


# Conclusion
This project utilized DE2-115 to allow users encrypt/decrypt 16 character hexdecimal data. We asked users to enter key so that they can choose whichever key features they would like. Hardcode for the key in the design part will then not be required. FSM is utilized for 


# Results
Link to [video](https://youtu.be/Ym-LmnOO4iQ) demonstration.
![keyboard](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/ADA9E3D1-1EA5-4CD7-AB0C-AB4BDDC28ADE.jpeg)
![data](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/8C3A09E2-A0E6-43C5-886E-B25E34DD9EA3.jpeg)
![encrypted](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/CE7B11B5-C53D-4BC9-9FE4-083282F1F910.jpeg)
![decrypt](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/018FD2D3-563B-49D3-80A7-05B9F7265807.jpeg)
![done](https://github.com/Yadouzi/DESEncryption_ECE287/blob/main/images/393CCF37-ADD0-453E-A9DB-014CDE445011.jpeg)
# Work Cited
Simplilearn. (2022, November 18). What is DES (data encryption standard)? DES algorithm and operation [updated]. Simplilearn.com. Retrieved October 28, 2022, from https://www.simplilearn.com/what-is-des-article

Liu, C.-hong, Ji, J.-shui, &amp; Liu, Z.-long. (2013, November 27). Implementation of DES Encryption Arithmetic based on FPGA. Gansu; Northwest University for nationalities Lanzhou. https://www.sciencedirect.com/science/article/pii/S2212671613000814?ref=pdf_download&fr=RR-2&rr=774f75f51b708702

Grabbe, J. O. (n.d.). The DES Algorithm Illustrated. The des algorithm illustrated. Retrieved November 13, 2022, from https://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm 



