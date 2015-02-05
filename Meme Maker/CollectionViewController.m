//
//  CollectionViewController.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/23/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "CollectionViewController.h"
#import "MemeObject.h"
#import "DetailViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController {
	NSArray *ArrayOfMemeObjects;
	NSMutableArray *AllMemes;
	NSMutableArray *SearchResults;
	UIColor *DefColor;
	UIColor *TextColor;
	CGSize sizeOfCells;
	
	NSData *dataOfLastEditedImage;
	NSString *imagePathOfLastEditedImage;
	MemeObject *lastEditedImage;
	
	UIImageView *MeGusta;
}

-(void)viewDidAppear:(BOOL)animated {
	self.navigationController.navigationBar.tintColor = TextColor;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	[self.navigationController.navigationBar setBarTintColor:DefColor];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : TextColor, NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	if ([UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedImagePath"]]] != nil)
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadingLastEdit"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	sizeOfCells = CGSizeMake(self.view.frame.size.width/3 - 9, self.view.frame.size.width/3 - 9);
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"]) {
		DefColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:239/255.0 alpha:1];
		TextColor = [UIColor colorWithRed:50/255.0 green:100/255.0 blue:0 alpha:1];
		MeGusta = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MeGusta"]];
	}
	else {
		DefColor = [UIColor colorWithWhite:0.12 alpha:1.0];
		TextColor = [UIColor colorWithRed:170/255.0 green:250/255.0 blue:120.0/255 alpha:0.7];
		MeGusta = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MeGustaW"]];
	}
	self.navigationItem.titleView = MeGusta;

	ArrayOfMemeObjects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"MemeList" ofType:@"json"]] options:kNilOptions error:nil];
	
	AllMemes = [[NSMutableArray alloc] init];
	SearchResults = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [ArrayOfMemeObjects count]; ++i) {
		MemeObject *meme = [[MemeObject alloc] initWithName:[NSString stringWithFormat:@"%@", [[ArrayOfMemeObjects objectAtIndex:i] objectForKey:@"Name"]] image:[NSString stringWithFormat:@"%@", [[ArrayOfMemeObjects objectAtIndex:i] objectForKey:@"Image"]] tags:[NSString stringWithFormat:@"%@", [[ArrayOfMemeObjects objectAtIndex:i] objectForKey:@"Tags"]] url:[NSString stringWithFormat:@"%@", [[ArrayOfMemeObjects objectAtIndex:i] objectForKey:@"URL"]]];
		meme.topText = @"";
		meme.bottomText = @"";
		[AllMemes addObject:meme];
	}
	
	self.navigationController.navigationBar.tintColor = TextColor;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	[self.navigationController.navigationBar setBarTintColor:DefColor];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : TextColor, NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};

	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil]];
	
	UIPinchGestureRecognizer *pinchgesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
	[self.view addGestureRecognizer:pinchgesture];
	
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_photoGalleryButton, _cameraButton, _lastEditButton, nil];
	self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: _tableViewButton, _menuButton, nil];
	
//	[self.collectionView setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
//	[self.collectionView setAlpha:0.0];
//	[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		[self.collectionView setTransform:CGAffineTransformIdentity];
//		[self.collectionView setAlpha:1.0];
//	}completion:nil];
	
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
//	[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//		[self.collectionView setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
//		[self.collectionView setAlpha:0.0];
//	}completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(self.view.frame.size.width, 10.0f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0.0, 2.0, 0.0, 5.0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [AllMemes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CCID" forIndexPath:indexPath];
	
	MemeObject *meme = nil;
	meme = [AllMemes objectAtIndex:indexPath.row];
	
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"%@", meme.Image]];
	CGFloat larger = MIN(image.size.width, image.size.height);
	image = [self imageByCroppingImage:image toSize:CGSizeMake(larger, larger)];
	cell.imageView.image = image;
	
	[cell.layer setCornerRadius:2.0f];
    
    return cell;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size{
	double x = (image.size.width - size.width) / 2.0;
	double y = (image.size.height - size.height) / 2.0;
	
	CGRect cropRect = CGRectMake(x, y, size.height, size.width);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
	
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	cropped = [self imageToScale:cropped Size:CGSizeMake(64, 64)];
	CGImageRelease(imageRef);
	
	return cropped;
}

-(UIImage *)imageToScale:(UIImage *)image Size:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//	CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CCID" forIndexPath:indexPath];
//	[UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//		cell.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
//	}completion:nil];
//}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"CollectionToDetail"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LibCamPickUp"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadingLastEdit"];
		MemeObject *meme = nil;
		NSIndexPath *indexPath = nil;
		indexPath = [self.collectionView indexPathForCell:sender];
		meme = [AllMemes objectAtIndex:indexPath.row];
		
		[[NSUserDefaults standardUserDefaults] setObject:@"Recent Edit Last" forKey:@"LastEditedMemeTags"];
		
		dataOfLastEditedImage = UIImageJPEGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"%@", meme.Image]], 0.7);
		imagePathOfLastEditedImage = [self documentsPathForFileName:[NSString stringWithFormat:@"lastEditedImage.jpg"]];
		[dataOfLastEditedImage writeToFile:imagePathOfLastEditedImage atomically:YES];
		[[NSUserDefaults standardUserDefaults] setObject:imagePathOfLastEditedImage forKey:@"lastEditedImagePath"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lastEditedTopText"];
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lastEditedBottomText"];
		
		DetailViewController *dvc = segue.destinationViewController;
		dvc.meme = meme;
	}

}





- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return sizeOfCells;
}

-(void) pinchView: (UIPinchGestureRecognizer *)recognizer {
	CGFloat resizeScale = 1.0* recognizer.velocity;
	if ((sizeOfCells.height <  self.view.frame.size.width -5) && (sizeOfCells.width > 50)) {
		if (recognizer.scale < 1.0)
			sizeOfCells = CGSizeMake(sizeOfCells.width + resizeScale, sizeOfCells.height + resizeScale);
		else
			sizeOfCells = CGSizeMake(sizeOfCells.width + resizeScale, sizeOfCells.height + resizeScale);
	}
	
	if (sizeOfCells.width < 50) 
		if (recognizer.scale > 1.0)
			sizeOfCells = CGSizeMake(sizeOfCells.width + resizeScale, sizeOfCells.height + resizeScale);
	if (sizeOfCells.height > self.view.frame.size.width)
		if (recognizer.scale > 1.0)
			sizeOfCells = CGSizeMake(sizeOfCells.width + resizeScale, sizeOfCells.height + resizeScale);
	
	[self.collectionView reloadData];
}

- (IBAction)MenuAction:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"By Popularity", @"Alphabetically", nil];
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"Alphabetically"]){
		NSArray *sortedArray = [AllMemes sortedArrayUsingComparator:^(MemeObject *a, MemeObject *b){
			return [a.Name caseInsensitiveCompare:b.Name];
		}];
		AllMemes = [[NSMutableArray alloc] initWithArray:sortedArray];
		[self.collectionView reloadData];
	}
	if ([title isEqualToString:@"By Popularity"]) {
		[self viewDidLoad];
		[self.collectionView reloadData];
	}
}

#pragma mark - Picker delegates

- (IBAction)PhotoGalleryAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LibCamPickUp"];
	UIImagePickerController *pick = [[UIImagePickerController alloc] init];
	pick.delegate = self;
	pick.allowsEditing = YES;
	[pick.navigationItem setLeftBarButtonItem:_cameraButton];
	[pick.navigationItem setTitle:@"Choose Image"];
	pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:pick animated:YES completion:NULL];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	UINavigationItem *navItem;
	
	UINavigationBar *bar = navigationController.navigationBar;
	[bar setHidden:NO];
	[bar setTintColor:[UIColor colorWithRed:51.0/255 green:104.0/255 blue:0 alpha:1]];
	[bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:50/255.0 green:100/255.0 blue:0 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]}];
	navItem = bar.topItem;
	navItem.title = @"Choose Image";
	
	UIBarButtonItem *cameraButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(CameraAction2)];
	navItem.LeftBarButtonItem = cameraButton2;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(DismissAll)];
	[cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:50/255.0 green:100/255.0 blue:0 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]} forState:UIControlStateNormal];
	navItem.rightBarButtonItem = cancelButton;
}

-(void) CameraAction2 {
	[self.navigationController dismissViewControllerAnimated:YES completion:^{
		[self CameraAction:self];
	}];
}

-(void) DismissAll {
	[self.navigationController dismissViewControllerAnimated:YES completion:^{
	}];
}

- (IBAction)CameraAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LibCamPickUp"];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *pick = [[UIImagePickerController alloc] init];
		pick.delegate = self;
		pick.allowsEditing = YES;
		[pick setSourceType:UIImagePickerControllerSourceTypeCamera];
		[self presentViewController:pick animated: YES completion: NULL];
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error 404"
														message: @"Camera Not Found"
													   delegate: nil
											  cancelButtonTitle: @"Dismiss"
											  otherButtonTitles: nil];
		[alert show];
	}
}

- (IBAction)lastEditAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadingLastEdit"];
	if ([UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedImagePath"]]] != nil) {
		DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
		[self.navigationController pushViewController:dvc animated:YES];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No last edit was found, go on pick up some image." delegate:self cancelButtonTitle:@"Oh, okay." otherButtonTitles:nil, nil];
		[alert show];
	}
}

- (IBAction)tableViewAction:(id)sender {
}

- (void)imagePickerController:(UIImagePickerController *)pick didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadingLastEdit"];
	
	NSData *dataOfImage = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.8);
	NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image.jpg"]];
	[dataOfImage writeToFile:imagePath atomically:YES];
	[[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"ImagePath"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	dataOfLastEditedImage = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.7);
	imagePathOfLastEditedImage = [self documentsPathForFileName:[NSString stringWithFormat:@"lastEditedImage.jpg"]];
	[dataOfLastEditedImage writeToFile:imagePathOfLastEditedImage atomically:YES];
	[[NSUserDefaults standardUserDefaults] setObject:imagePathOfLastEditedImage forKey:@"lastEditedImagePath"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LibCamPickUp"];
	DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
	[pick dismissViewControllerAnimated:YES completion:NULL];
	[self.navigationController pushViewController:dvc animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pick {
	[pick dismissViewControllerAnimated:YES completion:NULL];
}

@end
