# WaterVideo

The application allows you to add watermark to whatever video you want.  

## Installation

One of the things this application depends on is ImageMagick.  
The application uses RMagick gem which has some installation problems on ImageMagick 7. So one need to install ImageMagick 6.  

On MacOS
```bash
brew install imagemagick@6 --disable-openmp && brew link imagemagick@6 --force
```

## Usage

Just choose a file you want to protect, write a watermark text and press *Save*.
  
The application will do the following things:
 1. Create thumbnail for the video.
 2. Create image with the text.
 3. Add watermark to the video using the image from step 2.
 
It can take some time depending on the uploaded video size.  
The application uses SSE to keep track of processing progress.  
So you can just sit and relax. Once processing is done you can watch the video and download it.
