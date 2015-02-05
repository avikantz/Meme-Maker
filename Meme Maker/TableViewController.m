//
//  TableViewController.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "TableViewController.h"
#import "CollectionViewController.h"
#import "topView.h"

@interface TableViewController ()

@end

@implementation TableViewController {
	NSArray *ArrayOfMemeObjects;
	NSMutableArray *AllMemes;
	NSMutableArray *SearchResults;
	
	UIColor *DefColor;
	UIColor *TextColor;
	
	NSData *dataOfLastEditedImage;
	NSString *imagePathOfLastEditedImage;
	MemeObject *lastEditedImage;
	
	UISwitch *autoDismissSwitch;
	UISwitch *continuousEditingSwitch;
	UISwitch *resetSettingsOnLaunchSwitch;
	UISwitch *darkModeSwitch;
	
	UIImageView *MeGusta;
	UITapGestureRecognizer *tapMeGusta;
	
	NSArray *QuoteArray;
	
	UIView *footer;
}

-(void)viewDidAppear:(BOOL)animated {
	if ([UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedImagePath"]]] != nil)
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoadingLastEdit"];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.title = @"";
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : TextColor, NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"]) {
		 MeGusta = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MeGustaW"]];
		self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	}
	else {
		 MeGusta = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MeGusta"]];
		self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceDefault;
	}
	if ([UIScreen mainScreen].bounds.size.width > 320)
		self.navigationItem.titleView = MeGusta;
	
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil]];
	self.tableView.backgroundColor = DefColor;
	self.tableView.backgroundView.backgroundColor = DefColor;
	self.view.backgroundColor = DefColor;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.backgroundColor = DefColor;
	self.searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = DefColor;
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchBar.translucent = YES;
	self.searchDisplayController.searchBar.backgroundColor = DefColor;
	self.searchDisplayController.searchBar.tintColor = TextColor;
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:15.0f], NSForegroundColorAttributeName: TextColor}];
	
	self.navigationController.navigationBar.tintColor = TextColor;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	[self.navigationController.navigationBar setBarTintColor:DefColor];
	
	[self.tableView reloadData];
	
	self.tableView.tableFooterView.backgroundColor = DefColor;
	self.tableView.tableFooterView.tintColor = DefColor;
	self.tableView.tableFooterView.layer.backgroundColor = (__bridge CGColorRef)(DefColor);
	
	// Add a frakking footer here...
	footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 620)];
	footer.backgroundColor = [UIColor clearColor];
	
	UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.text = [NSString stringWithFormat:@"%li MEMES", (long)[AllMemes count]];
	lbl.alpha = 0.9;
	[lbl setTextAlignment:NSTextAlignmentCenter];
	[lbl setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:18.0]];
	[lbl setTextColor:TextColor];
	[footer addSubview:lbl];
	
	UITextView *informationLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, 25, self.view.frame.size.width - 20, 190)];
	[informationLabel setBackgroundColor:[UIColor clearColor]];
	[informationLabel setText:[NSString stringWithFormat:@"Select or search a meme.\nAdd your own images.\nSwipe up to bring up editing options.\nSwipe left and right to switch between options.\nPinch to set text size.\nTwo finger pan to place top or bottom text, tap the button on the right to select. Shake to reset position.\nSwipe on text field to add default text (The title in most cases).\nShare with friends and the internet."]];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"])
		[informationLabel setTextColor:[UIColor blackColor]];
	else
		[informationLabel setTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
	[informationLabel setTextAlignment:NSTextAlignmentCenter];
	[informationLabel setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:16.0f]];
	[informationLabel setAlpha:0.6];
	[informationLabel setEditable:NO];
	[informationLabel setSelectable:NO];
	[footer addSubview:informationLabel];
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 233, self.view.frame.size.width, 1)];
	line.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
	[footer addSubview:line];
	
	UILabel *autoDismissLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 250, self.view.frame.size.width - 65, 31)];
	autoDismissLabel.backgroundColor = [UIColor clearColor];
	autoDismissLabel.text = [NSString stringWithFormat:@"Auto Dismiss (Turning this on will dismiss the font options as you select any option)"];
	autoDismissLabel.alpha = 0.9;
	[autoDismissLabel setNumberOfLines:3];
	[autoDismissLabel setTextAlignment:NSTextAlignmentJustified];
	[autoDismissLabel setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	[autoDismissLabel setTextColor:TextColor];
	[footer addSubview:autoDismissLabel];
	
	autoDismissSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 249, 51, 31)];
	[autoDismissSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoDismiss"]];
	[autoDismissSwitch setOnTintColor:TextColor];
	[autoDismissSwitch addTarget:self action:@selector(AutoDismissAction) forControlEvents:UIControlEventValueChanged];
	[footer addSubview:autoDismissSwitch];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 293, self.view.frame.size.width, 1)];
	line2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
	[footer addSubview:line2];
	
	UILabel *resetSettingsLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 305, self.view.frame.size.width - 65, 45)];
	resetSettingsLabel.backgroundColor = [UIColor clearColor];
	resetSettingsLabel.text = [NSString stringWithFormat:@"Reset Settings on launch (Enabling this function will reset the text editing settings on launch, i.e. no preservations in settings, what was yellow will remain yellow.)"];
	resetSettingsLabel.alpha = 0.9;
	[resetSettingsLabel setNumberOfLines:3];
	[resetSettingsLabel setTextAlignment:NSTextAlignmentJustified];
	[resetSettingsLabel setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	[resetSettingsLabel setTextColor:TextColor];
	[footer addSubview:resetSettingsLabel];
	
	resetSettingsOnLaunchSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 312, 51, 31)];
	[resetSettingsOnLaunchSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"ResetSettingsOnLaunch"]];
	[resetSettingsOnLaunchSwitch setOnTintColor:TextColor];
	[resetSettingsOnLaunchSwitch addTarget:self action:@selector(ResetSettingsOnLaunchAction) forControlEvents:UIControlEventValueChanged];
	[footer addSubview:resetSettingsOnLaunchSwitch];
	
	UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 362, self.view.frame.size.width, 1)];
	line3.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
	[footer addSubview:line3];
	
	UILabel *continuousEditingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 374, self.view.frame.size.width - 65, 45)];
	continuousEditingLabel.backgroundColor = [UIColor clearColor];
	continuousEditingLabel.text = [NSString stringWithFormat:@"Continuous Editing (Turning this off will prevent generation of text on image as you enter it, but may help in saving battery as it uses slightly more CPU than non continuous)"];
	continuousEditingLabel.alpha = 0.9;
	[continuousEditingLabel setNumberOfLines:3];
	[continuousEditingLabel setTextAlignment:NSTextAlignmentJustified];
	[continuousEditingLabel setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	[continuousEditingLabel setTextColor:TextColor];
	[footer addSubview:continuousEditingLabel];
	
	continuousEditingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 381, 51, 31)];
	[continuousEditingSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"ContinuousEditing"]];
	[continuousEditingSwitch setOnTintColor:TextColor];
	[continuousEditingSwitch addTarget:self action:@selector(ContinuousEditingAction) forControlEvents:UIControlEventValueChanged];
	[footer addSubview:continuousEditingSwitch];
	
	UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 433, self.view.frame.size.width, 1)];
	line4.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
	[footer addSubview:line4];
	
	UILabel *darkModeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 442, self.view.frame.size.width - 65, 31)];
	darkModeLabel.backgroundColor = [UIColor clearColor];
	darkModeLabel.text = [NSString stringWithFormat:@"Dark Mode"];
	darkModeLabel.alpha = 0.9;
	[darkModeLabel setNumberOfLines:3];
	[darkModeLabel setTextAlignment:NSTextAlignmentJustified];
	[darkModeLabel setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0]];
	[darkModeLabel setTextColor:TextColor];
	[footer addSubview:darkModeLabel];
	
	darkModeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 440, 51, 31)];
	[darkModeSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"]];
	[darkModeSwitch setOnTintColor:TextColor];
	[darkModeSwitch addTarget:self action:@selector(DarkModeAction) forControlEvents:UIControlEventValueChanged];
	[footer addSubview:darkModeSwitch];
	
	UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 478, self.view.frame.size.width, 1)];
	line5.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
	[footer addSubview:line5];
	
	UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 493, self.view.frame.size.width - 20, 20)];
	lbl2.backgroundColor = [UIColor clearColor];
	lbl2.text = [NSString stringWithFormat:@"Created by Avikant Saini."];
	lbl2.alpha = 0.4;
	[lbl2 setTextAlignment:NSTextAlignmentRight];
	[lbl2 setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"])
		[lbl2 setTextColor:[UIColor blackColor]];
	else
		[lbl2 setTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
	[footer addSubview:lbl2];
	
	UIButton *mailButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 490, 20, 20)];
	[mailButton setImage:[UIImage imageNamed:@"Mail"] forState:UIControlStateNormal];
	[mailButton setAlpha:0.5];
	[mailButton addTarget:self action:@selector(Contact) forControlEvents:UIControlEventValueChanged];
	[footer addSubview:mailButton];
	
	UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 585, self.view.frame.size.width , 20)];
	lbl3.backgroundColor = [UIColor clearColor];
	lbl3.text = [NSString stringWithFormat:@"MAKE MEMES • BE AWESOME"];
	lbl3.alpha = 0.2;
	[lbl3 setTextAlignment:NSTextAlignmentCenter];
	[lbl3 setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"])
		[lbl3 setTextColor:[UIColor blackColor]];
	else
		[lbl3 setTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
	[footer addSubview:lbl3];
	
	self.tableView.tableFooterView = footer;
	
	QuoteArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Quotes" ofType:@"json"]] options:NSJSONReadingAllowFragments error:nil];
	
	topView *topV = [[[NSBundle mainBundle] loadNibNamed:@"topView" owner:self options:nil] objectAtIndex:0];
	[topV setFrame:CGRectMake(0, -(self.view.frame.size.height), self.view.frame.size.width, self.view.frame.size.height)];
	topV.QuoteLabel.text = [NSString stringWithFormat:@"%@", [QuoteArray objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"TimesLaunched"]%100]];
	topV.QuoteLabel.font = [UIFont fontWithName:@"AvenirCondensedHand" size:16.0f];
	topV.backgroundColor = DefColor;
	if (![darkModeSwitch isOn])
		topV.QuoteLabel.textColor = [UIColor colorWithWhite:0.1 alpha:0.8];
	else
		topV.QuoteLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	[self.tableView addSubview:topV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LibCamPickUp"];
	
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
	
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_photoGalleryButton, _cameraButton, _lastEditButton, nil];
	self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_collectionViewButton, _menuButton, _searchButton, nil];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.backgroundColor = DefColor;
	self.navigationController.view.backgroundColor = DefColor;
	self.navigationController.title = @"";
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:50/255.0 green:100/255.0 blue:0 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil]];
	self.tableView.contentOffset = CGPointMake(0.0, 44.0);
	self.tableView.backgroundColor = DefColor;
	self.tableView.backgroundView.backgroundColor = DefColor;
	self.view.backgroundColor = DefColor;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.backgroundColor = DefColor;
	self.searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = DefColor;
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.contentOffset = CGPointMake(0.0, 20.0);
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DarkMode"])
		self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	else
		self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
	self.searchDisplayController.searchBar.translucent = NO;
	self.searchDisplayController.searchBar.backgroundColor = DefColor;
	self.searchDisplayController.searchBar.tintColor = [UIColor colorWithRed:51.0/255 green:104.0/255 blue:0.0 alpha:1];
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:15.0f], NSForegroundColorAttributeName: TextColor}];
	
	if ([UIScreen mainScreen].bounds.size.width > 320)
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
	
//	[self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"Settings"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
//	[self.searchDisplayController.searchBar setPositionAdjustment:UIOffsetMake(-10, 0) forSearchBarIcon:UISearchBarIconBookmark];

//	_pageImages = @[@"Screen1.jpg",
//					@"Screen2.jpg",
//					@"Screen3.jpg",
//					@"Screen4.jpg"];
	
//	[self.tableView setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
//	[self.tableView setAlpha:0.0];
//	[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		[self.tableView setTransform:CGAffineTransformIdentity];
//		[self.tableView setAlpha:1.0];
//	}completion:nil];
	
}

#pragma mark - Switches

- (void)AutoDismissAction {
	if (![autoDismissSwitch isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoDismiss"];
		[autoDismissSwitch setOn:NO animated:YES];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoDismiss"];
		[autoDismissSwitch setOn:YES animated:YES];
	}
}

- (void)ContinuousEditingAction {
	if (![continuousEditingSwitch isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ContinuousEditing"];
		[continuousEditingSwitch setOn:NO animated:YES];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ContinuousEditing"];
		[continuousEditingSwitch setOn:YES animated:YES];
	}
}

- (void)ResetSettingsOnLaunchAction {
	if (![resetSettingsOnLaunchSwitch isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ResetSettingsOnLaunch"];
		[resetSettingsOnLaunchSwitch setOn:NO animated:YES];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ResetSettingsOnLaunch"];
		[resetSettingsOnLaunchSwitch setOn:YES animated:YES];
	}
}

- (void)DarkModeAction {
	if (![darkModeSwitch isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DarkMode"];
		[darkModeSwitch setOn:NO animated:YES];
		TextColor = [UIColor colorWithRed:50/255.0 green:100/255.0 blue:0 alpha:1];
		DefColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:239/255.0 alpha:1];

	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DarkMode"];
		[darkModeSwitch setOn:YES animated:YES];
		DefColor = [UIColor colorWithWhite:0.12 alpha:1.0];
		TextColor = [UIColor colorWithRed:170/255.0 green:250/255.0 blue:120.0/255 alpha:0.7];
	}
	[self viewDidAppear:YES];
	CGPoint offset = CGPointMake(0, 64*[ArrayOfMemeObjects count] + 620 - self.view.frame.size.height);
	[self.tableView setContentOffset:offset animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Search display results

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	NSPredicate *resultPredicate = [NSPredicate
									predicateWithFormat:@"Tags contains[cd] %@",
									searchText];
	
	SearchResults = [[NSMutableArray alloc]initWithArray:[AllMemes filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filterContentForSearchText:searchString
							   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
									  objectAtIndex:[self.searchDisplayController.searchBar
													 selectedScopeButtonIndex]]];
	return YES;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return [SearchResults count];
	else
		return [AllMemes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableCell *cell = (TableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
	if(cell == nil)
		cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
	
	MemeObject *meme = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
		meme = [SearchResults objectAtIndex:indexPath.row];
	else
		meme = [AllMemes objectAtIndex:indexPath.row];
	cell.cellTitle.text = [NSString stringWithFormat:@"%@", meme.Name];
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"%@", meme.Image]];
	cell.cellImage.image = [self imageByCroppingImage:image toSize:CGSizeMake(MIN(image.size.width, image.size.height), MIN(image.size.width, image.size.height))];
	
	cell.cellTitle.textColor = TextColor;
	cell.backgroundColor = DefColor;
	cell.backgroundView.backgroundColor = DefColor;
	
	return cell;
}

-(UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size{
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (self.searchDisplayController.isActive) {
		if ([SearchResults count] > 1)
			return [NSString stringWithFormat:@"%li Results", (long)[SearchResults count]];
		else if ([SearchResults count] == 1)
			return [NSString stringWithFormat:@"1 Result"];
		else
			return @"No Results";
	}
	return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (self.searchDisplayController.isActive) {
		UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 30)];
		header.backgroundColor = DefColor;
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
		lbl.backgroundColor = DefColor;
		lbl.alpha = 1.0;
		[lbl setTextAlignment:NSTextAlignmentCenter];
		[lbl setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:18.0]];
		[lbl setTextColor:TextColor];
		lbl.text = [self tableView:tableView titleForHeaderInSection:section];
		[header addSubview:lbl];
		return header;
	}
	UIView *nilView = [[UIView alloc] initWithFrame:CGRectZero];
	return nilView;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
	footer.backgroundColor = [UIColor clearColor];
	
	UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 20)];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.text = [NSString stringWithFormat:@"%li MEMES", (long)[AllMemes count]];
	lbl.alpha = 0.9;
	[lbl setTextAlignment:NSTextAlignmentCenter];
	[lbl setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:18.0]];
	[lbl setTextColor:[UIColor colorWithRed:51.0/255 green:104.0/255 blue:0 alpha:1]];
	[footer addSubview:lbl];
	
	UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width - 20, 20)];
	lbl2.backgroundColor = [UIColor clearColor];
	lbl2.text = [NSString stringWithFormat:@"Created by @avikantz for the glory of Satan."];
	lbl2.alpha = 0.4;
	[lbl2 setTextAlignment:NSTextAlignmentRight];
	[lbl2 setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	[lbl2 setTextColor:[UIColor blackColor]];
	[footer addSubview:lbl2];
	
	UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 125, self.view.frame.size.width - 20, 20)];
	lbl3.backgroundColor = [UIColor clearColor];
	lbl3.text = [NSString stringWithFormat:@"What, you were expecting more stuff here?"];
	lbl3.alpha = 0.4;
	[lbl3 setTextAlignment:NSTextAlignmentLeft];
	[lbl3 setFont: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:14.0]];
	[lbl3 setTextColor:[UIColor blackColor]];
	[footer addSubview:lbl3];
	
	self.tableView.tableFooterView=footer;
	return footer;
}

*/

-(void)Contact {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
		[mail setMailComposeDelegate:self];
		[mail setSubject:@"Feedback..."];
		NSArray *toRecipients = [NSArray arrayWithObjects:@"avikantsainidbz@gmail.com", nil];
		[mail setToRecipients:toRecipients];
		NSString *emailBody = @"Hey Developer...\n\n";
		[mail setMessageBody:emailBody isHTML:NO];
		mail.modalPresentationStyle = UIModalPresentationPageSheet;
		[self presentViewController:mail animated:YES completion:nil];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What year is this?!" message:@"Your device cannot send or recieve e-mails!" delegate:nil cancelButtonTitle:@"Uhh.... Okay!" otherButtonTitles: nil];

		[alert show];
	}
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
	view.alpha = 0.5;
	view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3);
	[UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
		view.alpha = 1;
		view.layer.transform = CATransform3DIdentity;
	}completion:nil];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"toDetail"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LibCamPickUp"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadingLastEdit"];
		MemeObject *meme = nil;
		NSIndexPath *indexPath = nil;
		if(self.searchDisplayController.active) {
			indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			meme = [SearchResults objectAtIndex:indexPath.row];
		}
		else {
			indexPath = [self.tableView indexPathForSelectedRow];
			meme = [AllMemes objectAtIndex:indexPath.row];
		}
		
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
		[self.tableView reloadData];
	}
	if ([title isEqualToString:@"By Popularity"]) {
		[self viewDidLoad];
		[self.tableView reloadData];
	}
}

- (IBAction)SearchAction:(id)sender {
	[self.searchDisplayController.searchBar becomeFirstResponder];
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

- (IBAction)collectionViewAction:(id)sender {
	
}

- (void)imagePickerController:(UIImagePickerController *)pick didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadingLastEdit"];
}

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pick {
	[pick dismissViewControllerAnimated:YES completion:NULL];
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoadingLastEdit"];
}

#pragma mark - Page View Controller Data Source

/*
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
	if (([self.pageImages count] == 0) || (index >= [self.pageImages count]))
		return nil;
	PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContent"];
	pageContentViewController.imageFile = self.pageImages[index];
	pageContentViewController.pageIndex = index;
	return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
	if ((index == 0) || (index == NSNotFound))
		return nil;
	index--;
	return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
	if (index == NSNotFound)
		return nil;
	index++;
	if (index == [self.pageImages count])
		return nil;
	return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
	return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
	return 0;
}
 */

@end
