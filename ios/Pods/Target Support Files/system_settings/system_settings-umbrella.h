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

#import "SystemSettingsPlugin.h"

FOUNDATION_EXPORT double system_settingsVersionNumber;
FOUNDATION_EXPORT const unsigned char system_settingsVersionString[];

