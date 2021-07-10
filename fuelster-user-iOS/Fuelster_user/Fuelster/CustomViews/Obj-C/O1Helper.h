//
//  O1Helper.h
//  O1Util
//
//  Created by Ji Fang on 6/5/13.
//  Copyright (c) 2013 Workspot. All rights reserved.
//

typedef void (^O1CompletionBlock)(void);

#define O1_SEL_KEY(key) NSStringFromSelector(@selector(key))

#define O1_SYNTHESIZE(KEY, SETTER, TYPE, OPTION) \
        static char KEY##Key; \
        - (TYPE)KEY \
        { \
            return objc_getAssociatedObject(self, &KEY##Key); \
        } \
        - (void)SETTER:(TYPE)KEY \
        { \
            objc_setAssociatedObject(self, &KEY##Key, KEY, OPTION); \
        }

#define O1_SYNTHESIZE_BOOL(KEY, SETTER) \
        static char KEY##Key; \
        - (BOOL)KEY \
        { \
            return [objc_getAssociatedObject(self, &KEY##Key) boolValue]; \
        } \
        - (void)SETTER:(BOOL)KEY \
        { \
            objc_setAssociatedObject(self, &KEY##Key, @(KEY), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
        }

#define O1_SYNTHESIZE_UINT(KEY, SETTER) \
        static char KEY##Key; \
        - (NSUInteger)KEY \
        { \
            return [objc_getAssociatedObject(self, &KEY##Key) unsignedIntegerValue]; \
        } \
        - (void)SETTER:(NSUInteger)KEY \
        { \
            objc_setAssociatedObject(self, &KEY##Key, @(KEY), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
        }
