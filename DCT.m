clear all ; clc; 

cover_image = imread('yellowlily.jpg'); 
cover_image=rgb2gray(cover_image);
cover_image=imresize(cover_image, [512 512]); 
height = size(cover_image, 1); 
width = size(cover_image, 2); 

message = input ('Enter your message: ' , 's');

len = length(message) * 8; 

ascii_value = uint8(message); 
bin_message = transpose(dec2bin(ascii_value, 8));
bin_message = bin_message(:); 
N = length(bin_message); 
bin_num_message=str2num(bin_message); 

output = cover_image;
s=100;
embed_counter = 1;
for row=1:8:height
    for col=1:8:width
        block=output(row:row+7,col:col+7);
        dct_block=dct2(block);
        
        if(embed_counter <= len)
            if (bin_num_message(embed_counter)==1)
                dct_block(2,2)=s*floor (dct_block(2,2)/s)+3*s/4;
            else
                dct_block(2,2)=s*floor (dct_block(2,2)/s)+s/4;
            end
            block=idct2(dct_block);
            output(row:row+7,col:col+7)=block;
            embed_counter=embed_counter+1;
            
        end
    end
end

subplot 121;imshow(cover_image);title('Original Image');
subplot 122; imshow(output);title('Stego image using DCT');
imwrite(output,'stego_image.bmp');
ps=psnr((output),(cover_image));
ss=ssim((output),(cover_image));