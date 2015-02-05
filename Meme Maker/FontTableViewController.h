//
//  FontTableViewController.h
//  Meme Maker
//
//  Created by Avikant Saini on 1/22/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *fontsTableView;
@property (strong, nonatomic) IBOutlet UITableView *alignmentTableView;
@property (strong, nonatomic) IBOutlet UITableView *relativeFontSizeTableView;

@property (strong, nonatomic) IBOutlet UITableView *textColorTableView;
@property (strong, nonatomic) IBOutlet UITableView *outlineColorTableView;
@property (strong, nonatomic) IBOutlet UITableView *strokeWidthTableView;

@end
