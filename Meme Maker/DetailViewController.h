//
//  DetailViewController.h
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TableViewController.h"
#import "MemeObject.h"
#import "MemeProtocol.h"
//#import "GADBannerView.h"
//#import "GADRequest.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIDocumentInteractionControllerDelegate, MemeProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *twoSidedArrow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *topOrBottomButton;

@property (weak, nonatomic) IBOutlet UITextField *topField;
@property (weak, nonatomic) IBOutlet UITextField *bottomField;

@property (weak, nonatomic) MemeObject *meme;

- (IBAction)shareAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)textFieldTextChanged:(id)sender;
- (IBAction)fontAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *BlackBlurredImage;

@property (weak, nonatomic) IBOutlet UIButton *openInButton;
- (IBAction)openInAction:(id)sender;

- (IBAction)topOrBottom:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *topOrBottomButtonPad;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonPad;


@end
