//
//  HZCustomFilterViewController.m
//  HZImageFilter
//
//  Created by zz go on 2017/5/2.
//  Copyright © 2017年 zzgo. All rights reserved.
//

#import "HZCustomFilterViewController.h"
#import <CoreImage/CoreImage.h>
#import "ChromaKey.h"

//#import <OpenGLES/EAGL.h>

@interface HZCustomFilterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@property (nonatomic,readwrite,strong) UIImagePickerController *imagePicker;
@property (nonatomic,readwrite,strong) UIView *selectedView;
@end


@implementation HZCustomFilterViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self hz_addView:self.greenImageView touchAction:@selector(tapImgView:)];
    [self hz_addView:self.resultBgImageView touchAction:@selector(tapImgView:)];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//UIImage *image=info[UIImagePickerControllerEditedImage];
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    if (self.selectedView==self.greenImageView) {
        self.greenImageView.image=image;
        return;
    }
    
    self.resultBgImageView.image=image;
    return;
}

#pragma mark - Action
-(void)tapImgView:(UITapGestureRecognizer *)gesture{

    if (gesture.view) {
        self.selectedView=gesture.view;
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    

}


- (IBAction)tapResultButton:(id)sender {
    
#pragma mark 组合
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *myImage=[self colorCube];
    
    UIImage *bgImage = self.resultBgImageView.image;
    CIImage *backgroundCIImage = [CIImage imageWithCGImage:bgImage.CGImage];
    
    CIImage *resulImage = [[CIFilter filterWithName:@"CISourceOverCompositing" 
                          keysAndValues:kCIInputImageKey,myImage,kCIInputBackgroundImageKey,backgroundCIImage,nil] 
                        valueForKey:kCIOutputImageKey];
    
    CGRect extent = [resulImage extent];
    
    CGImageRef cgImage = [context createCGImage:resulImage fromRect:extent];
    
    self.resultImageView.image=[UIImage imageWithCGImage:cgImage];

    
//    [self actionTest];
    
}

-(CIImage *)colorCube{
    
#pragma mark 删除绿背，取图
    
    //    let cubeMap = createCubeMap(60,90)
    //    let data = NSData(bytesNoCopy: cubeMap.data, length: Int(cubeMap.length), freeWhenDone: true)
    //    let colorCubeFilter = CIFilter(name: "CIColorCube")
    //    
    //    colorCubeFilter.setValue(cubeMap.dimension, forKey: "inputCubeDimension")
    //    colorCubeFilter.setValue(data, forKey: "inputCubeData")
    //    colorCubeFilter.setValue(CIImage(image: imageView.image), forKey: kCIInputImageKey)
    //    var outputImage = colorCubeFilter.outputImage
    //    
    //    let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")
    //    sourceOverCompositingFilter.setValue(outputImage, forKey: kCIInputImageKey)
    //    sourceOverCompositingFilter.setValue(CIImage(image: UIImage(named: "background")), forKey: kCIInputBackgroundImageKey)
    //    
    //    outputImage = sourceOverCompositingFilter.outputImage
    //    let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent())
    //    imageView.image = UIImage(CGImage: cgImage)
    
    
    
    
    /**  apple sample code 2014
     // Create memory with the cube data
     NSData *data = [NSData dataWithBytesNoCopy:cubeData
     length:cubeDataSize
     freeWhenDone:YES];
     CIColorCube *colorCube = [CIFilter filterWithName:@"CIColorCube"];
     [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
     // Set data for cube
     [colorCube setValue:data forKey:@"inputCubeData"];
     **/
    
    
    
    
     UIImage *baby = self.greenImageView.image;
     CIImage *myImage = [CIImage imageWithCGImage:baby.CGImage];
     // Allocate memory
     const unsigned int size = 64;
     float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
     float rgb[3], hsv[3], *c = cubeData;
     
     // Populate cube with a simple gradient going from 0 to 1
     for (int z = 0; z < size; z++){
     rgb[2] = ((double)z)/(size-1); // Blue value
     for (int y = 0; y < size; y++){
     rgb[1] = ((double)y)/(size-1); // Green value
     for (int x = 0; x < size; x ++){
     rgb[0] = ((double)x)/(size-1); // Red value
     // Convert RGB to HSV
     // You can find publicly available rgbToHSV functions on the Internet
     RGBtoHSV(rgb[0],rgb[1],rgb[2], &hsv[0],&hsv[1],&hsv[2]);
     
     float alpha = (hsv[0] > 80 && hsv[0] < 160) ? 0.0f:1.0f;
     // Calculate premultiplied alpha values for the cube
     c[0] = rgb[0] * alpha;
     c[1] = rgb[1] * alpha;
     c[2] = rgb[2] * alpha;
     c[3] = alpha;
     c += 4;
     }
     }
     }
     
     // Create memory with the cube data
     NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                         length:size * size * size * sizeof (float) * 4
                                   freeWhenDone:YES];
     
     CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
     [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
     [colorCube setValue:myImage forKey:@"inputImage"];
     [colorCube setValue:data forKey:@"inputCubeData"];
     myImage = colorCube.outputImage;
  
    return myImage;
}

-(void)actionTest{
    
//    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *baby = [UIImage imageNamed:@"greenBg"];
    CIImage *myImage = [CIImage imageWithCGImage:baby.CGImage];
    // Allocate memory
    const unsigned int size = 64;
//    float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
//    float rgb[3], hsv[3], *c = cubeData;
    
    ChromaKey *colorCube=[ChromaKey new];
    [colorCube setInputCubeDimension:@(size)];
    [colorCube setInputImage:myImage];
    
    UIImage *image2 = [UIImage imageNamed:@"resultBg"];
    CIImage *backgroundCIImage = [CIImage imageWithCGImage:image2.CGImage];
    [colorCube setInputBackgroundImage:backgroundCIImage];
    
//    [colorCube setInputCenterAngle:@60];
//    [colorCube setInputAngleWidth:@30];
    
    
    self.resultImageView.image=[UIImage imageWithCIImage:colorCube.outputImage];

}


void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ){
    float min, max, delta;
    min = MIN( r, MIN(g, b) );
    max = MAX( r, MAX(g, b) );
    *v = max;                // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;      // s
    else {
        // r = g = b = 0       // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;        // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

#pragma mark - private
- (void)hz_addView:(UIView *)view touchAction:(SEL)action
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *g =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:g];
}

#pragma mark - getter
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[UIImagePickerController new];
        _imagePicker.allowsEditing = NO;
        _imagePicker.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate=self;
    }
    return _imagePicker;
}
@end
