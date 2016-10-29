//
//  MessageTableViewCell.m
//  ParseChatClient
//
//  Created by parry on 10/28/16.
//  Copyright © 2016 parry. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    self.messageLabel  = [[UILabel alloc]init];
    
    
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [[self contentView]addSubview:self.messageLabel];
    
    
    
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    UILayoutGuide *margins = self.contentView.layoutMarginsGuide;
    
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.messageLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
    [self.messageLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
    [self.messageLabel.topAnchor constraintEqualToAnchor:margins.topAnchor].active = YES;
    [self.messageLabel.bottomAnchor constraintEqualToAnchor:margins.bottomAnchor].active = YES;

    self.messageLabel.font = [UIFont fontWithName:@"Avenir-Book" size:11];
    
    
    
    
}



@end
