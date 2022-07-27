#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DPAutolocalizationProxy.h"
#import "DPFormattedValue.h"
#import "DPLocalization.h"
#import "DPLocalizationBundle.h"
#import "DPLocalizationManager.h"
#import "DPLocalizationPlatforms.h"
#import "dp_gen_plural.h"
#import "NSAttributedString+DPLocalization.h"
#import "NSObject+DPLocalization.h"
#import "Plural+DPLocalization.h"

FOUNDATION_EXPORT double DPLocalizationVersionNumber;
FOUNDATION_EXPORT const unsigned char DPLocalizationVersionString[];

