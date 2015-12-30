//
//  HYBLoadImageView.m
//  CoreImageFaceDectection
//
//  Created by 黄仪标 on 14/11/17.
//  Copyright (c) 2014年 黄仪标. All rights reserved.
//

#import "UIView+HYBUIViewCommon.h"
#import "HYBLoadImageView.h"
//#import "UIImageView+AFNetworking.h"
#import <UIImageView+AFNetworking.h>
//#import "AFHTTPRequestOperationManager.h"
//#import <AFNetworking/AFNetworking.h>

#import "HYBLoopScrollView.h"

#define kImageWithName(Name) ([UIImage imageNamed:Name])
#define kAnimationDuration 1.0

@interface HYBLoadImageView () {
@private
  BOOL                 _isAnimated;
  UITapGestureRecognizer *_tap;
}


@end

@implementation HYBLoadImageView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self configureLayout];
  }
  return self;
}

- (instancetype)init {
  return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithImage:(UIImage *)image {
  if (self = [super initWithImage:image]) {
    [self configureLayout];
  }
  return self;
}

- (void)configureLayout {
  self.layer.masksToBounds = YES;
  self.clipsToBounds = YES;
  [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
  
  self.animated = YES;
  self.hyb_borderColor = [UIColor lightGrayColor];
  self.hyb_borderWidth = 0.0;
  self.hyb_corneradus = 0.0;
  self.isCircle = NO;
  
  return;
}

- (void)setImage:(UIImage *)image isFromCache:(BOOL)isFromCache {
  self.image = image;
  
  if (!isFromCache && _isAnimated) {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.65f];
    [animation setType:kCATransitionFade];
    animation.removedOnCompletion = YES;
    [self.layer addAnimation:animation forKey:@"transition"];
  }
  self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setAnimated:(BOOL)animated {
  _isAnimated = animated;
  return;
}

- (BOOL)animated {
  return _isAnimated;
}

- (void)setIsCircle:(BOOL)isCircle {
  if (isCircle) {
    if (self.hyb_width != self.hyb_height) {
      self.hyb_size = CGSizeMake(MIN(self.hyb_width, self.hyb_height),
                                 MIN(self.hyb_width, self.hyb_height));
    }
    self.hyb_corneradus = self.hyb_width / 2.0;
  } else {
    self.hyb_corneradus = 0.0;
  }
  return;
}

- (void)setTapImageViewBlock:(HYBTapImageViewBlock)tapImageViewBlock {
  if (_tapImageViewBlock != tapImageViewBlock) {
    _tapImageViewBlock = [tapImageViewBlock copy];
  }
  
  if (_tapImageViewBlock == nil) {
    if (_tap != nil) {
      [self removeGestureRecognizer:_tap];
      self.userInteractionEnabled = NO;
    }
  } else {
    if (_tap == nil) {
      _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
      [self addGestureRecognizer:_tap];
      self.userInteractionEnabled = YES;
    }
  }
}

- (void)onTap:(UITapGestureRecognizer *)tap {
  if (self.tapImageViewBlock) {
    self.tapImageViewBlock((HYBLoadImageView *)tap.view);
  }
}

- (BOOL)isCircle {
  return self.layer.cornerRadius > 0.0;
}

- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(NSString *)placeholderImage {
  return [self setImageWithURLString:url placeholderImage:placeholderImage completion:nil];
}

- (void)setImageWithURLString:(NSString *)url placeholder:(UIImage *)placeholderImage {
  return [self setImageWithURLString:url placeholder:placeholderImage completion:nil];
}

- (void)setImageWithURLString:(NSString *)url
                  placeholder:(UIImage *)placeholderImage
                   completion:(void (^)(UIImage *image))completion {
  [self.layer removeAllAnimations];
  self.completion = completion;
  
  
  if (url == nil
      || [url isKindOfClass:[NSNull class]]
      || (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])) {
    [self setImage:placeholderImage isFromCache:YES];
    if (completion) {
      self.completion(self.image);
    }
    return;
  }
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [self downloadWithReqeust:request holder:placeholderImage];
}

- (void)downloadWithReqeust:(NSURLRequest *)theRequest holder:(UIImage *)holder {
  // 每次都先取消之前的请求
  [self cancelImageDownloadTask];

  
  __weak __typeof(self) welfSelf = self;
    
/*
 //
    __weak __typeof(self) welfSelf = self;
    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:theRequest];
    if (cachedImage) {
        [self setImage:cachedImage isFromCache:YES];
        if (self.completion) {
            self.completion(cachedImage);
        }
        return;
    }
 */
  
  [self setImageWithURLRequest:theRequest
              placeholderImage:holder
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                         [welfSelf setImage:image isFromCache:NO];
                         if (welfSelf.completion) {
                           welfSelf.completion(image);
                         }
                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                         if (welfSelf.completion) {
                           welfSelf.completion(nil);
                         }
                       }];
}

- (void)setImageWithURLString:(NSString *)url
             placeholderImage:(NSString *)placeholderImage
                   completion:(void (^)(UIImage *image))completion {
  [self setImageWithURLString:url placeholder:kImageWithName(placeholderImage) completion:completion];
}

- (void)cancelRequest {
  [self cancelImageDownloadTask];
}

@end
