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

#import "BsFlutterModalPlugin.h"

FOUNDATION_EXPORT double bs_flutter_modalVersionNumber;
FOUNDATION_EXPORT const unsigned char bs_flutter_modalVersionString[];
