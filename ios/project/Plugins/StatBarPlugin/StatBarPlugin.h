/* StatBarPlugin - IOS side of the bridge to StatBarPlugin JavaScript for PhoneGap
 *
 * @author WizCorp Inc. [ Incorporated Wizards ] 
 * @copyright 2011
 * @file StatBarPlugin.h for PhoneGap
 *
 */ 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PhoneGap/PGPlugin.h>



/*
 #ifdef PHONEGAP_FRAMEWORK
 #import <PhoneGap/PGPlugin.h>
 #else
 #import "PGPlugin.h"
 #endif
 */




@interface StatBarPlugin : PGPlugin <UIWebViewDelegate>{
    
    BOOL isHeaderViewDisplayed;
    UIWebView* headerView;
    CGFloat animDuration;
    CGFloat headerViewHeight;
    CGRect originalWebViewBounds;
    BOOL usesWizNavi; 
    BOOL isHeaderAlive;
    
}

/* 
 * StatBarPlugin props
 */
@property (nonatomic, retain) UIWebView *headerView;



/* 
 * StatBarPlugin methods
 */
- (void)update:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)create:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)sendStats:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)enable:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)disable:(NSArray*)arguments withDict:(NSDictionary*)options;


@end
