//
//  CommentCell.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CommentCell.h"
#import "SWTimeInterval.h"

@interface CommentCell ()
//@property (strong, nonatomic)  UIImageView *avaterView;
//
//@property (strong, nonatomic)  UILabel *userNameLabel;
//
//@property (strong, nonatomic)  UILabel *commentLabel;
//
//@property (strong, nonatomic)  UILabel *commentTimeLabel;
//
//@property (strong, nonatomic)  UILabel *UpLabel;
//
//@property (strong, nonatomic)  UIImageView *upImage;
//
//@property (strong, nonatomic)  UIImageView *downImage;
//
//
//@property (strong, nonatomic)  UILabel *downLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avaterView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *UpLabel;

@property (weak, nonatomic) IBOutlet UILabel *downLabel;

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    _avaterView.clipsToBounds = YES;
    _avaterView.layer.cornerRadius = _avaterView.bounds.size.width/2;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self customView];
//    }
//    return self;
//}
//
//- (void)customView {
//    _avaterView = [[UIImageView alloc]init];
//    [self.contentView addSubview:_avaterView];
//    _avaterView.clipsToBounds = YES;
//    _avaterView.layer.cornerRadius = 15;
//    
//    _userNameLabel = [UILabel new];
//    [self.contentView addSubview:_userNameLabel];
//    _userNameLabel.font = [UIFont systemFontOfSize:11];
//    _userNameLabel.textColor = [UIColor darkGrayColor];
//    
//    _commentLabel = [UILabel new];
//    [self.contentView addSubview:_commentLabel];
//    _commentLabel.font = [UIFont systemFontOfSize:13];
//    _commentLabel.numberOfLines = 0;
//    
//    _commentTimeLabel = [UILabel new];
//    [self.contentView addSubview:_commentTimeLabel];
//    _commentTimeLabel.font = [UIFont systemFontOfSize:11];
//    _commentTimeLabel.textColor = [UIColor darkGrayColor];
//    
//    _upImage = [UIImageView new];
//    _upImage.image = [UIImage imageNamed:@"thumbs-up"];
//    [self.contentView addSubview:_upImage];
//    
//    _UpLabel = [UILabel new];
//    [self.contentView addSubview:_UpLabel];
//    _UpLabel.font = [UIFont systemFontOfSize:11];
//    _UpLabel.textColor = [UIColor darkGrayColor];
//    
//    
//    _downImage = [UIImageView new];
//    _downImage.image = [UIImage imageNamed:@"thumbs-down"];
//    [self.contentView addSubview:_downImage];
//    
//    _downLabel = [UILabel new];
//    [self.contentView addSubview:_downLabel];
//    _downLabel.font = [UIFont systemFontOfSize:11];
//    _downLabel.textColor = [UIColor darkGrayColor];
//    
//    
//}
//
//- (void)UpdateWithData:(CommentCellFrame *)cellFrame {
//    NSString *avaterString =cellFrame.model.user.avatar;
//    self.avaterView.frame = cellFrame.avatarImageFrame;
//    [self.avaterView sd_setImageWithURL:[NSURL URLWithString:avaterString] placeholderImage:[UIImage imageNamed:@"login_beforlogin_protrait"]];
//    
//    self.userNameLabel.frame = cellFrame.nameLableFrame;
//    self.userNameLabel.text = cellFrame.model.user.name;
//    
//    self.commentLabel.frame = cellFrame.contentLabelFrame;
//    self.commentLabel.text = cellFrame.model.content;
//    
//    self.commentTimeLabel.frame = cellFrame.timeLabelFrame;
//    self.commentTimeLabel.text = [SWTimeInterval timeInterval:cellFrame.model.createdAt];
//    
//    self.upImage.frame = cellFrame.upImageFrame;
//    
//    self.UpLabel.frame = cellFrame.upLabelFrame;
//    self.UpLabel.text = cellFrame.model.upVotes;
//    
//    self.downImage.frame = cellFrame.downImageFrame;
//    
//    self.downLabel.frame = cellFrame.downLabalFrame;
//    self.downLabel.text = cellFrame.model.downVotes;
//}

- (void)UpdateWithModelData:(OthersCommentsDetailModel *)model {
    [self.avaterView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"login_beforlogin_protrait"]];
    
    self.userNameLabel.text = model.user.name;
    
    self.commentLabel.text = model.content;
   
    
    self.commentTimeLabel.text = [SWTimeInterval timeInterval:model.createdAt];
    
    self.UpLabel.text =model.upVotes;
    
    self.downLabel.text = model.downVotes;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
