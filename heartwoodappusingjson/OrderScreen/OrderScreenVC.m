//
//  OrderScreenVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/17/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "OrderScreenVC.h"
#import "UserVC.h"
#import <QuartzCore/QuartzCore.h>
#import "EditingScreenVC.h"
#import "BadItemVC.h"

#import "User.h"
#import "Name.h"
#import "OrderHeader.h"
#import "OrderLine.h"
#import "OrderDetail.h"

#define SAVE @"Save"
#define EXIT @"Exit"

@interface OrderScreenVC ()

@end

@implementation OrderScreenVC
@synthesize inputAccessoryView;
@synthesize cellSelected;
@synthesize itemInfo;
@synthesize btnTxtToFill;
@synthesize allTableData;
@synthesize filteredTableData;
@synthesize letters;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize btnBadItems;
@synthesize orderlineinfo;
@synthesize alertViewAction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up fields
    btnTxtToFill.titleLabel.text = [NSString stringWithFormat:@"You are picking: %@", itemInfo.ItemNo];
    cellSelected = nil;
    orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    NSMutableArray * unsortedNames = [Name getNamesWhere:itemInfo.Nameset];
    NSArray * sortedNames = [[NSArray alloc] initWithArray:[unsortedNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Name*)a TheName];
        NSString *second = [(Name*)b TheName];
        return [first compare:second];
    }]];
    
    NSMutableArray * orderDetails = [[NSMutableArray alloc]  init];
    
    for (int i = 0; i < sortedNames.count; i++) {
        Name *tmpName = [sortedNames objectAtIndex:i];
        OrderDetail *tmpOrderDetail = [[OrderDetail alloc] init];
        tmpOrderDetail.ItemNo = itemInfo.ItemNo;
        tmpOrderDetail.Nameset = tmpName.Nameset;
        tmpOrderDetail.ProgName = itemInfo.ProgName;
        tmpOrderDetail.Name = tmpName.TheName;
        tmpOrderDetail.NameType = tmpName.NameType;
        tmpOrderDetail.QtyOrdered = 0;
        [orderDetails addObject:tmpOrderDetail];
    }
    self.allTableData = [orderDetails copy];
    
    orderlineinfo = [[OrderLine alloc] init];
    
    
    [self updateTableData:@""];
}

-(void)viewDidAppear:(BOOL)animated {
    orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    [super viewDidAppear:animated];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return letters;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Each letter is a section title
    NSString* key = [letters objectAtIndex:section];
    return key;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of letters in our letter array. Each letter represents a section.
    return letters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Returns the number of items in the array associated with the letter for this section.
    NSString* letter = [letters objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    return arrayForLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"NameCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Grab the object for the specified row and section
    
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tmpOrderDetail.Name;
    
    
    // Text field
    UITextField *txtField = [[UITextField alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        txtField.frame = CGRectMake(0, 10, 100, 40);
        [txtField setFont:[UIFont boldSystemFontOfSize:40]];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        txtField.frame = CGRectMake(0, 10, 40, 30);
        [txtField setFont:[UIFont boldSystemFontOfSize:22]];
    }
    
    [txtField setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    //    [txtField setBackgroundColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
    
    [txtField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [txtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    txtField.keyboardType = UIKeyboardTypeNumberPad;
    cell.accessoryView = txtField;
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    
    
    // Clear Button
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        btnClear.frame = CGRectMake(450.0, 10.0, 100.0, 40.0);
    }
    else
    {
        // The device is an iPhone or iPod touch.
        btnClear.frame = CGRectMake(175.0, 7.0, 50.0, 30.0);
    }
    [btnClear setTitle: @"Clear" forState:UIControlStateNormal];
    btnClear.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    [btnClear.layer setBorderWidth:2];
    [btnClear.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [btnClear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(clearCellTextField:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnClear];
    
    
    return cell;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self updateTableData:text];
}

-(void)updateTableData:(NSString*)searchString {
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (OrderDetail* orderDetail in allTableData)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [orderDetail.Name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            //            NSRange descriptionRange = [orderDetail.description rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) //|| descriptionRange.location != NSNotFound)
                isMatch = true;
        }
        
        // If we have a match...
        if(isMatch)
        {
            if ([orderDetail.NameType isEqual:@"SAYING"]) {
                // Find the first letter of the item's name. This will be its group
                NSString* firstLetter = nil;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    // The device is an iPad running iPhone 3.2 or later.
                    firstLetter = @" Sayings";
                }
                else
                {
                    // The device is an iPhone or iPod touch.
                    firstLetter = @" Say";
                }
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the item to this group's array
                [arrayForLetter addObject:orderDetail];
            } else {
                
                // Find the first letter of the item's name. This will be its group
                NSString* firstLetter = [orderDetail.Name substringToIndex:1];
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the item to this group's array
                [arrayForLetter addObject:orderDetail];
            }
        }
    }
    
    // Make a copy of our dictionary's keys, and sort them
    letters = [[NSArray alloc] initWithArray:[[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    // Finally, refresh the table
    [orderTableView reloadData];
}

- (void)count {
    numItemsOrdered = 0;
    for (OrderDetail* orderDetail in allTableData)
        numItemsOrdered += orderDetail.QtyOrdered;
    btnTxtToFill.titleLabel.text = [NSString stringWithFormat:@"You have picked %ld %@s", (long)numItemsOrdered, itemInfo.ItemNo];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *txtField = (UITextField*)cell.accessoryView;
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
#warning consider
    if ([itemInfo.ItemNo isEqual:@"DR1002"]) {
        tmpOrderDetail.QtyOrdered += 3;
    } else {
        tmpOrderDetail.QtyOrdered++;
    }
    
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    
    
    //    NSArray *subArray = [cell subviews];
    //    for (int i = 0; i < subArray.count; i++) {
    //        if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
    //            UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
    //            NSString* letter = [letters objectAtIndex:indexPath.section];
    //            NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    //            OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    //            tmpOrderDetail.QtyOrdered++;
    //            txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
    //        }
    //    }
    [self count];
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    [self.view endEditing:YES];
    orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)textFieldDidBeginEditing:(UITextField *)txtField {
    cellSelected = (UITableViewCell*)[txtField superview];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 295, 0);
        [orderTableView scrollToRowAtIndexPath:[orderTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0);
        [orderTableView scrollToRowAtIndexPath:[orderTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)textFieldDidChange:(UITextField*)txtField {
    cellSelected = (UITableViewCell*)[txtField superview];
    
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
    
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    NSLog(@"ROW: %ld, Section: %ld, quantity : %d", (long)indexPath.row, (long)indexPath.section, [txtField.text intValue]);
    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    tmpOrderDetail.QtyOrdered = [txtField.text intValue];
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    [self count];
}

-(void)textFieldDidEndEditing:(UITextField *)txtField{
    cellSelected = (UITableViewCell*)[txtField superview];
    
    // changed from [(UITableView *)cellSelected.superview indexPathForCell:cellSelected]
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
    
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    tmpOrderDetail.QtyOrdered = [txtField.text intValue];
    if (tmpOrderDetail.QtyOrdered >= 25) {
        //warn if qtyOrdered is over 24 for one piece
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Warning... Large number of %@ ordered", tmpOrderDetail.Name]
                                                            message:@"You have ordered over 24 pieces of one name, this is uncommon. If this is a mistake, make sure you fix it!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
    }
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    
    cellSelected = nil;
    [self count];
}

-(void)clearCellTextField:(UIButton*)btnClear {
    
    UITableViewCell *cell = (UITableViewCell*)[btnClear superview];
    NSIndexPath *indexPath = [orderTableView indexPathForCell:cell];
    
    UITextField *txtField = (UITextField*)cell.accessoryView;
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    tmpOrderDetail.QtyOrdered = 0;
    txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    [self count];
    
    //    NSArray *subArray = [cell subviews];
    //    for (int i = 0; i < subArray.count; i++) {
    //        if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
    //            UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
    //            NSString* letter = [letters objectAtIndex:indexPath.section];
    //            NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    //            OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
    //            tmpOrderDetail.QtyOrdered = 0;
    //            txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
    //            [self count];
    //        }
    //    }
}

#pragma mark - inputAccessoryView

- (UIView*)inputAccessoryView {
    if (!inputAccessoryView) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iPhone 3.2 or later.
            CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
            inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
            inputAccessoryView.backgroundColor = [[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0];
            
            UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            clear.frame = CGRectMake(20.0, 20.0, 150.0, 37.0);
            [clear setTitle: @"Clear" forState:UIControlStateNormal];
            [clear setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [clear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *plus5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plus5.frame = CGRectMake(210.0, 20.0, 150.0, 37.0);
            [plus5 setTitle: @"+ 5" forState:UIControlStateNormal];
            [plus5 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [plus5 addTarget:self action:@selector(addFive:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *plus10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plus10.frame = CGRectMake(400.0, 20.0, 150.0, 37.0);
            [plus10 setTitle: @"+ 10" forState:UIControlStateNormal];
            [plus10 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [plus10 addTarget:self action:@selector(addTen:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            done.frame = CGRectMake(590.0, 20.0, 150.0, 37.0);
            [done setTitle: @"Done" forState:UIControlStateNormal];
            [done setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [done addTarget:self action:@selector(doneWithKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            
            [inputAccessoryView addSubview:clear];
            [inputAccessoryView addSubview:plus5];
            [inputAccessoryView addSubview:plus10];
            [inputAccessoryView addSubview:done];
        }
        else
        {
            // The device is an iPhone or iPod touch.
            CGRect accessFrame = CGRectMake(0.0, 0.0, 325.0, 50.0);
            inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
            inputAccessoryView.backgroundColor = [[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0];
            
            UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            clear.frame = CGRectMake(10.0, 10.0, 65.0, 30.0);
            [clear setTitle: @"Clear" forState:UIControlStateNormal];
            [clear setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [clear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *plus5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plus5.frame = CGRectMake(87.0, 10.0, 65, 30.0);
            [plus5 setTitle: @"+ 5" forState:UIControlStateNormal];
            [plus5 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [plus5 addTarget:self action:@selector(addFive:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *plus10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plus10.frame = CGRectMake(164.0, 10.0, 65, 30.0);
            [plus10 setTitle: @"+ 10" forState:UIControlStateNormal];

            [plus10 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [plus10 addTarget:self action:@selector(addTen:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            done.frame = CGRectMake(241, 10.0, 65.0, 30.0);
            [done setTitle: @"Done" forState:UIControlStateNormal];
            [done setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
            [done addTarget:self action:@selector(doneWithKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            
            [inputAccessoryView.inputAccessoryView addSubview:clear];
            [inputAccessoryView addSubview:plus5];
            [inputAccessoryView addSubview:plus10];
            [inputAccessoryView addSubview:done];
        }
    }
    return inputAccessoryView;
}

- (void)clearTextField:(UIButton*)btnClear {
    if (cellSelected) {
        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
        UITextField *txtField = (UITextField*)cellSelected.accessoryView;
        NSString* letter = [letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
        OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
        tmpOrderDetail.QtyOrdered = 0;
        txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
        
        //        NSArray *subArray = [cellSelected subviews];
        //        for (int i = 0; i < subArray.count; i++) {
        //            if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
        //                UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
        //                NSString* letter = [letters objectAtIndex:indexPath.section];
        //                NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
        //                OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
        //                tmpOrderDetail.QtyOrdered = 0;
        //                txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
        //                [self count];
        //            }
        //        }
    }
}

- (void)addFive:(UIButton*)btnAddFive {
    if (cellSelected) {
        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
        UITextField *txtField = (UITextField*)cellSelected.accessoryView;
        NSString* letter = [letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
        OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
        tmpOrderDetail.QtyOrdered += 5;
        txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    }
}

- (void)addTen:(UIButton*)btnAddTen {
    if (cellSelected) {
        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
        UITextField *txtField = (UITextField*)cellSelected.accessoryView;
        NSString* letter = [letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
        OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
        tmpOrderDetail.QtyOrdered += 10;
        txtField.text = [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered];
    }
}

- (void)doneWithKeyboard:(UIButton*)btnDone {
    [self.view endEditing:YES];
    orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cellSelected = nil;
}

#pragma mark - Save Method

- (IBAction)btnBadItems:(id)sender {
    BadItemVC *badItemView = [self.storyboard instantiateViewControllerWithIdentifier:@"BadItemScreen"];
    badItemView.orderLine = orderlineinfo;
    badItemView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:badItemView animated:YES completion:nil];
}

- (IBAction)btnSaveAndSend:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit or Exit"
                                                    message:@"Do you want to edit order now or exit and come back to it later?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save and Review", @"Save and Exit", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    alertViewAction = SAVE;
    [alert show];
}

#pragma mark - other methods

- (IBAction)btnBack:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit? Are you sure?"
                                                    message:@"If you exit now you will lose all the information you have entered."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Exit", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    alertViewAction = EXIT;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertViewAction isEqual:EXIT]) {
        if (buttonIndex == 1) {
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        }
    } else if ([alertViewAction  isEqual:SAVE]) {
        if (buttonIndex == 1) {
            // order header
            NSMutableArray *tmpArray = [User getAllUsers];
            User *user = [tmpArray objectAtIndex:0];
            
            OrderHeader *tmpOrderHdr = [[OrderHeader alloc] init];
            tmpOrderHdr.UserID = user.UserID;
            tmpOrderHdr.CustNum = itemInfo.CustNum;
            tmpOrderHdr.LocalStatus = @"Started";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *date = [NSDate date];
            
            tmpOrderHdr.DateCreated = [dateFormatter stringFromDate:date];
            tmpOrderHdr.DateEdited = [dateFormatter stringFromDate:date];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            tmpOrderHdr.DateToShip = [dateFormatter stringFromDate:date];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [OrderHeader insertInto:tmpOrderHdr];
            
            OrderHeader *createdOrderHdr = [OrderHeader getLastOrderHeaderEntered];
            
            // order line
            OrderLine *tmpOrderLine = [[OrderLine alloc] init];
            tmpOrderLine.OrderNum = createdOrderHdr.OrderNum;
            tmpOrderLine.ItemNo = itemInfo.ItemNo;
            tmpOrderLine.Nameset = itemInfo.Nameset;
            NSInteger tmpNum = 0;
            numItemsOrdered = 0;
            for (OrderDetail* orderDetail in allTableData)
                tmpNum += orderDetail.QtyOrdered;
            tmpOrderLine.Quantity = tmpNum;
            tmpOrderLine.BadItems = orderlineinfo.BadItems;
            tmpOrderLine.ProgName = itemInfo.ProgName;
            
            [OrderLine insertInto:tmpOrderLine];
            
            [OrderDetail beginOrderDetailInsert];
            for (OrderDetail* orderDetail in allTableData) {
                if (orderDetail.QtyOrdered >= 50) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning... Large number of one name ordered"
                                                                    message:@"You have ordered over 50 pieces of one name, if this is a mistake, make sure you fix it!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                } else if ([tmpOrderLine.ItemNo isEqual:@"DR1002"] && ((orderDetail.QtyOrdered % 3) != 0) ) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: Dream Rings not in multiple of 3"
                                                                    message:@"Dream Rings are supposed to be picked in groups of 3. Please make sure this is the case for your order"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                }
                orderDetail.OrderNum = createdOrderHdr.OrderNum;
                [OrderDetail insertInto:orderDetail];
            }
            [OrderDetail endOrderDetailInsert];
            
            OrderHeader *orderHeaderFinal = [OrderHeader getOrderHeaderWhereOrderNum:createdOrderHdr.OrderNum];
            EditingScreenVC *editScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"editScreen"];
            editScreen.orderHeaderInfo = orderHeaderFinal;
            [self.navigationController pushViewController:editScreen animated:YES];
            
        } else if (buttonIndex == 2) {
            
            // order header
            NSMutableArray *tmpArray = [User getAllUsers];
            User *user = [tmpArray objectAtIndex:0];
            
            OrderHeader *tmpOrderHdr = [[OrderHeader alloc] init];
            tmpOrderHdr.UserID = user.UserID;
            tmpOrderHdr.CustNum = itemInfo.CustNum;
            tmpOrderHdr.LocalStatus = @"Started";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *date = [NSDate date];
            
            tmpOrderHdr.DateCreated = [dateFormatter stringFromDate:date];
            tmpOrderHdr.DateEdited = [dateFormatter stringFromDate:date];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            tmpOrderHdr.DateToShip = [dateFormatter stringFromDate:date];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [OrderHeader insertInto:tmpOrderHdr];
            
            OrderHeader *createdOrderHdr = [OrderHeader getLastOrderHeaderEntered];
            
            // order line
            OrderLine *tmpOrderLine = [[OrderLine alloc] init];
            tmpOrderLine.OrderNum = createdOrderHdr.OrderNum;
            tmpOrderLine.ItemNo = itemInfo.ItemNo;
            tmpOrderLine.Nameset = itemInfo.Nameset;
            NSInteger tmpNum = 0;
            numItemsOrdered = 0;
            for (OrderDetail* orderDetail in allTableData)
                tmpNum += orderDetail.QtyOrdered;
            tmpOrderLine.Quantity = tmpNum;
            tmpOrderLine.BadItems = orderlineinfo.BadItems;
            tmpOrderLine.ProgName = itemInfo.ProgName;
            
            [OrderLine insertInto:tmpOrderLine];
            
            [OrderDetail beginOrderDetailInsert];
            for (OrderDetail* orderDetail in allTableData) {
                if (orderDetail.QtyOrdered >= 50) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning... Large number of one name ordered"
                                                                    message:@"You have ordered over 50 pieces of one name, if this is a mistake, make sure you fix it!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
#warning consider
                } else if ([tmpOrderLine.ItemNo isEqual:@"DR1002"] && ((orderDetail.QtyOrdered % 3) != 0) ) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: Dream Rings not in multiple of 3"
                                                                    message:@"Dream Rings are supposed to be picked in groups of 3. Please make sure this is the case for your order"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                }
                orderDetail.OrderNum = createdOrderHdr.OrderNum;
                [OrderDetail insertInto:orderDetail];
            }
            [OrderDetail endOrderDetailInsert];
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        }
    }
    
}

//- (void)viewDidUnload {
//    [self setSearchBar:nil];
//    [super viewDidUnload];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




////
////  OrderScreenVC.m
////  HeartwoodApp
////
////  Created by Daniel Slabaugh on 7/17/13.
////  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
////
//
//#import "OrderScreenVC.h"
//#import "HeartwoodAppUserViewController.h"
//#import <QuartzCore/QuartzCore.h>
//#import "EditingScreenVC.h"
//#import "SVProgressHUD.h"
//
//#import "User.h"
//#import "Name.h"
//#import "OrderHeader.h"
//#import "OrderLine.h"
//#import "OrderDetail.h"
//
//@interface OrderScreenVC ()
//
//@end
//
//@implementation OrderScreenVC
//@synthesize inputAccessoryView;
//@synthesize cellSelected;
//@synthesize itemInfo;
//@synthesize btnTxtToFill;
//@synthesize allTableData;
//@synthesize filteredTableData;
//@synthesize letters;
//@synthesize searchBar;
//@synthesize isFiltered;
//@synthesize btnBadItemCount;
//@synthesize badItemsNum;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // set up fields
//    btnTxtToFill.titleLabel.text = [NSString stringWithFormat:@"You are picking: %@", itemInfo.ItemNo];
//    cellSelected = nil;
//    // needs to be different in other views.
//    badItemsNum = 0;
//    numbersArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 100; i++) {
//        [numbersArray addObject:[NSString stringWithFormat:@"%d", i]];
//    }
//
//    NSMutableArray * unsortedNames = [Name getNamesWhere:itemInfo.Nameset];
//    NSArray * sortedNames = [[NSArray alloc] initWithArray:[unsortedNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//        NSString *first = [(Name*)a TheName];
//        NSString *second = [(Name*)b TheName];
//        return [first compare:second];
//    }]];
//
//    NSMutableArray * orderDetails = [[NSMutableArray alloc]  init];
//
//    for (int i = 0; i < sortedNames.count; i++) {
//        Name *tmpName = [sortedNames objectAtIndex:i];
//        OrderDetail *tmpOrderDetail = [[OrderDetail alloc] init];
//        tmpOrderDetail.ItemNo = itemInfo.ItemNo;
//        tmpOrderDetail.Nameset = tmpName.Nameset;
//        tmpOrderDetail.Name = tmpName.TheName;
//        tmpOrderDetail.NameType = tmpName.NameType;
//        tmpOrderDetail.QtyOrdered = 0;
//        [orderDetails addObject:tmpOrderDetail];
//    }
//    self.allTableData = [orderDetails copy];
//
//    [self updateTableData:@""];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return letters;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // Each letter is a section title
//    NSString* key = [letters objectAtIndex:section];
//    return key;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
//    return index;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of letters in our letter array. Each letter represents a section.
//    return letters.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Returns the number of items in the array associated with the letter for this section.
//    NSString* letter = [letters objectAtIndex:section];
//    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//    return arrayForLetter.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * cellID = @"NameCellID";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//
//    // Grab the object for the specified row and section
//
//    NSString* letter = [letters objectAtIndex:indexPath.section];
//    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//
//    cell.textLabel.text = tmpOrderDetail.Name;
//
//    // Text field
//    UITextField *txtField = [[UITextField alloc] init];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        txtField.frame = CGRectMake(0, 10, 100, 40);
//        [txtField setFont:[UIFont boldSystemFontOfSize:40]];
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        txtField.frame = CGRectMake(0, 10, 40, 30);
//        [txtField setFont:[UIFont boldSystemFontOfSize:22]];
//    }
//
//    txtField.keyboardType = UIKeyboardTypeNumberPad;
//    cell.accessoryView = txtField;
//    txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//    [txtField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [txtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
//
//    // Clear Button
//    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        btnClear.frame = CGRectMake(450.0, 10.0, 100.0, 40.0);
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        btnClear.frame = CGRectMake(175.0, 7.0, 50.0, 30.0);
//    }
//    [btnClear setTitle: @"Clear" forState:UIControlStateNormal];
//    [btnClear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnClear addTarget:self action:@selector(clearCellTextField:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:btnClear];
//
//
//    return cell;
//}
//
//-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
//    [self updateTableData:text];
//}
//
//-(void)updateTableData:(NSString*)searchString {
//    filteredTableData = [[NSMutableDictionary alloc] init];
//
//    for (OrderDetail* orderDetail in allTableData)
//    {
//        bool isMatch = false;
//        if(searchString.length == 0)
//        {
//            // If our search string is empty, everything is a match
//            isMatch = true;
//        }
//        else
//        {
//            // If we have a search string, check to see if it matches the food's name or description
//            NSRange nameRange = [orderDetail.Name rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            //            NSRange descriptionRange = [orderDetail.description rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            if(nameRange.location != NSNotFound) //|| descriptionRange.location != NSNotFound)
//                isMatch = true;
//        }
//
//        // If we have a match...
//        if(isMatch)
//        {
//            if ([orderDetail.NameType isEqual:@"SAYING"]) {
//                // Find the first letter of the food's name. This will be its group
//                NSString* firstLetter = nil;
//                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//                {
//                    // The device is an iPad running iPhone 3.2 or later.
//                    firstLetter = @" Sayings";
//                }
//                else
//                {
//                    // The device is an iPhone or iPod touch.
//                    firstLetter = @" Say";
//                }
//
//                // Check to see if we already have an array for this group
//                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
//                if(arrayForLetter == nil)
//                {
//                    // If we don't, create one, and add it to our dictionary
//                    arrayForLetter = [[NSMutableArray alloc] init];
//                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
//                }
//
//                // Finally, add the food to this group's array
//                [arrayForLetter addObject:orderDetail];
//            } else {
//
//                // Find the first letter of the food's name. This will be its group
//                NSString* firstLetter = [orderDetail.Name substringToIndex:1];
//
//                // Check to see if we already have an array for this group
//                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
//                if(arrayForLetter == nil)
//                {
//                    // If we don't, create one, and add it to our dictionary
//                    arrayForLetter = [[NSMutableArray alloc] init];
//                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
//                }
//
//                // Finally, add the food to this group's array
//                [arrayForLetter addObject:orderDetail];
//            }
//        }
//    }
//
//    // Make a copy of our dictionary's keys, and sort them
//    letters = [[NSArray alloc] initWithArray:[[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
//    // Finally, refresh the table
//    [orderTableView reloadData];
//}
//
//- (void)count {
//    numItemsOrdered = 0;
//    for (OrderDetail* orderDetail in allTableData)
//        numItemsOrdered += orderDetail.QtyOrdered;
//    btnTxtToFill.titleLabel.text = [NSString stringWithFormat:@"You have picked %d %@s", numItemsOrdered, itemInfo.ItemNo];
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSArray *subArray = [cell subviews];
//    for (int i = 0; i < subArray.count; i++) {
//        if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
//            UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
//            NSString* letter = [letters objectAtIndex:indexPath.section];
//            NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//            OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//            tmpOrderDetail.QtyOrdered++;
//            txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//        }
//    }
//    [self count];
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
//    [self.view endEditing:YES];
//    [self hidePicker];
//    orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)txtField{
//    cellSelected = (UITableViewCell*)[txtField superview];
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 295, 0);
//        [orderTableView scrollToRowAtIndexPath:[orderTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    else
//    {
//        orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0);
//        [orderTableView scrollToRowAtIndexPath:[orderTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//}
//
//- (void)textFieldDidChange:(UITextField*)txtField {
//    cellSelected = (UITableViewCell*)[txtField superview];
//
//    NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
//
//    NSString* letter = [letters objectAtIndex:indexPath.section];
//    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//    tmpOrderDetail.QtyOrdered = [txtField.text intValue];
//    txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)txtField{
//    cellSelected = (UITableViewCell*)[txtField superview];
//
//    NSIndexPath *indexPath = [(UITableView *)cellSelected.superview indexPathForCell:cellSelected];
//
//    NSString* letter = [letters objectAtIndex:indexPath.section];
//    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//    OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//    tmpOrderDetail.QtyOrdered = [txtField.text intValue];
//    txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//
//    cellSelected = nil;
//    [self count];
//}
//
//-(void)clearCellTextField:(UIButton*)btnClear {
//    UITableViewCell *cell = (UITableViewCell*)[btnClear superview];
//    NSIndexPath *indexPath = [orderTableView indexPathForCell:cell];
//
//    NSArray *subArray = [cell subviews];
//    for (int i = 0; i < subArray.count; i++) {
//        if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
//            UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
//            NSString* letter = [letters objectAtIndex:indexPath.section];
//            NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//            OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//            tmpOrderDetail.QtyOrdered = 0;
//            txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//            [self count];
//        }
//    }
//}
//
//#pragma mark - inputAccessoryView
//
//- (UIView*)inputAccessoryView {
//    if (!inputAccessoryView) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            // The device is an iPad running iPhone 3.2 or later.
//            CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
//            inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
//            inputAccessoryView.backgroundColor = [[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0];
//
//            UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            clear.frame = CGRectMake(20.0, 20.0, 150.0, 37.0);
//            [clear setTitle: @"Clear" forState:UIControlStateNormal];
//            [clear setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [clear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *plus5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            plus5.frame = CGRectMake(210.0, 20.0, 150.0, 37.0);
//            [plus5 setTitle: @"+ 5" forState:UIControlStateNormal];
//            [plus5 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [plus5 addTarget:self action:@selector(addFive:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *plus10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            plus10.frame = CGRectMake(400.0, 20.0, 150.0, 37.0);
//            [plus10 setTitle: @"+ 10" forState:UIControlStateNormal];
//            [plus10 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [plus10 addTarget:self action:@selector(addTen:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            done.frame = CGRectMake(590.0, 20.0, 150.0, 37.0);
//            [done setTitle: @"Done" forState:UIControlStateNormal];
//            [done setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [done addTarget:self action:@selector(doneWithKeyboard:) forControlEvents:UIControlEventTouchUpInside];
//
//            [inputAccessoryView addSubview:clear];
//            [inputAccessoryView addSubview:plus5];
//            [inputAccessoryView addSubview:plus10];
//            [inputAccessoryView addSubview:done];
//        }
//        else
//        {
//            // The device is an iPhone or iPod touch.
//            CGRect accessFrame = CGRectMake(0.0, 0.0, 325.0, 50.0);
//            inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
//            inputAccessoryView.backgroundColor = [[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0];
//
//            UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            clear.frame = CGRectMake(10.0, 10.0, 65.0, 30.0);
//            [clear setTitle: @"Clear" forState:UIControlStateNormal];
//            [clear setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [clear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *plus5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            plus5.frame = CGRectMake(87.0, 10.0, 65, 30.0);
//            [plus5 setTitle: @"+ 5" forState:UIControlStateNormal];
//            [plus5 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [plus5 addTarget:self action:@selector(addFive:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *plus10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            plus10.frame = CGRectMake(164.0, 10.0, 65, 30.0);
//            [plus10 setTitle: @"+ 10" forState:UIControlStateNormal];
//            [plus10 setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [plus10 addTarget:self action:@selector(addTen:) forControlEvents:UIControlEventTouchUpInside];
//
//            UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            done.frame = CGRectMake(241, 10.0, 65.0, 30.0);
//            [done setTitle: @"Done" forState:UIControlStateNormal];
//            [done setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//            [done addTarget:self action:@selector(doneWithKeyboard:) forControlEvents:UIControlEventTouchUpInside];
//
//            [inputAccessoryView addSubview:clear];
//            [inputAccessoryView addSubview:plus5];
//            [inputAccessoryView addSubview:plus10];
//            [inputAccessoryView addSubview:done];
//        }
//    }
//    return inputAccessoryView;
//}
//
//- (void)clearTextField:(UIButton*)btnClear {
//    if (cellSelected) {
//        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
//        NSArray *subArray = [cellSelected subviews];
//        for (int i = 0; i < subArray.count; i++) {
//            if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
//                UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
//                NSString* letter = [letters objectAtIndex:indexPath.section];
//                NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//                OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//                tmpOrderDetail.QtyOrdered = 0;
//                txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//                [self count];
//            }
//        }
//    }
//}
//
//- (void)addFive:(UIButton*)btnAddFive {
//    if (cellSelected) {
//        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
//        NSArray *subArray = [cellSelected subviews];
//        for (int i = 0; i < subArray.count; i++) {
//            if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
//                UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
//                NSString* letter = [letters objectAtIndex:indexPath.section];
//                NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//                OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//                tmpOrderDetail.QtyOrdered += 5;
//                txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//                [self count];
//            }
//        }
//    }
//}
//
//- (void)addTen:(UIButton*)btnAddTen {
//    if (cellSelected) {
//        NSIndexPath *indexPath = [orderTableView indexPathForCell:cellSelected];
//        NSArray *subArray = [cellSelected subviews];
//        for (int i = 0; i < subArray.count; i++) {
//            if ([[subArray objectAtIndex:i] isKindOfClass:[UITextField class]]) {
//                UITextField *txtField = (UITextField*)[subArray objectAtIndex:i];
//                NSString* letter = [letters objectAtIndex:indexPath.section];
//                NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
//                OrderDetail* tmpOrderDetail = (OrderDetail*)[arrayForLetter objectAtIndex:indexPath.row];
//                tmpOrderDetail.QtyOrdered += 10;
//                txtField.text = [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered];
//                [self count];
//            }
//        }
//    }
//}
//
//- (void)doneWithKeyboard:(UIButton*)btnDone {
//    [self.view endEditing:YES];
//    orderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
//    cellSelected = nil;
//    [self hidePicker];
//}
//
//#pragma mark - Save Method
//
//- (IBAction)btnSave:(id)sender {
//    [SVProgressHUD showWithStatus:@"Saving..."];
//
//    // order header
//    NSMutableArray *tmpArray = [User getAllUsers];
//    User *user = [tmpArray objectAtIndex:0];
//
//    OrderHeader *tmpOrderHdr = [[OrderHeader alloc] init];
//    tmpOrderHdr.UserID = user.UserID;
//    tmpOrderHdr.CustNum = itemInfo.CustNum;
//    tmpOrderHdr.StoreID = itemInfo.StoreID;
//    tmpOrderHdr.LocalStatus = @"Started";
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    NSDate *date = [NSDate date];
//
//    tmpOrderHdr.DateCreated = [dateFormatter stringFromDate:date];
//    tmpOrderHdr.DateEdited = [dateFormatter stringFromDate:date];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    tmpOrderHdr.DateToShip = [dateFormatter stringFromDate:date];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [OrderHeader insertInto:tmpOrderHdr];
//
//    OrderHeader *createdOrderHdr = [OrderHeader getLastOrderHeaderEntered];
//
//    // order line
//    OrderLine *tmpOrderLine = [[OrderLine alloc] init];
//    tmpOrderLine.OrderNum = createdOrderHdr.OrderNum;
//    tmpOrderLine.ItemNo = itemInfo.ItemNo;
//    tmpOrderLine.Nameset = itemInfo.Nameset;
//    NSInteger tmpNum = 0;
//    numItemsOrdered = 0;
//    for (OrderDetail* orderDetail in allTableData)
//        tmpNum += orderDetail.QtyOrdered;
//    tmpOrderLine.Quantity = tmpNum;
//    tmpOrderLine.BadItems = badItemsNum;
//
//    [OrderLine insertInto:tmpOrderLine];
//
//    [OrderDetail beginOrderDetailInsert];
//    for (OrderDetail* orderDetail in allTableData) {
//        orderDetail.OrderNum = createdOrderHdr.OrderNum;
//        [OrderDetail insertInto:orderDetail];
//    }
//    [OrderDetail endOrderDetailInsert];
//    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
//    [SVProgressHUD dismiss];
//}
//
//- (IBAction)btnSaveAndSend:(id)sender {
//    [SVProgressHUD showWithStatus:@"Saving.."];
//
//    // order header
//    NSMutableArray *tmpArray = [User getAllUsers];
//    User *user = [tmpArray objectAtIndex:0];
//
//    OrderHeader *tmpOrderHdr = [[OrderHeader alloc] init];
//    tmpOrderHdr.UserID = user.UserID;
//    tmpOrderHdr.CustNum = itemInfo.CustNum;
//    tmpOrderHdr.StoreID = itemInfo.StoreID;
//    tmpOrderHdr.LocalStatus = @"Started";
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    NSDate *date = [NSDate date];
//
//    tmpOrderHdr.DateCreated = [dateFormatter stringFromDate:date];
//    tmpOrderHdr.DateEdited = [dateFormatter stringFromDate:date];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    tmpOrderHdr.DateToShip = [dateFormatter stringFromDate:date];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [OrderHeader insertInto:tmpOrderHdr];
//
//    OrderHeader *createdOrderHdr = [OrderHeader getLastOrderHeaderEntered];
//
//    // order line
//    OrderLine *tmpOrderLine = [[OrderLine alloc] init];
//    tmpOrderLine.OrderNum = createdOrderHdr.OrderNum;
//    tmpOrderLine.ItemNo = itemInfo.ItemNo;
//    tmpOrderLine.Nameset = itemInfo.Nameset;
//    NSInteger tmpNum = 0;
//    numItemsOrdered = 0;
//    for (OrderDetail* orderDetail in allTableData)
//        tmpNum += orderDetail.QtyOrdered;
//    tmpOrderLine.Quantity = tmpNum;
//    tmpOrderLine.BadItems = badItemsNum;
//
//    [OrderLine insertInto:tmpOrderLine];
//
//    [OrderDetail beginOrderDetailInsert];
//    for (OrderDetail* orderDetail in allTableData) {
//        orderDetail.OrderNum = createdOrderHdr.OrderNum;
//        [OrderDetail insertInto:orderDetail];
//    }
//    [OrderDetail endOrderDetailInsert];
//
//    OrderHeader *orderHeaderFinal = [OrderHeader getOrderHeaderWhereOrderNum:createdOrderHdr.OrderNum];
//    EditingScreenVC *editScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"editScreen"];
//    editScreen.orderHeaderInfo = orderHeaderFinal;
//    [self.navigationController pushViewController:editScreen animated:YES];
//
//    [SVProgressHUD dismiss];
//}
//
//#pragma mark - other methods
//
//- (IBAction)btnBack:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit? Are you sure?"
//                                                    message:@"If you exit now you will lose all the information you have entered."
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Exit", nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
//
//}
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
//    }
//}
//
//- (void)viewDidUnload {
//    [self setSearchBar:nil];
//    [super viewDidUnload];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void) dealloc {
//    [btnTxtToFill release];
//    [itemInfo release];
//    [inputAccessoryView release];
//    [allTableData release];
//    [filteredTableData release];
//    [letters release];
//    [searchBar release];
//    [pickerView release];
//    [btnBadItemCount release];
//    [cellSelected release];
//    [super dealloc];
//}
//
//#pragma mark - UIPickerViewDataSource
//
//- (void)slideDownDidStop {
//	// the date picker has finished sliding downwards, so remove it from the view hierarchy
//	[self->pickerView removeFromSuperview];
//}
//
//- (void)hidePicker {
//    CGRect pickerShipFrame = self->pickerView.frame;
//    pickerShipFrame.origin.y = self.view.frame.size.height;
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:.40];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
//    self->pickerView.frame = pickerShipFrame;
//    [UIView commitAnimations];
//}
//
//- (void)hideShipPicker:(UIButton*)btnClear {
//    [self hidePicker];
//}
//
//- (IBAction)btnBadItemCount:(id)sender {
//    for (UIView* view in self.view.subviews) {
//		if ([view isKindOfClass:[UITextField class]])
//			[view resignFirstResponder];
//	}
//    // the date picker might already be showing, so don't add it to our view
//    if (self->pickerView.superview == nil)
//    {
//        CGRect startFrame = self->pickerView.frame;
//        CGRect endFrame = self->pickerView.frame;
//
//        // the start position is below the bottom of the visible frame
//        startFrame.origin.y = self.view.frame.size.height;
//
//        // the end position is slid up by the height of the view
//        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
//
//        self->pickerView.frame = startFrame;
//
//        [self.view addSubview:self->pickerView];
//
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:.40];
//        self->pickerView.frame = endFrame;
//        [UIView commitAnimations];
//    }
//
//    // Done Button
//    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        btnClear.frame = CGRectMake(550.0, 55.0, 120.0, 100.0);
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        btnClear.frame = CGRectMake(270.0, 55.0, 50.0, 100.0);
//    }
//    [btnClear setTitle: @"Done" forState:UIControlStateNormal];
//    [btnClear setTitleColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0] forState:UIControlStateNormal];
//    [btnClear addTarget:self action:@selector(hideShipPicker:) forControlEvents:UIControlEventTouchUpInside];
//    [pickerView addSubview:btnClear];
//
//    for (int row = 0; row < numbersArray.count; row++) {
//        if (badItemsNum == [[numbersArray objectAtIndex:row] intValue]) {
//            [pickerView selectRow:row inComponent:0 animated:YES];
//        }
//    }
//
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerViewShip titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	NSString *returnStr = @"";
//    if (pickerViewShip == self->pickerView)
//	{
//        returnStr = [numbersArray objectAtIndex:row];
//	}
//
//	return returnStr;
//}
//
//- (void)pickerView:(UIPickerView *)pickerViewShip didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//	if (pickerViewShip == pickerView)	// don't show selection for the custom picker
//	{
//		// report the selection to the UI label
//        btnBadItemCount.title = [NSString stringWithFormat:@"%@ Defective Items",
//                                 [numbersArray objectAtIndex:[pickerViewShip selectedRowInComponent:0]]];
//        badItemsNum = [[numbersArray objectAtIndex:[pickerViewShip selectedRowInComponent:0]] intValue];
//	}
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerViewShip widthForComponent:(NSInteger)component {
//	return 220.0;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerViewShip rowHeightForComponent:(NSInteger)component {
//	return 40.0;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerViewShip numberOfRowsInComponent:(NSInteger)component {
//    return numbersArray.count;
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//	return 1;
//}
//
//@end


