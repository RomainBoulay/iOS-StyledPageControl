
//@import UIKit;

typedef NS_ENUM(NSUInteger, PageControlStyle) {
    PageControlStyleDefault = 0,
    PageControlStyleStrokedCircle = 1,
    PageControlStylePressed1 = 2,
    PageControlStylePressed2 = 3,
    PageControlStyleWithPageNumber = 4,
    PageControlStyleThumb = 5,
    PageControlStyleStrokedSquare = 6,
};


@interface WKStyledPageControl : UIControl

@property (nonatomic) UIColor *coreNormalColor;
@property (nonatomic) UIColor *coreSelectedColor;

@property (nonatomic) UIColor *strokeNormalColor;
@property (nonatomic) UIColor *strokeSelectedColor;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) PageControlStyle pageControlStyle;

@property (nonatomic, assign) NSInteger strokeWidth;
@property (nonatomic, assign) NSInteger diameter;
@property (nonatomic, assign) NSInteger gapWidth;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *selectedThumbImage;

@property (nonatomic, strong) NSMutableDictionary *thumbImageForIndex;
@property (nonatomic, strong) NSMutableDictionary *selectedThumbImageForIndex;


#pragma mark - Thumb image
- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index;
- (UIImage *)thumbImageForIndex:(NSInteger)index;


#pragma mark - Selected thumb image
- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index;
- (UIImage *)selectedThumbImageForIndex:(NSInteger)index;

@end
