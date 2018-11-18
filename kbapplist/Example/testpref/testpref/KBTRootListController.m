#include "KBTRootListController.h"

@implementation KBTRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root"
                                                  target:self] retain];
    }
    NSLog(@"newspecifierBundle:%@", [NSBundle bundleForClass:[self class]]);
    return _specifiers;
}

@end