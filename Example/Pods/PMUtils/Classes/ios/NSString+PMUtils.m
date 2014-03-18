//
//  NSString+PMUtils.m
//  
//
//  Created by Peter Meyers on 3/1/14.
//
//

#import "NSString+PMUtils.h"
#import "NSData+PMUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (PMUtils)

- (NSString *) encodedQuery
{
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)sha1Hash
{
	unsigned char	sha1Bytes[CC_SHA1_DIGEST_LENGTH];
	
	if (CC_SHA1([self UTF8String], (CC_LONG)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], sha1Bytes))
	{
		NSData		*data		= [NSData dataWithBytes:sha1Bytes length:CC_SHA1_DIGEST_LENGTH];
		
		return [data hexString];
	}
	
	return nil;
}

- (BOOL) isCapitalized
{
	return [[self capitalizedString] isEqualToString:self];
}

- (NSComparisonResult) compareWithVersion:(NSString *)otherVersion
{
	// We want 1.0 and 1.0.0 to return NSOrderedSame.
	NSString *v1 = [self removeTrailingZerosAndPeriods];
	NSString *v2 = [otherVersion removeTrailingZerosAndPeriods];
    return [v1 compare:v2 options:NSNumericSearch];
}

- (NSString *) removeTrailingZerosAndPeriods
{
	NSRange rangeToDelete = NSMakeRange(self.length, 0);
	char lastChar = [self characterAtIndex:rangeToDelete.location-1];
	while (lastChar == '.' || lastChar == '0')
	{
		rangeToDelete.location--;
		rangeToDelete.length++;
		lastChar = [self characterAtIndex:rangeToDelete.location-1];
	}
	return [self stringByReplacingCharactersInRange:rangeToDelete withString:@""];
}

- (BOOL) inVersion:(NSString *)baseVersion
{
	NSArray *selfComponents = [self componentsSeparatedByString:@"."];
	NSArray *baseComponents = [baseVersion componentsSeparatedByString:@"."];
	
	if (selfComponents.count < baseComponents.count) {
		return NO; // x.y is not included in x.y.z
	}
	
	for (NSInteger i = 0; i < selfComponents.count; i++)
	{
		if (baseComponents.count == i) {
			return YES; // x.y.z is included in x.y
		}
		else if ( ![selfComponents[i] isEqualToString:baseComponents[i]] ) {
			return NO; // x.y.a is not included in x.y.b
		}
	}
	
	return YES; // x.y.z is included in x.y.z
}

+ (NSString *) systemVersion
{
	return [[UIDevice currentDevice] systemVersion];
}

- (BOOL) containsEmoji
{
	__block BOOL returnValue = NO;
	[self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
	 ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		 
		 const unichar hs = [substring characterAtIndex:0];
		 // surrogate pair
		 if (0xd800 <= hs && hs <= 0xdbff) {
			 if (substring.length > 1) {
				 const unichar ls = [substring characterAtIndex:1];
				 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
				 if (0x1d000 <= uc && uc <= 0x1f77f) {
					 returnValue = YES;
				 }
			 }
		 } else if (substring.length > 1) {
			 const unichar ls = [substring characterAtIndex:1];
			 if (ls == 0x20e3) {
				 returnValue = YES;
			 }
			 
		 } else {
			 // non surrogate
			 if (0x2100 <= hs && hs <= 0x27ff) {
				 returnValue = YES;
			 } else if (0x2B05 <= hs && hs <= 0x2b07) {
				 returnValue = YES;
			 } else if (0x2934 <= hs && hs <= 0x2935) {
				 returnValue = YES;
			 } else if (0x3297 <= hs && hs <= 0x3299) {
				 returnValue = YES;
			 } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
				 returnValue = YES;
			 }
		 }
	 }];
	
	return returnValue;
}

@end
