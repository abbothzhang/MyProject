//
//  UXTextField.m
//  hospitalDemo
//
//  Created by 夏科杰 on 13-11-22.
//  Copyright (c) 2013年 夏科杰. All rights reserved.
//

#import "UXTextField.h"
#define kTextFieldPaddingWidth  (10.0f)
#define kTextFieldPaddingHeight (2.0f)
@implementation UXTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [[self layer] setMasksToBounds:YES];
        [[self layer] setCornerRadius:2];
        

        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx,  self.dy == 0.0f ? kTextFieldPaddingHeight : self.dy, bounds.size.width-(self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx), bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx,  self.dy == 0.0f ? kTextFieldPaddingHeight : self.dy, bounds.size.width-(self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx), bounds.size.height);
}

- (void)setDx:(CGFloat)dx
{
    _dx = dx;
    [self setNeedsDisplay];
}

- (void)setDy:(CGFloat)dy
{
    _dy = dy;
    [self setNeedsDisplay];
}  /*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
