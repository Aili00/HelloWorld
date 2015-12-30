//
//  CenterViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CenterViewController.h"
#import "SWNavigationBar.h"
#import "SWNewsViewController.h"
#import "TitleLabel.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <UIButton+WebCache.h>
#import "UserInfoManager.h"

//标题滚动视图高度
#define TitleScrollViewHeight 40
//标题 button 间隙
#define Padding 10;
//标题 label 宽度
#define LabelWidth 70

@interface CenterViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *titleScrollerView;
@property (nonatomic,strong)UIScrollView *contentScrollerView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *labelArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@property (nonatomic,strong)NSMutableArray *typeArray;
//标志左边抽屉是否打开
@property (nonatomic,assign)BOOL isLeftOpen;
//标志右边抽屉是否打开
@property (nonatomic,assign)BOOL isRightOpen;
//是否登录
@property (nonatomic,assign)BOOL isLogin;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //在消息中心注册 登录成功后执行的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:LOGINSUCCESSNOTIFICATION object:nil];
    // 退出登录后 的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:LOGINOUTNOTIFICATION object:nil];
    //头像上传成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarPostSuccess:) name:AVATARPOSTSUCCESSNOTIFICATION object:nil];
    
    //定制navigationBar
    [self customNavigationBar];
    
    //初始化 数据源
    [self initDataArray];
    
    //创建 滚动视图
    [self createScrollView];
    
    
}

#pragma mark - 定制 navigationBar
- (void)customNavigationBar {
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:@"sss" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    self.title = titleString.string;
    [self addNavgationTitleWithTitle:@"新闻"];
    
    NSString *avaterString = [UserInfoManager shareManager].userModel.avatar;
    (avaterString == nil)?(_isLogin = NO):(_isLogin = YES);
    //(image = [UIImage imageNamed:@"login_portrait_ph"]):(image = [UIImage imageNamed:avaterString]);
  
    [self addNavgationItemWithUrlString:avaterString aSelector:@selector(openRightDrawer) isLeft:NO isLogin:_isLogin];
    
    /**
     *  预留 左边抽屉
     *
     *  @param openLeftDrawer <#openLeftDrawer description#>
     *
     *  @return <#return value description#>
     */
    //[self addNavgationItemWithImage:[UIImage imageNamed:@"news_list_ph"] aSelector:@selector(openLeftDrawer) isLeft:YES];
    
}

- (void)addNavgationTitleWithTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (void)addNavgationItemWithUrlString:(NSString *)urlString aSelector:(SEL)aSelector isLeft:(BOOL)isLeft isLogin:(BOOL)isLogin{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isLogin) [button sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal];
    else [button setImage:[UIImage imageNamed:@"login_portrait_ph"]  forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 20;
//    [button setBackgroundImage:[UIImage imageNamed:@"buttonbar_action"] forState:UIControlStateNormal];
  //  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (aSelector) {
        if ([self respondsToSelector:aSelector]) {
            [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft)
        self.navigationItem.leftBarButtonItem = barButtonItem;
    else
        self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - 初始化数据源
- (void)initDataArray {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = SWBaseColor;
    
    _titleArray = [NSMutableArray new];
    _labelArray = [NSMutableArray new];
    _urlArray = [NSMutableArray new];
    _typeArray = [NSMutableArray new];
    
    NSString  *filePath = [[NSBundle mainBundle]pathForResource:@"title_url" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
   
    for (NSDictionary *dict in array) {
        [_titleArray addObject:dict[@"title"]];
        [_urlArray addObject:dict[@"url"]];
        [_typeArray addObject:dict[@"type"]];
    }
}

- (void)createScrollView {
    //消除自动布局对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建标题滚动视图
   _titleScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TitleScrollViewHeight)];
    _titleScrollerView.showsHorizontalScrollIndicator = NO;
    _titleScrollerView.contentSize = CGSizeMake(LabelWidth * _titleArray.count, TitleScrollViewHeight);
    [self.view addSubview:_titleScrollerView];
    
    //创建内容滚动视图
    _contentScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TitleScrollViewHeight, ScreenWidth, ScreenHeight-NavHeight-TitleScrollViewHeight)];
    //_contentScrollerView.showsVerticalScrollIndicator = NO;
    _contentScrollerView.delegate  = self;
    _contentScrollerView.pagingEnabled = YES;
    _contentScrollerView.contentSize = CGSizeMake(ScreenWidth * _titleArray.count, 0);
    [self.view addSubview:_contentScrollerView];
    //添加子视图控制器
    [self addChildControllers];
    //添加 标题 button
    [self addLabel];
    
    //添加默认视图
    UIViewController *viewController  = self.childViewControllers.firstObject;
    viewController.view.frame = _contentScrollerView.bounds;
    [_contentScrollerView addSubview: viewController.view];
    
    TitleLabel *titleLabel = _labelArray.firstObject;
    titleLabel.scale = 1.0;
    
}

- (void)addChildControllers {
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        SWNewsViewController *newsViewController = [SWNewsViewController new];
        newsViewController.navigationController.title = _titleArray[i];
        newsViewController.pageType = _typeArray[i];
        newsViewController.requestUrl = _urlArray[i];
        [self addChildViewController:newsViewController];
    }
}

- (void)addLabel{
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        CGFloat labelX = LabelWidth*i;
        CGFloat labelY = 0;
        CGFloat labelH = TitleScrollViewHeight;
        CGFloat labelW = LabelWidth;
        
        TitleLabel *label = [[TitleLabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = _titleArray[i];
        label.tag = i;
        //添加单击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [label addGestureRecognizer:tapGesture];
        
        [_titleScrollerView addSubview:label];
        [_labelArray addObject:label];
    }
}

//点击 titleLabel 触发事件
- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    NSInteger index = tapGesture.view.tag;
    CGPoint offset = CGPointMake(ScreenWidth*index, 0);
    [_contentScrollerView setContentOffset:offset animated:YES];
    
    //为 内容滚动视图 添加内容视图
    SWNewsViewController *viewController = self.childViewControllers[index];
    //若已经添加到滚动视图上 不再重复添加
    if (viewController.view.superview) return;
    viewController.view.frame = CGRectMake(_contentScrollerView.frame.size.width*index, 0, _contentScrollerView.frame.size.width, _contentScrollerView.frame.size.height);
    [_contentScrollerView addSubview:viewController.view];

}


//打开左边抽屉
- (void)openLeftDrawer {
    if (self.isLeftOpen) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
        self.isLeftOpen = NO;
    }
    else {
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        self.isLeftOpen = YES;
    }
    
    
}

//打开右边抽屉
- (void)openRightDrawer{
    
    self.isRightOpen?[self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }]:[self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
    
    self.isRightOpen = !self.isRightOpen;
    
}

#pragma mark - 登录成功后的回调方法
- (void)loginSuccess:(NSNotification *)notification {
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    
    NSURL *iconUrl = [NSURL URLWithString:[UserInfoManager shareManager].userModel.avatar];
    [button sd_setImageWithURL:iconUrl forState:UIControlStateNormal];
}

#pragma mark - 退出登录后的回调方法
- (void)loginOut:(NSNotification *)notification {
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    [button setImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
}
#pragma mark - 头像上传成功后的回调方法
- (void)avatarPostSuccess:(NSNotification *)notification {
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    UIImage *image = (UIImage *)notification.object;
    [button setImage:image forState:UIControlStateNormal];
}

#pragma mark - UIScrollViewDelegate
#pragma mark - 拖动内容 视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //获取 移动后对应title 索引
    NSInteger index = _contentScrollerView.contentOffset.x/_contentScrollerView.frame.size.width;
    
    TitleLabel *label = (TitleLabel *)_labelArray[index];
    CGFloat titleOffsetX = label.center.x - _titleScrollerView.frame.size.width/2;
    CGFloat titleMaxOffsetX = _titleScrollerView.contentSize.width - _titleScrollerView.frame.size.width;
    //在最边缘位置不移动
    if (titleOffsetX < 0) titleOffsetX = 0;
    else if (titleOffsetX > titleMaxOffsetX) titleOffsetX = titleMaxOffsetX;
   //设置移动
    CGPoint titleOffset = CGPointMake(titleOffsetX, 0);
    [_titleScrollerView setContentOffset:titleOffset animated:YES];
    label.scale = 1.0;
    
    //设置移动后的title 复原
    [_labelArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            TitleLabel *subLabel = _labelArray[idx];
            subLabel.scale = 0.0;
        }
    }];
    
    //为 内容滚动视图 添加内容视图
    SWNewsViewController *viewController = self.childViewControllers[index];
    //若已经添加到滚动视图上 不再重复添加
    if (viewController.view.superview) return;
    viewController.view.frame = _contentScrollerView.bounds;
    [_contentScrollerView addSubview:viewController.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat rightScale = value - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    TitleLabel *leftLabel = _labelArray[leftIndex];
    leftLabel.scale = leftScale;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < _labelArray.count) {
        
        TitleLabel *rightLabel = _labelArray[rightIndex];
        rightLabel.scale = rightScale;
    }
    
    self.navigationController.title = _titleArray[leftIndex];
}

#pragma mark - 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告啦！！！！！！！");
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
