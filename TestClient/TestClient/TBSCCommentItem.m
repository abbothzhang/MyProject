//
//	TBSCCommentItem.m
//	
//	Created by jsonschema2objc.
//	Copyright 2013 Taobao. All rights reserved.
//

#import "TBSCCommentItem.h"
#import "NSObject+SBJson.h"
#import "NSString+TBModel.h"
#import "TBSCColorStyleLibrary.h"




@implementation TBSCCommentItem

#pragma mark -
#pragma mark Parsing / exporting


- (void) setFromDictionary:(NSDictionary *)dict
{
	_content = SAFE_STRING([dict objectForKey:@"content"]);
	_createrId = [[dict objectForKey:@"commenterId"] unsignedLongLongValue];
	_createrNick = SAFE_STRING([dict objectForKey:@"commenterNick"]);
	_createrPic = SAFE_STRING([dict objectForKey:@"commenterHeadPic"]);
    _commentId = [dict[@"commentId"] unsignedLongLongValue];
	_id = [[dict objectForKey:@"id"] unsignedLongLongValue];
	_time = [[dict objectForKey:@"timestamp"] unsignedLongLongValue];
    
    self.timestamp = [dict[@"timestamp"] unsignedLongLongValue];//???
    
    _parentContent = SAFE_STRING([dict objectForKey:@"paContent"]);
    _parentNick = SAFE_STRING([dict objectForKey:@"paCommenterNick"]);
    
    _paCommenterId = [[dict objectForKey:@"paCommenterId"] unsignedLongLongValue];
    _parentId = [[dict objectForKey:@"paId"] unsignedLongLongValue];
    _targetOwnerUserId = [[dict objectForKey:@"accountId"] unsignedLongLongValue];
    _targetId = [[dict objectForKey:@"targetId"] unsignedLongLongValue];

    self.type = [[dict objectForKey:@"type"] unsignedIntegerValue];
    self.parentType = [[dict objectForKey:@"paType"] unsignedIntegerValue];
    
    if (_type == TBSCCommentContentCommodityDetail) {
        NSString *jsonTitlesListString = [dict objectForKey:@"extSymbol"];
        if (jsonTitlesListString && jsonTitlesListString.length > 0) {
            id jsonTitlesList = [jsonTitlesListString JSONValue];
            if(jsonTitlesList) {
                _extSymbolArray = [TBSCCommentCommodityItem modelArrayWithJSON:jsonTitlesList];
            }
        }
    }else if(_type == TBSCCommentContentPicture){
        NSString *jsonTitlesListString = [dict objectForKey:@"extSymbol"];
        if (jsonTitlesListString && jsonTitlesListString.length > 0) {
            id jsonTitlesList = [jsonTitlesListString JSONValue];
            if(jsonTitlesList) {
                _extSymbol = jsonTitlesList;
            }
        }
    }
    
    if (_parentType == TBSCCommentContentCommodityDetail) {
        NSString *jsonTitlesListString = [dict objectForKey:@"paExtSymbol"];
        if (jsonTitlesListString && jsonTitlesListString.length > 0) {
            id jsonTitlesList = [jsonTitlesListString JSONValue];
            if(jsonTitlesList) {
                _parentExtSymbolArray = [TBSCCommentCommodityItem modelArrayWithJSON:jsonTitlesList];
            }
        }
    }else if(_parentType == TBSCCommentContentPicture){
        NSString *jsonTitlesListString = [dict objectForKey:@"paExtSymbol"];
        if (jsonTitlesListString && jsonTitlesListString.length > 0) {
            id jsonTitlesList = [jsonTitlesListString JSONValue];
            if(jsonTitlesList) {
                _parentExtSymbol = jsonTitlesList;
            }
        }

    }
    
    _detailUrl = SAFE_STRING([dict objectForKey:@"feedDetailUrl"]);

    [self getCellHeight];
}

- (NSDictionary *) toDictionary{
	NSMutableDictionary *bufferDict = [[NSMutableDictionary alloc] init];

	if (self.content) {
		[bufferDict setObject:self.content forKey:@"content"];
	}

    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_createrId] forKey:@"commenterId"];
    
	if (self.createrNick) {
		[bufferDict setObject:self.createrNick forKey:@"commenterNick"];
	}
	if (self.createrPic) {
		[bufferDict setObject:self.createrPic forKey:@"commenterHeadPic"];
	}
    [bufferDict setObject:@(_commentId) forKey:@"commentId"];
	[bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_id] forKey:@"id"];
	[bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_time] forKey:@"timestamp"];
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:self.timestamp] forKey:@"timestamp"];
    
	if (self.parentContent) {
		[bufferDict setObject:self.parentContent forKey:@"paContent"];
	}

    if (self.parentNick) {
		[bufferDict setObject:self.parentNick forKey:@"paCommenterNick"];
	}
    
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_paCommenterId] forKey:@"paCommenterId"];
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_parentId] forKey:@"paId"];
    
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_targetOwnerUserId] forKey:@"accountId"];
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_targetId] forKey:@"feedId"];

    [bufferDict setObject:[NSNumber numberWithUnsignedInteger:_type] forKey:@"type"];
    [bufferDict setObject:[NSNumber numberWithUnsignedInteger:_parentType] forKey:@"paType"];
    
    if(self.type == TBSCCommentContentCommodityDetail){
        if (self.extSymbolArray) {
            NSMutableArray *innerList = [[NSMutableArray alloc] init];
            for (id jsonTitlesElement in self.extSymbolArray) {
                [innerList addObject:[jsonTitlesElement toDictionary]];
            }
            [bufferDict setObject:innerList forKey:@"extSymbolArray"];
        }
    }else if(self.type == TBSCCommentContentPicture){
        if (self.extSymbol) {
            [bufferDict setObject:self.extSymbol forKey:@"extSymbol"];
        }
    }
    
    if(self.parentType == TBSCCommentContentCommodityDetail){
        if (self.parentExtSymbolArray) {
            NSMutableArray *innerList = [[NSMutableArray alloc] init];
            for (id jsonTitlesElement in self.parentExtSymbolArray) {
                [innerList addObject:[jsonTitlesElement toDictionary]];
            }
            [bufferDict setObject:innerList forKey:@"parentExtSymbolArray"];
        }
    }else if(self.parentType == TBSCCommentContentPicture){
        if (self.parentExtSymbol) {
            [bufferDict setObject:self.parentExtSymbol forKey:@"paExtSymbol"];
        }
    }
    
    if (self.detailUrl) {
		[bufferDict setObject:self.detailUrl forKey:@"feedDetailUrl"];
	}
 
	NSDictionary *outputDict = [NSDictionary dictionaryWithDictionary:bufferDict];
	return outputDict;
}

- (NSString *) JSONRepresentation
{
	return [[self toDictionary] JSONRepresentation];
}

-(SLAttributedLabel *)contentSLabel{
    if (_contentSLabel == nil) {
        _contentSLabel = [[SLAttributedLabel alloc] init];
        _contentSLabel.font = DEFAULT_TEXT_FONT;
        _contentSLabel.textColor = RGB(0x22, 0x22, 0x22);
        _contentSLabel.linkColor = RGB(0x22, 0x22, 0x22);
        _contentSLabel.backgroundColor = [UIColor clearColor];
        _contentSLabel.userInteractionEnabled = NO;
        _contentSLabel.opaque = YES;
        _contentSLabel.lineBreakMode = UILineBreakModeWordWrap;
//        [_contentSLable setFrame:CGRectMake(BOARDER_STAND + 1, BOARDER_STAND, 298 - 1, 20)];
    }
    return _contentSLabel;
}

-(SLAttributedLabel *)parentContentSLabel{
    if (_parentContentSLabel == nil) {
        _parentContentSLabel = [[SLAttributedLabel alloc] init];
        _parentContentSLabel.font = PARENT_TEXT_FONT;
        _parentContentSLabel.textColor = [UIColor scColorWithColorType:TBSCColorC3];
        _parentContentSLabel.linkColor = [UIColor scColorWithColorType:TBSCColorC3];
        _parentContentSLabel.backgroundColor = [UIColor clearColor];
        _parentContentSLabel.userInteractionEnabled = NO;
        _parentContentSLabel.opaque = YES;
        _parentContentSLabel.lineBreakMode = UILineBreakModeWordWrap;
//        [_parentContentSLable setFrame:CGRectMake(BOARDER_STAND + 1, BOARDER_STAND, 224 - 1, 20)];
    }
    return _parentContentSLabel;
}

-(BOOL)hasParentComment{
    return self.paCommenterId != 0 && self.parentId != 0;
}

-(void)setType:(NSUInteger)type{
    _type = type;
    _createrContentType = type;
}

-(void)setParentType:(NSUInteger)parentType{
    _parentType = parentType;
    _parentContentType = _parentType;
}

-(NSString*)getCommentContentPicName{
    if (self.extSymbol && [self.extSymbol count] > 0) {
        self.imageName = [self.extSymbol objectAtIndex:0];
    }
    return self.imageName;
}

-(NSString*)getCommentParentContentPicName{
    if (self.parentExtSymbol && [self.parentExtSymbol count] > 0) {
        self.imageParentName = [self.parentExtSymbol objectAtIndex:0];
    }
    return self.imageParentName;
}

-(TBSCCommentCommodityItem*)getCommentContentCommodityItem{
    if (self.extSymbolArray && [self.extSymbolArray count] > 0) {
        self.commentCommodityItem = [self.extSymbolArray objectAtIndex:0];
    }
    return self.commentCommodityItem;
}

-(TBSCCommentCommodityItem*)getCommentParentContentCommodityItem{
    if (self.parentExtSymbolArray && [self.parentExtSymbolArray count] > 0) {
        self.commentCommodityParentItem = [self.parentExtSymbolArray objectAtIndex:0];
    }
    return self.commentCommodityParentItem;
}

-(CGFloat)getCellHeight{
    
    if (self.content && self.content.length > 0) {
        self.contentHeight = [self getContentHeight:self.createrContentType isParentComment:NO];
    }else{
        self.contentHeight = [self getContentHeightNoText:self.createrContentType];
    }
    self.cellHeight = CELL_HEAD_HEIGHT + self.contentHeight + CELL_BOTTOM_HEIGHT;
    return self.cellHeight;
}

-(CGFloat)getContentHeight:(TBSCCommentContentType)contentType isParentComment:(BOOL)isParentComment{
    CGFloat contentHeight = 0;
    CGFloat innerBoarder = 10;

    CGSize contentlabelSize;
    if (isParentComment) {
        self.parentContentSLabel.text = self.parentContent;
        self.parentContentlabelSize = [self bubbleSizeWithText:self.parentContent witFontWidth:CELL_PARENT_CONTENTVIEW_WITH isParentContent:YES];
        contentlabelSize = self.parentContentlabelSize;
    }else{
        self.contentSLabel.text = self.content;
        self.contentlabelSize = [self bubbleSizeWithText:self.content witFontWidth:CELL_PARENT_CONTENTVIEW_WITH];
        contentlabelSize = self.contentlabelSize;
    }

    switch (contentType) {
        case TBSCCommentContentPicture:
            contentHeight = contentlabelSize.height + innerBoarder + 80 + 1;
            break;
        case TBSCCommentContentCommodityDetail:
            contentHeight = contentlabelSize.height + innerBoarder + 80 + 1;
            break;
        case TBSCCommentContentTextWithEmotion:
        default:
            contentHeight = contentlabelSize.height + innerBoarder + 3;
            break;
    }
    return contentHeight;
}

-(CGFloat)getContentHeightNoText:(TBSCCommentContentType)contentType{
    CGFloat height = 0;
    switch (contentType) {
        case TBSCCommentContentPicture:
            height = height + BOARDER_STAND + 80 + BOARDER_STAND + 1;
            break;
        case TBSCCommentContentCommodityDetail:
            height = height + BOARDER_STAND + 80 + BOARDER_STAND + 1;
            break;
        case TBSCCommentContentTextWithEmotion:
        default:
            height = 0;
            break;
    }
    return height;
}

-(CGSize)bubbleSizeWithText:(NSString *)text witFontWidth:(CGFloat)fontFloat{
    self.contentSLabel.text = text;
    __autoreleasing NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentSLabel.attributedText];
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //行间距
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = lableSpace;  //指定间距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);   //第二个参数为settings的长度
    
    [mutaString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                       value:(__bridge id)paragraphStyle
                       range:NSMakeRange(0, mutaString.length)];
    
    self.contentSLabel.attributedText = mutaString;
    CFRelease(paragraphStyle);
    CGSize textSize = CGSizeZero;
    
    @try {
        textSize = [self.contentSLabel sizeThatFits:CGSizeMake(fontFloat, CGFLOAT_MAX)];
    }
    @catch (NSException *exception) {
    }
    
    return textSize;
}

-(CGSize)bubbleSizeWithText:(NSString *)text witFontWidth:(CGFloat)fontFloat isParentContent:(BOOL)isParentContent{
    
    if (isParentContent) {
        if(self.parentContent && self.parentContent.length > 0){
            self.parentContentSLabel.text = self.parentContent;
        }else{
            self.parentContentSLabel.text = @" ";
        }
    }else{
        self.contentSLabel.text = text;
    }
    
    
//    NSUInteger len = 1 + 1;
    __autoreleasing NSMutableAttributedString *mutaString;
    if (isParentContent) {
        mutaString = [[NSMutableAttributedString alloc] initWithAttributedString:self.parentContentSLabel.attributedText];
    }else{
        mutaString = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentSLabel.attributedText];
    }
    
//    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
//                       value:(id)[UIColor scColorWithColorType:TBSCColorC3].CGColor
//                       range:NSMakeRange(0, len)];
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //行间距
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = lableSpace;  //指定间距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);   //第二个参数为settings的长度
    
    [mutaString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                       value:(__bridge id)paragraphStyle
                       range:NSMakeRange(0, mutaString.length)];
    
    if (isParentContent) {
         self.parentContentSLabel.attributedText = mutaString;
    }else{
        self.contentSLabel.attributedText = mutaString;
    }
   
    CFRelease(paragraphStyle);
    

    CGSize textSize = CGSizeZero;
    
    @try {
        if (isParentContent) {
            textSize = [self.parentContentSLabel sizeThatFits:CGSizeMake(fontFloat, CGFLOAT_MAX)];
        }else{
            textSize = [self.contentSLabel sizeThatFits:CGSizeMake(fontFloat, CGFLOAT_MAX)];
        }
    }
    @catch (NSException *exception) {
        
    }

    return textSize;
}

-(void)setCommentCommodityItem:(TBSCCommentCommodityItem*)item{
    if (_commentCommodityItem == nil) {
        _commentCommodityItem = [[TBSCCommentCommodityItem alloc] init];
    }
    self.commentCommodityItem.price = item.price;
    self.commentCommodityItem.itemId = item.itemId;
    self.commentCommodityItem.itemPic = item.itemPic;
    self.commentCommodityItem.totalSoldQuantity = item.totalSoldQuantity;
    self.commentCommodityItem.title = item.title;
}

-(void)setCommentCommodityParentItem:(TBSCCommentCommodityItem*)item{
    if (_commentCommodityParentItem == nil) {
        _commentCommodityParentItem = [[TBSCCommentCommodityItem alloc] init];
    }
    self.commentCommodityParentItem.price = item.price;
    self.commentCommodityParentItem.itemId = item.itemId;
    self.commentCommodityParentItem.itemPic = item.itemPic;
    self.commentCommodityParentItem.totalSoldQuantity = item.totalSoldQuantity;
    self.commentCommodityParentItem.title = item.title;
}

@end

@implementation TBSCCommentImageItem

@synthesize picName = _picName;

#pragma mark -
#pragma mark Parsing / exporting

- (void) setFromDictionary:(NSDictionary *)dict
{
	_picName = SAFE_STRING([dict objectForKey:@"picName"]);
}

- (NSDictionary *) toDictionary{
	NSMutableDictionary *bufferDict = [[NSMutableDictionary alloc] init];
    
	if (self.picName) {
		[bufferDict setObject:self.picName forKey:@"picName"];
	}
    
	NSDictionary *outputDict = [NSDictionary dictionaryWithDictionary:bufferDict];
	return outputDict;
}

- (NSString *) JSONRepresentation
{
	return [[self toDictionary] JSONRepresentation];
}

@end


@implementation TBSCCommentCommodityItem


#pragma mark -
#pragma mark Parsing / exporting

- (void) setFromDictionary:(NSDictionary *)dict
{
	_price = SAFE_STRING([dict objectForKey:@"price"]);
	_itemId = [[dict objectForKey:@"itemId"] unsignedLongLongValue];
	_title = SAFE_STRING([dict objectForKey:@"title"]);
	_itemPic = SAFE_STRING([dict objectForKey:@"itemPic"]);
    
    _totalSoldQuantity = SAFE_STRING([dict objectForKey:@"totalSoldQuantity"]);
    
}

- (NSDictionary *) toDictionary{
	NSMutableDictionary *bufferDict = [[NSMutableDictionary alloc] init];
    
	if (self.price) {
		[bufferDict setObject:self.price forKey:@"price"];
	}
    
    [bufferDict setObject:[NSNumber numberWithUnsignedLongLong:_itemId] forKey:@"itemId"];
    
	if (self.title) {
		[bufferDict setObject:self.title forKey:@"title"];
	}
	if (self.itemPic) {
		[bufferDict setObject:self.itemPic forKey:@"itemPic"];
	}
	if (self.totalSoldQuantity) {
		[bufferDict setObject:self.totalSoldQuantity forKey:@"totalSoldQuantity"];
	}
    
	NSDictionary *outputDict = [NSDictionary dictionaryWithDictionary:bufferDict];
	return outputDict;
}

- (NSString *) JSONRepresentation
{
	return [[self toDictionary] JSONRepresentation];
}

-(NSString *)getTotalSoldQuantityNum{
    if (self.totalSoldQuantity && self.totalSoldQuantity.length > 0) {
        BigNumberType quantity = [self.totalSoldQuantity unsignedLongLongValue];
        return [TBSCUtils longAbbreviation:quantity];
    }
    return nil;
}

-(void)setFeedCommentCommodityItem:(TBSCCommentCommodityItem*)feedCommentCommodityItem{
    self.price = feedCommentCommodityItem.price;
    self.title = feedCommentCommodityItem.title;
    self.itemId = feedCommentCommodityItem.itemId;
    self.itemPic = feedCommentCommodityItem.itemPic;
}

@end
