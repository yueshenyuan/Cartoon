//
//  myCell.m
//  Cartoon
//
//  Created by yueshenyuan on 13-4-17.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "myCell.h"

@implementation myCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
