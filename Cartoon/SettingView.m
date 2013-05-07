//
//  SettingView.m
//  Cartoon
//
//  Created by yueshenyuan on 13-4-30.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview
{
    if([self.subviews count] == 0) {
        [self setup];
    }
}

- (void)setup
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tabView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopularListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.text = @"yueshenyuan";
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
