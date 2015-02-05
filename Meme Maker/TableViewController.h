//
//  TableViewController.h
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TableCell.h"
#import "DetailViewController.h"
#import "MemeObject.h"
//#import "PageContentViewController.h" 

@interface TableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>

// UIPageViewControllerDataSource

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoGalleryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastEditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *collectionViewButton;

//@property (strong, nonatomic) NSArray *pageImages;
//@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)MenuAction:(id)sender;
- (IBAction)SearchAction:(id)sender;
- (IBAction)PhotoGalleryAction:(id)sender;
- (IBAction)CameraAction:(id)sender;
- (IBAction)lastEditAction:(id)sender;
- (IBAction)collectionViewAction:(id)sender;





@end
