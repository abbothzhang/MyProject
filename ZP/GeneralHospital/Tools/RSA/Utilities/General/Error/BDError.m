//
//  Created by Patrick Hogan/Manuel Zamora 2012
//


////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define BDErrorClassKey @"class"
#define BDErrorTypeKey @"errorType"
#import "BDError.h"
#import "BDLog.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BDError


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.errors = [[NSMutableArray alloc] init];
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Handling errors
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)errorContainsErrors:(BDError *)error;
{
    if (!error)
    {
        return NO;
    }
    
    return [error.errors count];
}


+ (BOOL)    error:(BDError *)error
containsErrorType:(NSString *)errorType
       errorClass:(Class)errorClass
{
    if (!error)
    {
        return NO;
    }
    
    for (NSError *specificError in error.errors)
    {
        if (specificError.code == [errorType hash] && [[specificError.userInfo valueForKey:BDErrorClassKey] isEqualToString:[errorClass description]])
        {
            return YES;
        }
    }
    
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Adding errors
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addErrorWithType:(NSString *)errorType
              errorClass:(Class)errorClass
{
    NSError *error = [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] ? [[NSBundle mainBundle] bundleIdentifier] : @""
                                                code:[errorType hash]
                                            userInfo:@{
                                    BDErrorClassKey : [errorClass description],
                                     BDErrorTypeKey : errorType
                      }];
    
    [self.errors addObject:error];
}


- (void)appendErrorsFromError:(BDError *)error
{
    [self.errors addObjectsFromArray:error.errors];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Convenience
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)description
{
    NSString *errorString = @"Errors:";
    
    for (NSError *error in self.errors)
    {
        errorString = [NSString stringWithFormat:
                       @"%@\n[%@:%@]",
                       errorString,
                       [error.userInfo valueForKey:BDErrorClassKey],
                       [error.userInfo valueForKey:BDErrorTypeKey]];
    }
    
    if ([self.errors count] == 0)
    {
        errorString = [NSString stringWithFormat:
                       @"%@ 0 Errors",
                       errorString];
    }
    
    return errorString;
}


@end
