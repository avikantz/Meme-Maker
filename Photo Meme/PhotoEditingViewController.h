//
//  PhotoEditingViewController.h
//  Photo Meme
//
//  Created by Avikant Saini on 1/25/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TableViewController.h"
#import "MemeObject.h"

@interface PhotoEditingViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *fontButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *twoSidedArrow;

@property (weak, nonatomic) IBOutlet UITextField *topField;
@property (weak, nonatomic) IBOutlet UITextField *bottomField;

@property (weak, nonatomic) MemeObject *meme;

- (IBAction)textFieldTextChanged:(id)sender;
- (IBAction)fontAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *BlackBlurredImage;

- (IBAction)topOrBottom:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *topOrBottomButton;

@end
