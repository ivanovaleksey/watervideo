# WaterVideo

## Installation

One of the things this application depends on is ImageMagick.  
The application uses RMagick gem which has some installation problems on ImageMagick 7. So one need to install ImageMagick 6.  

On MacOS
```bash
brew install imagemagick@6 --disable-openmp && brew link imagemagick@6 --force
```

## Usage

The application allows you to add watermark to whatever video you want.  
So choose a file you want to protect, write watermark text and press *Save*.
  
The application will do the following things:
 1. Create thumbnail for the video.
 2. Create image with the text.
 3. Create watermark on the video with the image from step 2.
 
It can take some time depending on uploaded video size.  
Once processing is done you can watch the video and download it.
