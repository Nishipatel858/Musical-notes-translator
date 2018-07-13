% Description   : Musical notes translator
% Date          : 20/04/2018
% Group         : 3 
% Group-Members : Shanaya Mehta	      (201501055)
%                 Himanshu Moliya     (201501062)
%                 Janvi Patel 	      (201501072)
%                 Nishi Patel		  (201501076)
%	    	      Mohit Issrani	      (1612216)

clc                       %for clearing theoraticaleoraticale command window
close all                 %for closing all theoraticaleoraticale window except command window
clear all                 %for deleting all theoraticaleoraticale variables from theoraticaleoraticale memory

img = imread('input3.png');   %Read image from graphics file  
img = imresize(img, 3);       %resize the image 
% image is larger then original image by scale of 3

lvl = graythresh(img);      %Global image threshold using Otsu's method
BWOrig = im2bw(img, lvl);   %convert image to binary image using threshold

BWComplement = ~BWOrig;     %complement of image
CC = bwconncomp(BWComplement);  %find connected components in binary image
numPixels = cellfun(@numel, CC.PixelIdxList);   %apply function in each cell in cell array
[biggest,idx] = max(numPixels);     
BWComplement(CC.PixelIdxList{idx}) = 0; 

BW = imdilate(BWComplement, strel('disk',3)); % grow the text a bit to get a bigger ROI around them.
CC = bwconncomp(BW);    %finding connected components in binary image

% Use regionprops to get the bounding boxes around the text
s = regionprops(CC,'BoundingBox');
roi = vertcat(s(:).BoundingBox);   % Concatenate arrays vertically

BW1 = imerode(BWComplement, strel('square',1));  %Image processing of Erode image to find the curve

results = ocr(BW1, roi, 'TextLayout', 'Word');  %applying optical character recognition 
c = cell(1,numel(results));
for i = 1:numel(results)
    c{i} = deblank(results(i).Text);    %Remove trailing whitespace from end of string or character array
end

final = insertObjectAnnotation(im2uint8(BWOrig), 'Rectangle', roi, c); %returns a truecolor image annotated with shape and label at the location specified by position.

figure
imshow(final)   %display image

%
for i=1:length(results)
    out = results(i).Text;
 	txt(i) = out(1,1);
    k(i) = out(1,2);
end
for i=1:length(results)
     if(i<=length(results)-1)     
        if(txt(i+1)=='b' || txt(i+1)=='.')
            temp=txt(i);
            txt(i)=txt(i+1);
            txt(i+1)=temp;
        end
     end
end 
t = 0;
for i = 1:length(results)
    if(txt(i) == '|' && txt(i+1) == '|')
        t = 1;
    end
end

for i=1:length(results)
    if(k(i) == 'g' || k(i) == '\' || k(i) == '/')
        if(txt(i+2)=='.' || txt(i+2)=='b' || txt(i+2)=='4' || txt(i+2)=='2' || txt(i+2)=='3')
           if(txt(i+3)=='A' || txt(i+3)=='B' || txt(i+3)=='C' || txt(i+3)=='D' || txt(i+3)=='E' || txt(i+3)=='F' || txt(i+3)=='G')
            l = length(txt);
            while (l~=(i+2))
                t = txt(l);
                txt(l+1)=t;
                l = l-1;
            end
            txt(i+4) = "[";
          else
            l = length(txt);
            while (l~=(i+3))
                t = txt(l);
                txt(l+1)=t;
                l = l-1;
            end
            %txt(i+3) = "8";
            txt(i+4)="[";
           end
           
           if((txt(i+6) == "2" || txt(i+6) == "3" || txt(i+6) == "4") && (txt(i+7) ~= "2" || txt(i+7) ~= "3" || txt(i+7) ~= "4"))
                l = length(txt);
                while (l~=(i+6))
                    t = txt(l);
                    txt(l+1)=t;
                    fprintf(t)
                    l = l-1;
                end
                
                txt(i+7) = "]";
                fprintf(txt)
           end
             
           if((txt(i+7) == "2" || txt(i+7) == "3" || txt(i+7) == "4"))
                l = length(txt);
                while (l~=(i+7))
                    t = txt(l);
                    txt(l+1)=t;
                    l = l-1;
                end
                txt(i+8) = "]";
           end
           
           if((txt(i+2) == "2" || txt(i+2) == "3" ))
                l = length(txt);
                while (l~=(i+2))
                    t = txt(l);
                    txt(l+1)=t;
                    fprintf(t)
                    l = l-1;
                end
                
                txt(i+3) = "]";
                fprintf(txt)
           end
           
           if(txt(i+2) == "4")
                l = length(txt);
                while (l~=(i+2))
                    t = txt(l);
                    txt(l+1)=t;
                    fprintf(t)
                    l = l-1;
                end
                
                txt(i+4) = "]";
                fprintf(txt)
           end  
        end
    end
end

j = 1;

for i=1:length(txt)
    text(j)=txt(i);
    if(txt(i)== 'I')
        text(j) = '|';
    end
    if(txt(i)== 'Z')
        j=i+1;
        text(j-1) = 'r';
        text(j) = '4';
        text(j+1)=' ';
        j = j+1;
    end
    if(txt(i)== 'b')
            text(j) = 'e';
            text(j+1) = 's'; 
            j = j+1;
        
    end
    if(txt(i)== '4')
        text(j) = "'";
        text(j+1) = "'";
        j = j+1;
       
    end
    if(txt(i)== '.')
        text(j) = 'i';
        text(j+1) = 's';
        j = j+1;
    end
    
    if(txt(i)== 'O')
        text(j) = "'";
    end
    
    if(txt(i)== '2')
        text(j) = ' ';
    end
    
    if(txt(i)== '3')
        text(j) = "'";
     
    end
     
        j = j+1;
end
%text
f = text;
j = 1;

for i = 1:length(text)
    f(j) = text(i);
    if(i<=length(text)-1)     
        if(text(i) == "'" && text(i+1)~="'")
            f(j+1) = " ";
            j = j+1;
        end
    end
    j = j+1;
    
end

for i = 1:length(f)
    if(f(i)=="[")     
       f(i-1)='8';
    end    
end
f = lower(f)

