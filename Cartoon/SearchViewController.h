//
//  SearchViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 13-7-29.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "BaseViewController.h"
#import "NetAPI.h"
@interface SearchViewController : BaseViewController<UISearchBarDelegate,requestDelete>
{
    NetAPI *_api;
}

@property(nonatomic,retain) UISearchBar *searchBar;
@end
