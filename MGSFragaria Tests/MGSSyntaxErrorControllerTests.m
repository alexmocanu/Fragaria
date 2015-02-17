//
//  MGSSyntaxErrorControllerTests.m
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "MGSSyntaxErrorController.h"
#import "SMLSyntaxError.h"

@interface MGSSyntaxErrorControllerTests : XCTestCase

@property (nonatomic,strong) MGSSyntaxErrorController *errorController;

@end

@implementation MGSSyntaxErrorControllerTests

- (void)setUp
{
    [super setUp];

    NSArray *tmp = @[
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 1.",
                                                           @"line" : @(4),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                           }],

                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 2.",
                                                           @"line" : @(4),
                                                           @"hidden" : @(YES),
                                                           @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 3.",
                                                           @"line" : @(37),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 4.",
                                                           @"line" : @(37),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryDocument)
                                                           }],
                     [NSString stringWithFormat:@"%@", @"I don't belong here."],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 5.",
                                                           @"line" : @(189),
                                                           @"hidden" : @(NO),
                                                           @"warningLevel" : @(kMGSErrorCategoryError)
                                                           }],
                     [SMLSyntaxError errorWithDictionary:@{
                                                           @"description" : @"Sample error 6.",
                                                           @"line" : @(212),
                                                           @"hidden" : @(YES),
                                                           @"warningLevel" : @(kMGSErrorCategoryPanic)
                                                           }],
                     ];
    self.errorController = [[MGSSyntaxErrorController alloc] initWithArray:tmp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_linesWithErrors
{
    NSArray *result = [[self.errorController linesWithErrors] sortedArrayUsingSelector:@selector(compare:)];
    NSArray *expects = @[@(4), @(37), @(189)];

    XCTAssertEqualObjects(result, expects);
}



- (void)test_errorCountForLine
{
    NSInteger result4 = [self.errorController errorCountForLine:4];
    NSInteger result37 = [self.errorController errorCountForLine:37];
    NSInteger result189 = [self.errorController errorCountForLine:189];
    NSInteger result212 = [self.errorController errorCountForLine:212];

    XCTAssert(result4 == 1 && result37 == 2 && result189 == 1 && result212 == 0);
}


- (void)test_errorForLine
{
    // We should get kMGSErrorAccess, because the other error is hidden.
    float result4 = [[self.errorController errorForLine:4] warningLevel];

    // We should get @"Sample error 3." because error level is the same, and this is the first one.
    NSString *result37 = [[self.errorController errorForLine:37] description];

    XCTAssert(result4 == kMGSErrorCategoryAccess && [result37 isEqualToString:@"Sample error 3."]);

}


- (void)test_errorsForLine
{
    SMLSyntaxError *testContent = [[self.errorController errorsForLine:4] objectAtIndex:0];
    NSInteger testQuantity = [[self.errorController errorsForLine:37] count];

    XCTAssert([testContent.description isEqualToString:@"Sample error 1."] && testQuantity == 2);
}


- (void)test_nonHiddenErrors
{
    NSInteger testQuantity = [[self.errorController nonHiddenErrors] count];

    XCTAssert(testQuantity == 4);
}


- (void)test_errorDecorations
{
    NSDictionary *resultDict = [self.errorController errorDecorations];
    NSImage *image = [resultDict objectForKey:@(189)];

    // kMGSErrorError is line 189's image, and that is in the bundle messagesError.icns.
    NSImage *compare = [[NSBundle bundleForClass:[SMLSyntaxError class]] imageForResource:@"messagesError"];

    XCTAssert([[image TIFFRepresentation] isEqualToData:[compare TIFFRepresentation]]);

}


- (void)test_errorDecorationsHavingSize
{
    NSDictionary *resultDict = [self.errorController errorDecorationsHavingSize:NSMakeSize(123.0, 119.4)];
    NSImage *image = [resultDict objectForKey:@(4)];

    // kMGSErrorAccess is line 4's image, and that is in the bundle messagesError.icns.
    NSImage *compare = [[NSBundle bundleForClass:[SMLSyntaxError class]] imageForResource:@"messagesAccess"];

    XCTAssert([[image TIFFRepresentation] isEqualToData:[compare TIFFRepresentation]] && image.size.width == 123.0 && image.size.height == 119.4 );
}


@end
