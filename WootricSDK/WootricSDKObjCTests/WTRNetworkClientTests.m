//
//  WTRNetworkClientTests.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 13/04/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WTRNetworkClient.h"

@interface WTRNetworkClientTests : XCTestCase

@property (nonatomic, strong) WTRNetworkClient *api;

@end

@interface WTRNetworkClient (Tests)

- (BOOL)needsSurvey;
- (NSString *)percentEscapeString:(NSString *)string;
- (NSString *)parseCustomProperties;
- (NSString *)getBaseAPIURL;

@end

@implementation WTRNetworkClientTests

- (void)setUp {
  [super setUp];
  self.api = [WTRNetworkClient sharedInstance];
}

- (void)tearDown {
  [super tearDown];
  _api.settings.surveyImmediately = NO;
  _api.settings.firstSurveyAfter = 31;
  _api.clientID = nil;
  _api.clientSecret = nil;
  _api.accountToken = nil;
  _api.endUserEmail = nil;
  _api.settings.customProperties = nil;

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"surveyed"];
  [defaults removeObjectForKey:@"lastSeenAt"];
}

- (void)testAPIURLString {
  XCTAssertEqualObjects(@"https://api.wootric.com", _api.getBaseAPIURL);
}

// surveyed = NO, surveyImmediately = YES
- (void)testNeedsSurveyCaseOne {
  _api.settings.surveyImmediately = YES;
  XCTAssertTrue(_api.needsSurvey);
}

// surveyed = YES, surveyImmediately = YES
- (void)testNeedsSurveyCaseTwo {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _api.settings.surveyImmediately = YES;
  XCTAssertFalse(_api.needsSurvey);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31
- (void)testNeedsSurveyCaseThree {
  _api.settings.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (32 * 60 * 60 * 24); // 32 days ago
  XCTAssertTrue([_api needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, lastSeenAt = 20
- (void)testNeedsSurveyCaseFour {
  _api.settings.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24); // 20 days ago
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertFalse([_api needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyCaseFive {
  _api.settings.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (40 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertTrue([_api needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 60, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyCaseSix {
  _api.settings.firstSurveyAfter = 60;
  _api.settings.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (40 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertFalse([_api needsSurvey]);
}

// firstSurveyAfter = 0
- (void)testNeedsSurveyCaseSeven {
  _api.settings.firstSurveyAfter = 0;
  XCTAssertTrue([_api needsSurvey]);
}

// With one of the setting missing
- (void)testCheckConfigurationCaseOne {
  _api.clientID = @"clientID";
  _api.clientSecret = @"clientSecret";
  _api.accountToken = @"accountToken";
  _api.endUserEmail = @"endUserEmail";
  XCTAssertFalse(_api.checkConfiguration);
}

// All settings in place
- (void)testCheckConfigurationCaseTwo {
  _api.clientID = @"clientID";
  _api.clientSecret = @"clientSecret";
  _api.accountToken = @"accountToken";
  _api.endUserEmail = @"endUserEmail";
  _api.originURL = @"originURL";
  XCTAssertTrue(_api.checkConfiguration);
}

// One of the strings is empty
- (void)testCheckConfigurationCaseThree {
  _api.clientID = @"clientID";
  _api.clientSecret = @"clientSecret";
  _api.accountToken = @"accountToken";
  _api.endUserEmail = @"";
  _api.originURL = @"originURL";
  XCTAssertFalse(_api.checkConfiguration);
}

// Percent escape
- (void)testPercentEscapeCaseOne {
  NSString *testString = @"test test test";
  NSString *escapedString = [_api percentEscapeString:testString];

  XCTAssertEqualObjects(@"test+test+test", escapedString);
}

- (void)testPercentEscapeCaseTwo {
  NSString *testString = @"!#$&'()*+,/:;=?@[]";
  NSString *escapedString = [_api percentEscapeString:testString];

  XCTAssertEqualObjects(@"%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D", escapedString);
}

- (void)testParseCustomPropertiesCaseOne {
  _api.settings.customProperties = @{@"plan": @"enterprise"};
  NSString *parsedProperties = [_api parseCustomProperties];

  XCTAssertEqualObjects(@"&properties[plan]=enterprise", parsedProperties);
}

- (void)testParseCustomPropertiesCaseTwo {
  _api.settings.customProperties = @{@"value": @1};
  NSString *parsedProperties = [_api parseCustomProperties];

  XCTAssertEqualObjects(@"&properties[value]=1", parsedProperties);
}

- (void)testParseCustomPropertiesCaseThree {
  _api.settings.customProperties = @{@"escaped": @"!#$&'()*+,/:;=?@[]"};
  NSString *parsedProperties = [_api parseCustomProperties];

  XCTAssertEqualObjects(@"&properties[escaped]=%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D", parsedProperties);
}

@end