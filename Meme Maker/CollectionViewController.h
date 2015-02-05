//
//  CollectionViewController.h
//  Meme Maker
//
//  Created by Avikant Saini on 1/23/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "CustomCollectionViewCell.h"

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoGalleryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastEditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tableViewButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

- (IBAction)PhotoGalleryAction:(id)sender;
- (IBAction)MenuAction:(id)sender;
- (IBAction)CameraAction:(id)sender;
- (IBAction)lastEditAction:(id)sender;



@end
