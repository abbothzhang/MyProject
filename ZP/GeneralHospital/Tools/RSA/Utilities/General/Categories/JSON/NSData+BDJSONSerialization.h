//
//  BDUtilities
//
//  Created by Patrick Hogan/Manuel Zamora 2012
//

#import "BDError.h"
#import "BDLog.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Interface
////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSData (BDJSONSerialization)

- (NSMutableDictionary *)JSONObject:(BDError *)error;
- (NSMutableArray *)JSONArray:(BDError *)error;

@end
