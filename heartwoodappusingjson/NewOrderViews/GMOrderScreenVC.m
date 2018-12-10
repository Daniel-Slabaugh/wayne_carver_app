//
//  GMOrderScreenVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GlobalVariables.h"

#import "User.h"
#import "GMOrderLine.h"
#import "GMOrderScreenVC.h"
#import "GMOrderOverviewVC.h"
#import "GMItemVC.h"
#import "GMItem.h"
#import "GMArtNameVC.h"

#define DELETE              @"deleteOrders"
#define BACK                @"goBack"
#define NEW                 @"NewLine"
//#define EDIT                @"EditLine"
#define ART                 @"SelectingArt"
#define NAME                @"SelectingName"


@interface GMOrderScreenVC ()

@property (nonatomic, strong) UIPopoverController *detailViewPopover;
@property (nonatomic, strong) id lastTappedButton;


@end

@implementation GMOrderScreenVC
@synthesize orderLineArray;
@synthesize orderHeaderInfo;
@synthesize alertAction;
@synthesize cellSelected;
@synthesize artNumbers;
@synthesize nameDrop;
@synthesize txtArt1;
@synthesize txtArt2;
@synthesize txtArt3;
@synthesize txtArt4;
@synthesize txtArt5;
@synthesize txtArt6;
@synthesize txtNewCustomArt1;
@synthesize txtNewCustomArt2;
@synthesize txtNewCustomArt3;
@synthesize newArt;
@synthesize txtOptionalNameDrop1;
@synthesize txtOptionalNameDrop2;
@synthesize txtOptionalNameDrop3;
@synthesize btnSave;
@synthesize btnCancel;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // to hide keyboard when outside is tapped
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tapScroll];
    
    //configure txtfields for tabbing through them
    [txtArt1 setDelegate:self];
    [txtArt2 setDelegate:self];
    [txtArt3 setDelegate:self];
    [txtArt4 setDelegate:self];
    [txtArt5 setDelegate:self];
    [txtArt6 setDelegate:self];
    [txtOptionalNameDrop1 setDelegate:self];
    [txtOptionalNameDrop2 setDelegate:self];
    [txtOptionalNameDrop3 setDelegate:self];
    [txtNewCustomArt1 setDelegate:self];
    [txtNewCustomArt2 setDelegate:self];
    [txtNewCustomArt3 setDelegate:self];
    txtArt1.tag = 0;
    txtArt2.tag = 1;
    txtArt3.tag = 2;
    txtArt4.tag = 3;
    txtArt5.tag = 4;
    txtArt6.tag = 5;
    txtOptionalNameDrop1.tag = 6;
    txtOptionalNameDrop2.tag = 7;
    txtOptionalNameDrop3.tag = 8;
    txtNewCustomArt1.tag = 10;
    txtNewCustomArt2.tag = 11;
    txtNewCustomArt3.tag = 12;
    
    orderLineView.frame = CGRectMake(0, 650, 768, (150 + (65*self.orderLineArray.count)));
    btnSave.frame = CGRectMake(204, (825 + (65*self.orderLineArray.count)), 360, 75);
    //    btnCancel.frame = CGRectMake(388, (825 + (65*orderLineArray.count)), 360, 75);
    
    //draw borders on tableview
    orderLineView.layer.borderWidth = 2.5f;
    orderLineView.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    
    // notification for updating table
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"GMOUpdateData"
                                               object:nil];
    
    //drawing art box lines
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(15.0, 220.0)];
    [path addLineToPoint:CGPointMake(750.0, 220.0)];
    
    [path moveToPoint:CGPointMake(15.0, 500.0)];
    [path addLineToPoint:CGPointMake(750.0, 500.0)];
    
    [path moveToPoint:CGPointMake(15.0, 220.0)];
    [path addLineToPoint:CGPointMake(15.0, 500.0)];
    
    [path moveToPoint:CGPointMake(750.0, 220.0)];
    [path addLineToPoint:CGPointMake(750.0, 500.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    shapeLayer.lineWidth = 2.5;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [scrollView.layer addSublayer:shapeLayer];
    //    [self.layer addSublayer:shapeLayer];
}

- (void) viewWillAppear:(BOOL) animated {
    
    // set up ItemOrderlist for tableview
    self.orderLineArray = [[NSMutableArray alloc] init];
    self.orderLineArray = [GMOrderLine getOrderLinesWhere:self.orderHeaderInfo.OrderNum];
    
    // initialize scroll view
    [self->scrollView setContentSize:CGSizeMake(768, (1250 + (65*self.orderLineArray.count)))];
    self->scrollView.frame = CGRectMake(0, 0, 768, 1200); //(1600+ (65*self.orderLineArray.count))
    
    [self.view addSubview:self->scrollView];
    
    orderLineView.frame = CGRectMake(0, 650, 768, (150 + (65*self.orderLineArray.count)));
    btnSave.frame = CGRectMake(204, (825 + (65*self.orderLineArray.count)), 360, 75);
    //    btnCancel.frame = CGRectMake(388, (825 + (65*self.orderLineArray.count)), 360, 75);
    
    [super viewWillAppear:animated];
    
    alertAction = @"";
    [orderLineView reloadData];
}

#pragma Item Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return (self.orderLineArray.count +1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"GMOrderLineCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    //remove all previous buttons and labels added to cell subview
    for (UIButton* tmpbtn in cell.subviews) {
//        for (UIButton*tmpSubviewbtn in tmpbtn.subviews) { // this is for if the double subview model still needs to work.
            if ([tmpbtn isKindOfClass:[UIButton class]]) { // change all of these back to tmpSubviewbtn for double subview model
                [tmpbtn removeFromSuperview];
            } else if ([tmpbtn isKindOfClass:[UILabel class]]) {
                [tmpbtn removeFromSuperview];
            }
//        }
    }
    
    
    if (indexPath.row == 0) {
        if (self.orderLineArray.count == 0) {
            cell.textLabel.text = @"Add Item";
        } else {
            cell.textLabel.text = @"Add Another Item";
        }
        cell.detailTextLabel.text = @"New Item";
    } else {
        GMOrderLine *tmpOrderLine = nil;
        tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
        
        //insert description label
        UILabel *lblDescription = [[UILabel alloc] init];
        lblDescription.frame = CGRectMake(5.0, 5.0, 275.0, 55.0);
        lblDescription.text =  [NSString stringWithFormat:@"%@", [GMItem getItemDesc:tmpOrderLine.ItemNum]];
        [lblDescription setFont:[UIFont boldSystemFontOfSize:20]];
        [lblDescription setTextAlignment:NSTextAlignmentLeft];
        [lblDescription setAdjustsFontSizeToFitWidth:YES];
        [lblDescription setMinimumScaleFactor:.5];
        [lblDescription setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        [cell addSubview:lblDescription];
        
        //        //insert edit label under description label
        //        UILabel *lblEditItem = [[UILabel alloc] init];
        //        lblEditItem.frame = CGRectMake(87.0, 40.0, 100.0, 15.0);
        //        lblEditItem.text =  @"Tap to edit";
        //        [lblEditItem setFont:[UIFont boldSystemFontOfSize:15]];
        //        [lblEditItem setTextAlignment:NSTextAlignmentLeft];
        //        [lblEditItem setTextColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
        //        [cell addSubview:lblEditItem];
        
        GMItem* tmpItem = [GMItem getItemWhere:tmpOrderLine.ItemNum];
        if (tmpItem.NameDropOnly == 0) {
            //insert Art # Button
            UIButton *btnArt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnArt.frame = CGRectMake(290.0, 5.0, 160.0, 55.0);
            [btnArt.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [btnArt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnArt addTarget:self action:@selector(btnArt:) forControlEvents:UIControlEventTouchUpInside];
            [btnArt.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [btnArt.titleLabel setMinimumScaleFactor:.5];
            [btnArt.titleLabel setTextAlignment:NSTextAlignmentCenter];
            if ([tmpOrderLine.ArtNum isEqual:@"(null)"]) {
                [btnArt setTitle: @"Select Art" forState:UIControlStateNormal];
                btnArt.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
                [btnArt.layer setBorderWidth:2];
            } else {
                [btnArt setTitle:[NSString stringWithFormat:@"Art: %@", tmpOrderLine.ArtNum] forState:UIControlStateNormal];
            }
            [cell addSubview:btnArt];
            
            //insert edit Art # label
            if (![tmpOrderLine.ArtNum isEqual:@"(null)"]) {
                UILabel *lblEditArt = [[UILabel alloc] init];
                lblEditArt.frame = CGRectMake(320.0, 40.0, 100.0, 15.0);
                lblEditArt.text =  @"Tap to edit";
                [lblEditArt setTextAlignment:NSTextAlignmentCenter];
                [lblEditArt setFont:[UIFont boldSystemFontOfSize:15]];
                [lblEditArt setTextColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
                [cell addSubview:lblEditArt];
            }
        }
        
        //insert Optional Name Drop Button
        UIButton *btnNameDrop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnNameDrop setClearsContextBeforeDrawing:YES];
        btnNameDrop.frame = CGRectMake(460.0, 5.0, 160.0, 55.0);
        [btnNameDrop.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [btnNameDrop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnNameDrop addTarget:self action:@selector(btnNameDrop:) forControlEvents:UIControlEventTouchUpInside];
        [btnNameDrop.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btnNameDrop.titleLabel setMinimumScaleFactor:.5];
        [btnNameDrop.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if ([tmpOrderLine.NameDrop isEqual:@"(null)"]) {
            [btnNameDrop setTitle: @"Select Name" forState:UIControlStateNormal];
            btnNameDrop.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
            [btnNameDrop.layer setBorderWidth:2];
        } else {
            [btnNameDrop setTitle:[NSString stringWithFormat:@"Name: %@", tmpOrderLine.NameDrop] forState:UIControlStateNormal];
        }
        [cell addSubview:btnNameDrop];
        
        //insert edit Name Drop # label
        UILabel *lblEditNameDrop = [[UILabel alloc] init];
        lblEditNameDrop.frame = CGRectMake(490.0, 40.0, 100.0, 15.0);
        [lblEditNameDrop setFont:[UIFont boldSystemFontOfSize:15]];
        [lblEditNameDrop setTextAlignment:NSTextAlignmentCenter];
        if ([tmpOrderLine.NameDrop isEqual:@"(null)"]) {
            lblEditNameDrop.text =  @"(Optional)";
            lblEditNameDrop.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
        } else {
            lblEditNameDrop.text =  @"Tap to edit";
            [lblEditNameDrop setTextColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
        }
        [cell addSubview:lblEditNameDrop];
        
        //insert quantity text field
        UITextField *txtField = [[UITextField alloc] init];
        txtField.frame = CGRectMake(0, 10, 100, 40);
        [txtField setFont:[UIFont boldSystemFontOfSize:40]];
        [txtField setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        [txtField addTarget:self action:@selector(cellTextFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [txtField addTarget:self action:@selector(cellTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [txtField addTarget:self action:@selector(cellTextFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [txtField setDelegate:self];
        [txtField setReturnKeyType:UIReturnKeyDone];
        [txtField setKeyboardType:UIKeyboardTypeNumberPad];
        [cell setAccessoryView:txtField];
        txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.Quantity];
        
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.row != 0) {
            GMOrderLine* tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
            
            [GMOrderLine deleteWhereLine:tmpOrderLine.PKID];
            
            [self viewWillAppear:YES];
        } else {
            editingStyle = UITableViewCellEditingStyleNone;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [self saveData];
    
    if (indexPath.row == 0) {
        GMItemVC *itemView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMItemVC"];
        itemView.orderLineArray = [GMOrderLine getOrderLinesWhere:self.orderHeaderInfo.OrderNum];
        itemView.status = NEW;
        itemView.orderLineInfo = [[GMOrderLine alloc] init];
        itemView.orderLineInfo.OrderNum = self.orderHeaderInfo.OrderNum;
        itemView.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController presentViewController:itemView animated:YES completion:nil];
    } else {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
        //        GMItemVC *itemView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMItemVC"];
        //        itemView.orderLineArray = [GMOrderLine getOrderLinesWhere:self.orderHeaderInfo.OrderNum];
        //        itemView.status = EDIT;
        //        itemView.orderLineInfo = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
        //        itemView.modalPresentationStyle = UIModalPresentationFormSheet;
        //        [self.navigationController presentViewController:itemView animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Items In Order";
}

#pragma mark - Other methods

- (IBAction)btnSave:(id)sender {
    BOOL goBack = YES;
    [self saveData];
    
    if (self.orderLineArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing Ordered"
                                                        message:@"You have not ordered anything. Are you sure you want to exit?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Exit", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        alertAction = BACK;
        goBack = NO;
        [alert show];
    } else {
        for (GMOrderLine* tmpOrderLine in self.orderLineArray) {
            if(tmpOrderLine.Quantity == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"No, %@ ordered", tmpOrderLine.ItemNum]
                                                                message:[NSString stringWithFormat:@"You have selected %@. Please either order some or delete them from your order.", tmpOrderLine.ItemNum]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                goBack = NO;
                [alert show];
            } else if ([tmpOrderLine.ArtNum isEqual:@"(null)"]) {
                GMItem *tmpItem = [GMItem getItemWhere:tmpOrderLine.ItemNum];
                if (tmpItem.NameDropOnly == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"No art for %@", tmpOrderLine.ItemNum]
                                                                    message:[NSString stringWithFormat:@"You have not selected an art for %@. Please select an art or pick the \"No Art\" option", tmpOrderLine.ItemNum]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    goBack = NO;
                    [alert show];
                }
            }
        }
    }
    
    if (goBack == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
// code for iOS 8
//    
//    //    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//    //                                                                   message:@"This is an alert."
//    //                                                            preferredStyle:UIAlertControllerStyleAlert];
//    //
//    //    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//    //                                                          handler:^(UIAlertAction * action) {
//    //                                                              [alert dismissViewControllerAnimated:YES completion:nil];
//    //                                                          }];
//    //    [alert addAction:defaultAction];
//    //    [self presentViewController:alert animated:YES completion:nil];
//    
//    BOOL goBack = YES;
//    [self saveData];
//    
//    if (self.orderLineArray.count == 0) {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Nothing Ordered"
//                                                                       message:@"You have ordered anything. Are you sure you want to exit?"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
//                                                              handler:^(UIAlertAction * action) {
//                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
//                                                              }];
//        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action) {
//                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                   [self.navigationController popViewControllerAnimated:YES];
//                                                               }];
//        [alert addAction:defaultAction];
//        [alert addAction:defaultAction2];
//        [self presentViewController:alert animated:YES completion:nil];
//        [alert release];
//        goBack = NO;
//
//    } else {
//        for (GMOrderLine* tmpOrderLine in self.orderLineArray) {
//            if(tmpOrderLine.Quantity == 0) {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"No, %@ ordered", tmpOrderLine.ItemNum]
//                                                                               message:[NSString stringWithFormat:@"You have selected %@. Please either order some or delete them from your order.", tmpOrderLine.ItemNum]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
//                                                                      handler:^(UIAlertAction * action) {
//                                                                          [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                      }];
//                [alert addAction:defaultAction];
//                [self presentViewController:alert animated:YES completion:nil];
//                [alert release];
//                goBack = NO;
//            } else if ([tmpOrderLine.ArtNum isEqual:@"(null)"]) {
//                GMItem *tmpItem = [GMItem getItemWhere:tmpOrderLine.ItemNum];
//                if (tmpItem.NameDropOnly == 0) {
//                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"No art for %@", tmpOrderLine.ItemNum]
//                                                                                   message:[NSString stringWithFormat:@"You have not selected an art for %@. Please select an art or pick the \"No Art\" option", tmpOrderLine.ItemNum]
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {
//                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                          }];
//                    [alert addAction:defaultAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                    [alert release];
//                    goBack = NO;
//                }
//            }
//        }
//    }
//    
//    if (goBack == YES) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (IBAction)btnCancel:(id)sender {
    //    GMOrderOverviewVC *overviewView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMOrderOverviewVC"];
    //    [self.navigationController pushViewController:overviewView animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertAction isEqualToString:BACK]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"GMOUpdateData"]) {
        [self saveData];
        [orderLineView reloadData];
        [self viewWillAppear:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) tapped {
    [self.view endEditing:YES];
}

#pragma table button/text functions

-(void)cellTextFieldDidBeginEditing:(UITextField *)txtField {
    cellSelected = (UITableViewCell*)[txtField superview];
    
    [scrollView setContentOffset:CGPointMake(0,(150 + (65*self.orderLineArray.count))) animated:YES];
    
}

- (void)cellTextFieldDidChange:(UITextField*)txtField {
    cellSelected = (UITableViewCell*)[txtField superview];
    
    NSIndexPath *indexPath = [orderLineView indexPathForCell:cellSelected];
    
    GMOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
    tmpOrderLine.Quantity = [txtField.text intValue];
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.Quantity];
    [self count];
}

-(void)cellTextFieldDidEndEditing:(UITextField *)txtField{
    cellSelected = (UITableViewCell*)[txtField superview];
    
    NSIndexPath *indexPath = [orderLineView indexPathForCell:cellSelected];
    
    GMOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
    GMItem *tmpItem = [GMItem getItemWhere:tmpOrderLine.ItemNum];
    
    if ([txtField.text intValue] < tmpItem.Minimum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Must order at least %ld pieces", (long)tmpItem.Minimum]
                                                        message:[NSString stringWithFormat:@"The minimum amount you can order for this item is %ld, you must order at least that many", (long)tmpItem.Minimum]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        alertAction = @"";
        [alert show];
        tmpOrderLine.Quantity = 0;
    } else if ([txtField.text intValue]%tmpItem.Increment != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Must order in increments of %ld pieces", (long)tmpItem.Increment]
                                                        message:[NSString stringWithFormat:@"You must order in increments of %ld pieces: %ld, %ld, %ld, etc...", (long)tmpItem.Increment, (long)tmpItem.Minimum, ((long)tmpItem.Minimum + (long)tmpItem.Increment), ((long)tmpItem.Minimum + (long)tmpItem.Increment*2)]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        alertAction = @"";
        [alert show];
        tmpOrderLine.Quantity = ([txtField.text intValue] - [txtField.text intValue]%tmpItem.Increment);
    }
    
    [GMOrderLine updateOrderLine:tmpOrderLine];
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.Quantity];
    
    cellSelected = nil;
    [self count];
}

-(void)btnArt:(UIButton*)btnArt {
    UITableViewCell *cell = (UITableViewCell*)[btnArt superview];
    NSIndexPath *indexPath = [orderLineView indexPathForCell:cell];
    GMOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
    
    GMArtNameVC *artNameView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMArtNameVC"];
    artNameView.status = ART;
    [self compileArtNumbers];
    artNameView.artNameArray = self.artNumbers;
    artNameView.newArt = self.newArt;
    artNameView.orderLineInfo = tmpOrderLine;
    artNameView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:artNameView animated:YES completion:nil];
}

-(void)btnNameDrop:(UIButton*)btnNameDrop {
    UITableViewCell *cell = (UITableViewCell*)[btnNameDrop superview];
    NSIndexPath *indexPath = [orderLineView indexPathForCell:cell];
    GMOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
    
    GMArtNameVC *artNameView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMArtNameVC"];
    artNameView.status = NAME;
    [self compileNames];
    artNameView.artNameArray = self.nameDrop;
    artNameView.newArt = NO;
    artNameView.orderLineInfo = tmpOrderLine;
    artNameView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:artNameView animated:YES completion:nil];
}

- (void)count {
    numItemsOrdered = 0;
    for (GMOrderLine* orderLine in self.orderLineArray)
        numItemsOrdered += orderLine.Quantity;
    //    btnTxtToFill.titleLabel.text = [NSString stringWithFormat:@"You have picked %ld %@s", (long)numItemsOrdered, itemInfo.ItemNo];
}

- (IBAction)txtNewCustomArt:(id)sender {
    [self compileArtNumbers];
    
    if (newArt == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Custom Art"
                                                        message:@"There is a price for creating a new art that will be determined by wayne carver."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        alertAction = @"";
        [alert show];
    }
    
}

- (void)saveData {
    for (GMOrderLine* gmOrdLne in self.orderLineArray) {
        [GMOrderLine updateOrderLine:gmOrdLne];
    }
    self.orderLineArray = [GMOrderLine getOrderLinesWhere:orderHeaderInfo.OrderNum];
    NSLog(@"data saved!");
}

#pragma art and name compilation

-(void)compileArtNumbers {
    self.artNumbers = [[NSMutableArray alloc] init];
    self.newArt = NO;
    [self addArtNumbers:txtNewCustomArt1.text];
    [self addArtNumbers:txtNewCustomArt2.text];
    [self addArtNumbers:txtNewCustomArt3.text];
    if (artNumbers.count > 0) {
        self.newArt = YES;
    }
    [self addArtNumbers:txtArt1.text];
    [self addArtNumbers:txtArt2.text];
    [self addArtNumbers:txtArt3.text];
    [self addArtNumbers:txtArt4.text];
    [self addArtNumbers:txtArt5.text];
    [self addArtNumbers:txtArt6.text];
    [self addArtNumbers:@"NO ART"];
}

-(void)compileNames {
    self.nameDrop = [[NSMutableArray alloc] init];
    [self addNames:txtOptionalNameDrop1.text];
    [self addNames:txtOptionalNameDrop2.text];
    [self addNames:txtOptionalNameDrop3.text];
}

-(void)addArtNumbers: (NSString*)text {
    if (![[text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self.artNumbers addObject:[text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
    }
}

-(void)addNames: (NSString*)text {
    if (![[text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self.nameDrop addObject:[text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end