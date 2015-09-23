//
//  WootricSDK.m
//  WootricSDK
//
// Copyright (c) 2015 Wootric (https://wootric.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WootricSDK.h"
#import "WTRTrackingPixel.h"
#import "WTRSurvey.h"
#import "WTRSurveyViewController.h"
#import "WTRApiClient.h"

@implementation WootricSDK

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = clientID;
  apiClient.clientSecret = clientSecret;
  apiClient.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail andCreatedAt:(NSInteger)externalCreatedAt {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.endUserEmail = endUserEmail;
  apiClient.settings.externalCreatedAt = externalCreatedAt;
}

+ (void)setOriginUrl:(NSString *)originUrl {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.originURL = originUrl;
}

+ (void)forceSurvey:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.forceSurvey = flag;
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  if ([[WTRApiClient sharedInstance] checkConfiguration]) {
    [WTRTrackingPixel getPixel];
    WTRSurvey *surveyClient = [[WTRSurvey alloc] init];
    [surveyClient survey:^{
      NSLog(@"WootricSDK: presenting survey view");
      dispatch_async(dispatch_get_main_queue(), ^{
        [WootricSDK presentSurveyInViewController:viewController];
      });
    }];
  } else {
    NSLog(@"WootricSDK: Configure SDK first");
  }
}

+ (void)presentSurveyInViewController:(UIViewController *)viewController {
  WTRSettings *surveySettings = [WTRApiClient sharedInstance].settings;
  WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSurveySettings:surveySettings];

  [viewController presentViewController:surveyViewController animated:YES completion:nil];
}

#pragma mark - Social Share

+ (void)setTwitterHandler:(NSString *)twitterHandler {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.twitterHandler = twitterHandler;
}

+ (void)setFacebookPage:(NSURL *)facebookPage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.facebookPage = facebookPage;
}

#pragma mark - Custom Thanks

+ (void)setThankYouMessage:(NSString *)thankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouMessage:thankYouMessage];
}

+ (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setDetractorThankYouMessage:detractorThankYouMessage];
}

+ (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPassiveThankYouMessage:passiveThankYouMessage];
}

+ (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPromoterThankYouMessage:promoterThankYouMessage];
}

+ (void)setThankYouLinkWithText:(NSString *)thankYouLinkText andURL:(NSURL *)thankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouLinkWithText:thankYouLinkText andURL:thankYouLinkURL];
}

+ (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText andURL:(NSURL *)detractorThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setDetractorThankYouLinkWithText:detractorThankYouLinkText andURL:detractorThankYouLinkURL];
}

+ (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText andURL:(NSURL *)passiveThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPassiveThankYouLinkWithText:passiveThankYouLinkText andURL:passiveThankYouLinkURL];
}

+ (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText andURL:(NSURL *)promoterThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPromoterThankYouLinkWithText:promoterThankYouLinkText andURL:promoterThankYouLinkURL];
}

#pragma mark - Application Set Custom Messages

+ (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder andDetractor:(NSString *)detractorPlaceholder {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomFollowupPlaceholderForPromoter:promoterPlaceholder passive:passivePlaceholder andDetractor:detractorPlaceholder];
}

+ (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion andDetractor:(NSString *)detractorQuestion {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomFollowupQuestionForPromoter:promoterQuestion passive:passiveQuestion andDetractor:detractorQuestion];
}

@end