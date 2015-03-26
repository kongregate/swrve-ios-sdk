
/*******************************************************
 * Copyright (C) 2011-2012 Converser contact@converser.io
 *
 * This file is part of the Converser iOS SDK.
 *
 * This code may not be copied and/or distributed without the express
 * permission of Converser. Please email contact@converser.io for
 * all redistribution and reuse enquiries.
 *******************************************************/

#if !__has_feature(objc_arc)
#error ConverserSDK must be built with ARC.
// You can turn on ARC for only ConverserSDK files by adding -fobjc-arc to the build phase for each of its files.
#endif

#import "SwrveConversationPane.h"
#import "SwrveConversationAtom.h"
#import "SwrveConversationAtomFactory.h"
#import "SwrveConversationButton.h"
#import "SwrveSetup.h"

@implementation SwrveConversationPane
@synthesize content=_content;
@synthesize controls=_controls;
@synthesize tag=_tag;
@synthesize title=_title;

-(id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        _tag = [dict objectForKey:@"tag"];
        _title = [dict objectForKey:@"title"];
        NSArray *contentItems = [dict objectForKey:@"content"];
        if(contentItems) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:contentItems.count];
            for(NSDictionary *contentItemDict in contentItems) {
                if (contentItemDict != (NSDictionary*)[NSNull null]) {
                    SwrveConversationAtom *atom = [SwrveConversationAtomFactory atomForDictionary:contentItemDict];
                    if(atom) {
                        [arr addObject:atom];
                    }
                }
                
            }
            _content = [NSArray arrayWithArray:arr];
        } else {
            _content = nil;
        }
        NSArray *controlItems = [dict objectForKey:@"controls"];
        if(controlItems) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:controlItems.count];
            for(NSDictionary *controlItemDict in controlItems) {
                // Only buttons in this dictionary so cast below should always be right.
                SwrveConversationButton *button = (SwrveConversationButton *)[SwrveConversationAtomFactory atomForDictionary:controlItemDict];
                if(button) {
                    [arr addObject:button];
                }
            }
            _controls = [NSArray arrayWithArray:arr];
        } else {
            _controls = nil;
        }
    }
    return self;
}


@end
