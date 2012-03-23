/* StatBarPlugin - IOS side of the bridge to StatBarPlugin JavaScript for PhoneGap
 *
 * @author WizCorp Inc. [ Incorporated Wizards ] 
 * @copyright 2011
 * @file StatBarPlugin.m for PhoneGap
 *
 */ 

#import "StatBarPlugin.h"
#import "WizDebugLog.h"

/*
 // Remove once booting game in the shell, or conflicts..
 #ifdef PHONEGAP_FRAMEWORK
 #import <PhoneGap/JSON.h>
 #else
 #import "JSON.h"
 #endif
 
 */
@implementation StatBarPlugin

@synthesize headerView;



-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (StatBarPlugin*)[super initWithWebView:theWebView];
    isHeaderAlive = FALSE;
    if (self) 
	{
		originalWebViewBounds = theWebView.bounds;
    }
    return self;
}



/*
 * Update the Header Web View with new HTML from assets
 */
- (void)update:(NSArray*)arguments withDict:(NSDictionary*)options
{
    // (if) get arguments
    if ([arguments count] > 1) 
	{
        NSString *URI        = [arguments objectAtIndex:1];
        WizLog(@"NOW UPDATING HTML %@", URI);
        // check header view exists
        if (headerView) {
            
            [headerView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:URI]]];
        }
    }
   
    
}


/*
 * Header Web View
 */
- (void)create:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    if (isHeaderAlive){
        
        PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        
        return;
    }
    isHeaderAlive = TRUE;
    WizLog(@"[statBarPlugin] ******* creating statBar");
    
    
    headerView = [UIWebView new];
    [headerView sizeToFit];
    headerView.delegate = self;
    headerView.multipleTouchEnabled   = NO;
    headerView.autoresizesSubviews    = YES;
    headerView.hidden                 = YES;
    headerView.userInteractionEnabled = YES;
	headerView.opaque = YES;
    headerView.tag = 999;
    headerView.backgroundColor = [UIColor blackColor];
    
    
    if (options) 
	{
        animDuration        = [[options objectForKey:@"duration"] floatValue];
        if (!animDuration) {
            animDuration = 0.7;
        }
        headerViewHeight    = [[options objectForKey:@"height"] floatValue];
        if (!headerViewHeight) {
            headerViewHeight = 50.0f;
        }
        // using with wizNavi bar plugin?
        usesWizNavi       = [[options objectForKey:@"usesWizNavi"] boolValue];
        if (!usesWizNavi) {
            usesWizNavi = NO;
        }
        WizLog(@"[statBarPlugin] ******* creating usesWizNavi %d", usesWizNavi);
        
        
    } else {
        // default values
        animDuration        = 0.3;
        headerViewHeight    = 50.0f;
        usesWizNavi         = NO;
    }
    
    isHeaderViewDisplayed = NO;
    
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"header" ofType: @"html" inDirectory:@"www"];
    
    NSString *newHTMLString = [[NSString alloc] initWithContentsOfFile: fileString encoding: NSUTF8StringEncoding error: NULL];
    
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: fileString];
    
    [headerView loadHTMLString: newHTMLString baseURL: newURL];
    
    [newHTMLString release];
    [newURL release];
    
    headerView.bounds = originalWebViewBounds;
    
    [ self.webView.superview setBackgroundColor:[UIColor blackColor] ];
	[ self.webView.superview addSubview:headerView ];  
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    
  
    // format
    // tapBack://pageView
    NSString *requestString = [[request URL] absoluteString];
	
    
    if ([requestString hasPrefix:@"tapBack:"]) {
        
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSString *function = (NSString*)[components objectAtIndex:1];
		
        if([function hasPrefix:@"//tapFromStatBar"]) {
            
            NSString *thefunction = [function stringByReplacingOccurrencesOfString:@"/" withString:@""];
            thefunction = [NSString stringWithFormat:@"%@()", thefunction];
            
            [self writeJavascript: thefunction];
            
            
        }
        /*
        [components release];
        [function release];
        */
        return NO;
        
	}
    
    
    
    
    
    // Never accept a change of URL
	return YES;
}




/**
 * Enable the entire bar.
 */
- (void)enable:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    WizLog(@"[StatBarPlugin] ******* enable stat bar!! ");
    
    NSString *callbackId = [arguments objectAtIndex:0];
    PluginResult* pluginResult;
    
    
    if (!headerView){
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"call create first"];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
		return;
	}
    if (headerView.alpha == 1.0) {
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        return;
    } else {
        headerView.alpha = 1.0;
        headerView.userInteractionEnabled = true;
        
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    }
    
    
    
}


/**
 * Disable the entire bar.
 */
- (void)disable:(NSArray*)arguments withDict:(NSDictionary*)options
{
    WizLog(@"[StatBarPlugin] ******* disable stat bar!! ");
    
    NSString *callbackId = [arguments objectAtIndex:0];
    PluginResult* pluginResult;
    
    if (!headerView){
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"call create first"];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
		return;
	}
    if (headerView.alpha == 0.3) {
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        return;
    } else {
        headerView.alpha = 0.3;
        headerView.userInteractionEnabled = false;
        
        
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        
    }
    
    
}




- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options
{
    WizLog(@"[statBarPlugin] ******* show statBar ");
    
    NSString *callbackId = [arguments objectAtIndex:0];
    
    // if no headerView it has not been created yet..
    if (!headerView){
        PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"call create first"];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
		return;
	}
    
    BOOL animate = NO;
    
    if (options) 
	{
        animate             = [[options objectForKey:@"animate"] boolValue];
        
    } else {
        // default values
        animate             =   TRUE;
    }
    
    headerView.hidden = NO;
    CGRect webViewBounds = originalWebViewBounds;
    
    if (!usesWizNavi) {
        // wizNavi will control if the plugin is installed and usesWizNavi == true
        WizLog(@"[statBarPlugin] ******* hiding usesWizNavi nothing happen heeeeer"); 
        
        if(animate)
        {
            
            [headerView setFrame:CGRectMake(
                                            webViewBounds.origin.x,
                                            webViewBounds.origin.y - headerViewHeight,
                                            webViewBounds.size.width,
                                            headerViewHeight
                                            )];
            
            
            [self.webView setFrame:CGRectMake(
                                              webViewBounds.origin.x,
                                              webViewBounds.origin.y,
                                              webViewBounds.size.width,
                                              webViewBounds.size.height
                                              )];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animDuration];
        }
        
        [headerView setFrame:CGRectMake(
                                        webViewBounds.origin.x,
                                        webViewBounds.origin.y,
                                        webViewBounds.size.width,
                                        headerViewHeight
                                        )];
        
        
        
        [self.webView setFrame:CGRectMake(
                                          webViewBounds.origin.x,
                                          webViewBounds.origin.y + headerViewHeight,
                                          webViewBounds.size.width,
                                          webViewBounds.size.height - headerViewHeight
                                          )];
        
        if(animate)
        {
            [UIView commitAnimations];
        }
    } else {
        // let wizNavi control the webview
        if(animate)
        {
            
            [headerView setFrame:CGRectMake(
                                            webViewBounds.origin.x,
                                            webViewBounds.origin.y - headerViewHeight,
                                            webViewBounds.size.width,
                                            headerViewHeight
                                            )];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animDuration];
        }
        
        [headerView setFrame:CGRectMake(
                                        webViewBounds.origin.x,
                                        webViewBounds.origin.y,
                                        webViewBounds.size.width,
                                        headerViewHeight
                                        )];
        
        if(animate)
        {
            [UIView commitAnimations];
        }
        
        
    }
    
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
    
}









/*
 *
 * Hide the header view
 */
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options
{
    WizLog(@"[statBarPlugin] ******* hiding statBar");
    
    NSString *callbackId = [arguments objectAtIndex:0];
    
    // if no headerView it has not been created yet..
    if (!headerView){
        PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"call create first"];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
		return;
	}
    
    BOOL animate = NO;
    
    if (options) 
	{
        animate = [[options objectForKey:@"animate"] boolValue];
    }
    
    CGRect webViewBounds = originalWebViewBounds;
    
    if (!usesWizNavi) {
        // wizNavi will control if the plugin is installed and usesWizNavi == true
        WizLog(@"[statBarPlugin] ******* hiding usesWizNavi nothing happen heeeeer");
        
        if(animate)
        {
            
            [headerView setFrame:CGRectMake(
                                            webViewBounds.origin.x,
                                            webViewBounds.origin.y,
                                            webViewBounds.size.width,
                                            headerView.frame.size.height
                                            )];
            
            
            [self.webView setFrame:CGRectMake(
                                              webViewBounds.origin.x,
                                              webViewBounds.origin.y,
                                              webViewBounds.size.width,
                                              webViewBounds.size.height
                                              )];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animDuration];
        }
        
        [headerView setFrame:CGRectMake(
                                        webViewBounds.origin.x,
                                        webViewBounds.origin.y - headerView.frame.size.height,
                                        webViewBounds.size.width,
                                        headerView.frame.size.height
                                        )];
        
        [self.webView setFrame:CGRectMake(
                                          webViewBounds.origin.x,
                                          webViewBounds.origin.y,
                                          webViewBounds.size.width,
                                          webViewBounds.size.height
                                          )];
        
        if(animate)
        {
            [UIView commitAnimations];
        }
    } else {
        if(animate)
        {
            
            [headerView setFrame:CGRectMake(
                                            webViewBounds.origin.x,
                                            webViewBounds.origin.y,
                                            webViewBounds.size.width,
                                            headerView.frame.size.height
                                            )];
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animDuration];
        }
        
        [headerView setFrame:CGRectMake(
                                        webViewBounds.origin.x,
                                        webViewBounds.origin.y - headerView.frame.size.height,
                                        webViewBounds.size.width,
                                        headerView.frame.size.height
                                        )];
        
        
        if(animate)
        {
            [UIView commitAnimations];
        }
        
    }
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}






- (void)sendStats:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    NSString *data2Send;
    NSString *callbackId = [arguments objectAtIndex:0];
    PluginResult * pluginResult;
    
    
    // if no headerView it has not been created yet..
    if (!headerView){
        PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"call create first"];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
		return;
	}
    
    
    if (options) 
	{
        data2Send = [options JSONRepresentation];
        // WizLog(@"[StatBarPlugin] ******* send -> %@", data2Send);
        [headerView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"updateStats('%@');",[data2Send stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        // ok
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
        
    } else {
        // error
        pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR messageAsString:@"noParams"];
    }
    
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}


@end