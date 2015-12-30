//
//  UserViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "UserViewController.h"
#import "CYTipView.h"

@interface UserViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avaterView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


//是否确认上传（判断 选择图片 上传图片 两种状态）
@property (nonatomic,assign) BOOL isSurePost;

@property (nonatomic,strong) NSMutableData *mutableData;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _avaterView.clipsToBounds = YES;
    _avaterView.layer.cornerRadius = 50;
    _mutableData = [NSMutableData new];
    [self customImage];
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"UserViewController"];
        _image = image;
    }
    return self;
}

//预设图片
- (void)customImage {
    _avaterView.image = _image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self blur:_image];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backImageView.image = image;
        });
    });
}

#pragma mark － 返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传头像
- (IBAction)avaterPostAction:(id)sender {
    if (_isSurePost) {
            UserInfoManager *userManager = [UserInfoManager shareManager]; 
            NSData *imageData = UIImagePNGRepresentation(_avaterView.image);
            
            AFHTTPSessionManager *managerAF = [AFHTTPSessionManager manager];
            managerAF.responseSerializer = [AFHTTPResponseSerializer serializer];
        [managerAF.requestSerializer setValue:[NSString stringWithFormat:@" token %@",userManager.userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
            
            NSDictionary *dict = @{@"Authorization":userManager.userModel.token[@"apikey"]};
            [managerAF POST:SWUSER_AVATER_POST parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:imageData name:@"upload" fileName:@"photo.png" mimeType:@"multipart/form-data"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [CYTipView animationTipViewWithMessage:@"上传成功" duration:AnimationTime completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    //头像上传成功的消息
                    [[NSNotificationCenter defaultCenter] postNotificationName:AVATARPOSTSUCCESSNOTIFICATION object:_avaterView.image];
                    // NSLog(@"%@",responseObject);
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dict);
                    //设置更新后的头像到userdefault 中
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UserModel *userModel = [UserInfoManager shareManager].userModel;
                        userModel.avatar = dict[@"fullUrl"];
                        
                        NSLog(@"%@",userModel);
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UserInfoManager shareManager].userModel];
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_INFO];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    });
                    
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [CYTipView animationTipViewWithMessage:@"图片太大，上传失败!" duration:AnimationTime completion:nil];
            }];
            
            [CYTipView animationTipViewWithMessage:@"上传中..." duration:AnimationTime completion:nil];
    }
    else {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self load:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self load:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
    }]];
 
    [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 加载图像
- (void)load:(UIImagePickerControllerSourceType)type {
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *pickerContr = [[UIImagePickerController alloc]init];
        pickerContr.sourceType = type;
        pickerContr.delegate = self;
        [self presentViewController:pickerContr animated:YES completion:nil];
    }else NSLog(@"error:%d",type);
}


#pragma mark - 图像模糊化处理
- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on
    return returnImage;
}

#pragma mark - 切图片
- (UIImage *)scaleImage:(UIImage *)image{
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    [image drawInRect:CGRectMake(0, 0, 100, 100)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //缩放图片
    _avaterView.image = [self scaleImage:image];
    _isSurePost = !_isSurePost;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_mutableData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
