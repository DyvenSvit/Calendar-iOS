//
//  DSMonthPicker.m
//  CalendarUGCC
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 DyvenSvit. All rights reserved.
//

#import "ActionSheetYearMonthPicker.h"

@interface ActionSheetYearMonthPicker()
{
    NSArray *yearsToDisplay;
    NSArray *monthsToDisplay;
}
@property (nonatomic,strong) NSArray *data;
@end

@implementation ActionSheetYearMonthPicker

+ (id)showPickerWithSelectedYear:(NSInteger)yearIndex month:(NSInteger)monthIndex doneBlock:(ActionYearMonthDoneBlock)doneBlock cancelBlock:(ActionYearMonthCancelBlock)cancelBlock origin:(id)origin
{
    
    ActionSheetYearMonthPicker *picker = [[ActionSheetYearMonthPicker alloc] initWithSelectedYear:yearIndex month:monthIndex doneBlock:doneBlock
                                                                       cancelBlock:cancelBlock origin:origin];
    
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"Вибрати"  style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"Відмінити"  style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithSelectedYear:(NSInteger)yearIndex month:(NSInteger)monthIndex doneBlock:(ActionYearMonthDoneBlock)doneBlock cancelBlock:(ActionYearMonthCancelBlock)cancelBlockOrNil origin:(id)origin {
    NSArray *initialSelection = [NSArray arrayWithObjects:[NSNumber numberWithInteger:yearIndex], [NSNumber numberWithInteger: monthIndex ], nil];
    self = [super initWithTitle:@"Рік та місяць" delegate:self showCancelButton:YES origin:origin initialSelections:initialSelection];
    if (self) {
        NSMutableArray *years = [NSMutableArray new];
        for(DSYear* y in [[DSData shared] years])
        {
            [years addObject:[NSString stringWithFormat:@"%ld", (long)[y.date getYearNumber]]];
        }
        yearsToDisplay = [NSArray arrayWithArray:years];
        monthsToDisplay = [[DSData shared] monthNames];
        self.onActionDone = doneBlock;
        self.onActionCancel = cancelBlockOrNil;
    }
    return self;
}

-(void) showActionSheetPicker
{
    [super showActionSheetPicker];
    [super.pickerView setBackgroundColor:[UIColor whiteColor]];
}

-(NSAttributedString*) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = (self.data)[(NSUInteger) row];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    mutParaStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSParagraphStyleAttributeName: mutParaStyle }];
    
    return attString;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    if(self.onActionDone)
    {
        self.onActionDone(self, self.selectedYear, self.selectedMonth);
    }
}

- (void)actionSheetPickerDidCancel:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    if(self.onActionCancel)
    {
        self.onActionCancel(self);
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [yearsToDisplay count];
        case 1: return [monthsToDisplay count];
        default:break;
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 60.0f;
        case 1: return 260.0f;
        default:break;
    }
    
    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: return yearsToDisplay[(NSUInteger) row];
        case 1: return monthsToDisplay[(NSUInteger) row];
        default:break;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %li selected in component %li", (long)row, (long)component);
    switch (component) {
        case 0:
            self.selectedYear = (NSUInteger) row;
            return;
            
        case 1:
            self.selectedMonth = (NSUInteger) row;
            return;
        default:break;
    }
}
@end
