# Author: Rachel Bonanno
# Date: 12/6/2023
# Description: converts a png file to a readable vhdl rom file that is stored as a txt

from PIL import Image
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# paths for the png files
# path = 'gamescreen.png'
# path = 'startscreen.png'
# path = 'heart.png'
# path = 'hit.png'
# path = 'miss.png'
# path = 'gameover.png'
# path = 'gamescreen1.png'
# path = 'eleL.png'
# path = 'eleR.png'
# path = 'gameoverp1.png'
# path = 'gameoverp2.png'
# path = 'gameovertie.png'
# path = 'instructions.png'
path = 'gameoverscreen.png'


image = Image.open(path)
pixels = np.asarray(image)
print(pixels.shape)


# dimensions of the images
happy_pixel = np.zeros((60, 80, 3)) # gameover screens and start screen
# happy_pixel = np.zeros((18, 18, 3)) # for heart
# happy_pixel = np.zeros((10, 19, 3)) # for hit text
# happy_pixel = np.zeros((10, 31, 3)) # for miss text
# happy_pixel = np.zeros((24, 37, 3)) # for gameover text
# happy_pixel = np.zeros((60, 160, 3)) # for gamescreen1
# happy_pixel = np.zeros((5, 7, 3)) # for eleL and R
# happy_pixel = np.zeros((240, 320, 3)) # for instructions screen

# sotrage files
# with open('VHDLReadableFiles/gamescreen.txt', 'w') as file:
# with open('VHDLReadableFiles/startscreen.txt', 'w') as file:
# with open('VHDLReadableFiles/heart.txt', 'w') as file:
# with open('VHDLReadableFiles/hit.txt', 'w') as file:
# with open('VHDLReadableFiles/miss.txt', 'w') as file:
# with open('VHDLReadableFiles/gameover.txt', 'w') as file:
# with open('VHDLReadableFiles/eleL.txt', 'w') as file:
# with open('VHDLReadableFiles/eleR.txt', 'w') as file:
# with open('VHDLReadableFiles/gameoverp1.txt', 'w') as file:
# with open('VHDLReadableFiles/gameoverp2.txt', 'w') as file:
# with open('VHDLReadableFiles/gameovertie.txt', 'w') as file:
# with open('VHDLReadableFiles/instructions.txt', 'w') as file:
with open('VHDLReadableFiles/gameoverscreen.txt', 'w') as file:
        # VHDL code to make the rom work for istructions screen -- if you want to use this with otherr files you need to change the entity name
        # file.write('library IEEE; \nuse IEEE.std_logic_1164.all; \nuse IEEE.numeric_std.all;\nentity instructions_rom is\nport(\n\tclk : in std_logic; \n\trow_idx: in unsigned(8 downto 0); \n\tcol_idx : in unsigned(7 downto 0); \n\trgb : out std_logic_vector(5 downto 0) \n\t); \nend instructions_rom; \narchitecture synth of instructions_rom is \nsignal location : std_logic_vector(16 downto 0); \nbegin \n\tprocess (clk) begin \n\t\tif rising_edge(clk) then \n\t\t\tcase location is\n')
        
        # Iterate over pixels
        for i, row in enumerate(pixels):
            for j, pixel in enumerate(row):
                max_val =np.max(pixel)
                # Convert each pixel to VHDL compatible format
                # making each color a value 0 though 3
                R = int(np.round(pixel[0] / (max_val / 3)))
                G = int(np.round(pixel[1] / (max_val / 3)))
                B = int(np.round(pixel[2] / (max_val / 3)))
                
                # makes each RGB value binary
                happy_pixel[i][j][0] = R
                happy_pixel[i][j][1] = G
                happy_pixel[i][j][2] = B
                # binary conversion
                vhdl_pixel = f"{R:02b}{G:02b}{B:02b}"
                
                # sets how big the binary row and col size is
                location = f"{i:06b}{j:07b}" # gameover screens and start screen
                #location = f"{i:06b}{j:08b}" # background
                # location = f"{i:03b}{j:03b}" # elefants
                # location = f"{i:05b}{j:05b}" # heart
                # location = f"{i:05b}{j:06b}" # gameover text
                # location = f"{i:04b}{j:05b}" # hit and miss text
                # location = f"{i:08b}{j:09b}" # instructions"
                
                if R!=0 or G!=0 or B!=0:
                        file.write('\t\t\t\twhen "' + location + '" => rgb <= "' + vhdl_pixel + '";\n')
        
        file.write('\t\t\t\twhen others => rgb <= "000000";') 
        
        # VHDL code to make the rom work for istructions screen -- this line can be used for all files
        # file.write('\n\t\t\tend case;\n\t\tend if;\n\tend process;\n\tlocation <= std_logic_vector(col_idx) & std_logic_vector(row_idx);\nend;')

print(happy_pixel)

# displays the image using matplotlib so you can check to make sure pixels are stored correctly
# the colors displayed will not match to how it will display on VHDL
# don't freeak out if it looks less detailed
# if you dont believe me with how wierd the colors display run the vhdlcolors.py file
cmap = ListedColormap(['r', 'g', 'b'])
plt.imshow(happy_pixel, cmap=cmap)
plt.show()