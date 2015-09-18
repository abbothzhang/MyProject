//
//  DLIDEKeyboardView.m
//  DLIDEKeyboard
//
//  Created by Denis Lebedev on 1/14/13.
//  Copyright (c) 2013 Denis Lebedev. All rights reserved.
//

#import "DLIDEKeyboardView.h"

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface DLIDEKeyboardView () <UIInputViewAudioFeedback> {

}

@property (nonatomic, strong) id<UITextInput> textView;
@end

@implementation DLIDEKeyboardView

#pragma mark - Public

+ (void)attachToTextView:(UIResponder<UITextInput> *)textView {
    DLIDEKeyboardView *view = [[DLIDEKeyboardView alloc] init];
    if (![textView respondsToSelector:@selector(setInputAccessoryView:)]) {
        [NSException raise:@"Keyboard can be attached only to text inputs" format:nil];
    }
    view.textView = textView;
    [(id)textView setInputAccessoryView:view];
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        CGFloat kKeyboardWidth = IS_IPAD ? 768.f : 320.f;
        CGFloat kKeyboardHeight = IS_IPAD ? 104.f : 40.f;
        self.frame = CGRectMake(0, 0, kKeyboardWidth, kKeyboardHeight);
        
        UIImageView* imageBack=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 40, 40)];
        imageBack.backgroundColor=UIColorFromRGB(0xB5B5BA);
        [self addSubview:imageBack];
        [[imageBack layer] setMasksToBounds:YES];
        [[imageBack layer] setCornerRadius:3];
        UIImageView* imageBack1=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 37, 40, 3)];
        imageBack1.backgroundColor=UIColorFromRGB(0xB5B5BA);
        [self addSubview:imageBack1];
        
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        Button.showsTouchWhenHighlighted = YES;
        Button.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 40);
        [Button setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        [Button setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateSelected];
        [Button addTarget:self action:@selector(HidKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Button];
    }
    return self;
}

#pragma mark - Private

-(void)HidKeyBoard:(UIButton *)button
{
    [(id)self.textView resignFirstResponder];
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}


@end
