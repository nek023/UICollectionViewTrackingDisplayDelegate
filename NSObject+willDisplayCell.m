//
//  NSObject+willDisplayCell.m
//  UICollectionViewTrackingDisplayDelegate
//
//  Created by questbeat on 2013/06/16.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "NSObject+willDisplayCell.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UICollectionViewTrackingDisplayDelegate.h"

@implementation NSObject (willDisplayCell)

+ (void)load
{
    Class *classes = NULL;
    int numberOfClasses = objc_getClassList(NULL, 0);
    
    if (numberOfClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        
        for (int i = 0; i < numberOfClasses; i++) {
            Class class = classes[i];
            
            if (class_conformsToProtocol(class, @protocol(UICollectionViewDataSource))) {
                class_addMethod(class,
                                @selector(_willDisplayCell_collectionView:cellForItemAtIndexPath:),
                                (IMP)_willDisplayCell_collectionView_cellForItemAtIndexPath,
                                "@@:@@");
                
                method_exchangeImplementations(class_getInstanceMethod(class, @selector(collectionView:cellForItemAtIndexPath:)),
                                               class_getInstanceMethod(class, @selector(_willDisplayCell_collectionView:cellForItemAtIndexPath:)));
            }
        }
        
        free(classes);
    }
}

UICollectionViewCell *_willDisplayCell_collectionView_cellForItemAtIndexPath(id self, SEL cmd, UICollectionView *collectionView, NSIndexPath *indexPath) {
    id cell = objc_msgSend(self, @selector(_willDisplayCell_collectionView:cellForItemAtIndexPath:), collectionView, indexPath);
    
    if ([cell isKindOfClass:[UICollectionViewCell class]]) {
        
        if ([collectionView.delegate conformsToProtocol:@protocol(UICollectionViewTrackingDisplayDelegate)]
            && [collectionView.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forRowAtIndexPath:)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
                objc_msgSend(collectionView.delegate, @selector(collectionView:willDisplayCell:forRowAtIndexPath:), self, cell, indexPath);
            });
        }
    }
    
    return cell;
}

@end
