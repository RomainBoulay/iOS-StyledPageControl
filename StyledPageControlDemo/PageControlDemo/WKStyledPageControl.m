// --
// Forked from https://github.com/honcheng/iOS-StyledPageControl
// --


#import "WKStyledPageControl.h"


@implementation WKStyledPageControl

#define COLOR_GRAYISHBLUE [UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]


#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupStyledPageControl];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupStyledPageControl];
	}
	return self;
}


- (void)setupStyledPageControl {
	[self setBackgroundColor:[UIColor clearColor]];
	
	_strokeWidth = 2;
	_gapWidth = 10;
	_diameter = 12;
	_pageControlStyle = PageControlStyleDefault;
    
    // coreNormalColor default
    self.coreNormalColor = COLOR_GRAYISHBLUE;
    
    // coreSelectedColor default
    if (self.pageControlStyle == PageControlStyleStrokedSquare ||
             self.pageControlStyle == PageControlStyleStrokedCircle ||
             self.pageControlStyle == PageControlStyleWithPageNumber)
        self.coreSelectedColor = COLOR_GRAYISHBLUE;
    else
        self.coreSelectedColor = COLOR_GRAY;
    
    // strokeNormalColor default
    if (self.pageControlStyle == PageControlStyleDefault)
        self.strokeNormalColor = self.coreNormalColor;
    else
        self.strokeNormalColor = COLOR_GRAYISHBLUE;
    
    // strokeSelectedColor default
    if (self.pageControlStyle==PageControlStyleStrokedSquare ||
        self.pageControlStyle==PageControlStyleStrokedCircle ||
        self.pageControlStyle==PageControlStyleWithPageNumber)
        self.strokeSelectedColor = COLOR_GRAYISHBLUE;
    else if (self.pageControlStyle == PageControlStyleDefault)
        self.strokeSelectedColor = self.coreSelectedColor;
    else
        self.strokeSelectedColor = COLOR_GRAY;
    
    // Gesture
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
	[self addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - Getters
- (NSMutableDictionary *)selectedThumbImageForIndex {
    if (_selectedThumbImageForIndex)
        return _selectedThumbImageForIndex;
    
    self.selectedThumbImageForIndex = [[NSMutableDictionary alloc] init];
    return _selectedThumbImageForIndex;
}


- (NSMutableDictionary *)thumbImageForIndex {
    if (_thumbImageForIndex)
        return _thumbImageForIndex;
    
    self.thumbImageForIndex = [[NSMutableDictionary alloc] init];
    return _thumbImageForIndex;
}


#pragma mark - Interactions
- (void)onTapped:(UITapGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    NSInteger minX = self.gapWidth + self.diameter;
    
    if (touchPoint.x < self.frame.size.width/2) {
        // move left
        if (self.currentPage > 0) {
            if (touchPoint.x <= minX)
                self.currentPage = 0;
            else
                self.currentPage -= 1;
        }
    }
    else {
        // move right
        if (self.currentPage < self.numberOfPages - 1) {
            if (touchPoint.x >= (CGRectGetWidth(self.bounds) - minX))
                self.currentPage = self.numberOfPages - 1;
            else
                self.currentPage += 1;
        }
    }
    
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.hidesForSinglePage && self.numberOfPages == 1)
		return;
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	NSInteger gap = self.gapWidth;
    CGFloat diameter = self.diameter - 2 * self.strokeWidth;
    
    if (self.pageControlStyle == PageControlStyleThumb &&
        (self.thumbImage && self.selectedThumbImage))
        diameter = self.thumbImage.size.width;
	
	NSInteger totalWidth  = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
	if (totalWidth > self.frame.size.width) {
		while (totalWidth  > self.frame.size.width) {
			diameter -= 2;
			gap = diameter + 2;
			while (totalWidth  > self.frame.size.width) {
				gap -= 1;
				totalWidth  = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
				
				if (gap == 2) {
					break;
//					totalWidth  = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
				}
			}
			
			if (diameter == 2) {
				break;
//				totalWidth = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
			}
		}
	}
	
	NSInteger i;
	for (i = 0; i < self.numberOfPages; i++) {
		NSInteger x = (self.frame.size.width-totalWidth )/2 + i*(diameter+gap);
        
        if (self.pageControlStyle==PageControlStyleDefault) {
            if (i==self.currentPage) {
                CGContextSetFillColorWithColor(myContext, [self.coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetFillColorWithColor(myContext, [self.coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedCircle) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i == self.currentPage) {
                CGContextSetFillColorWithColor(myContext, [self.coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetStrokeColorWithColor(myContext, [self.strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedSquare) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [self.coreSelectedColor CGColor]);
                CGContextFillRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeSelectedColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [self.strokeNormalColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleWithPageNumber) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            
            if (i == self.currentPage) {
                NSInteger _currentPageDiameter = diameter*1.6;
                x = (self.frame.size.width-totalWidth )/2 + i*(diameter+gap) - (_currentPageDiameter-diameter)/2;
                CGContextSetFillColorWithColor(myContext, [self.coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                
                NSString *pageNumber = [NSString stringWithFormat:@"%i", i+1];
                CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);
                [pageNumber drawInRect:CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2-1,_currentPageDiameter,_currentPageDiameter) withFont:[UIFont systemFontOfSize:_currentPageDiameter-2] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            }
            else {
                CGContextSetStrokeColorWithColor(myContext, [self.strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStylePressed1 || self.pageControlStyle==PageControlStylePressed2) {
            if (self.pageControlStyle==PageControlStylePressed1) {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2-1,diameter,diameter));
            }
            else if (self.pageControlStyle==PageControlStylePressed2) {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2+1,diameter,diameter));
            }
            
            
            if (i == self.currentPage) {
                CGContextSetFillColorWithColor(myContext, [self.coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetFillColorWithColor(myContext, [self.coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [self.strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleThumb) {
            UIImage *thumbImage = [self thumbImageForIndex:i];
            UIImage *selectedThumbImage = [self selectedThumbImageForIndex:i];
            
            if (thumbImage && selectedThumbImage) {
                if (i==self.currentPage) {
                    [selectedThumbImage drawInRect:CGRectMake(x,(self.frame.size.height-selectedThumbImage.size.height)/2,selectedThumbImage.size.width,selectedThumbImage.size.height)];
                }
                else {
                    [thumbImage drawInRect:CGRectMake(x,(self.frame.size.height-thumbImage.size.height)/2,thumbImage.size.width,thumbImage.size.height)];
                }
            }
        }
	}
}


- (void)setPageControlStyle:(PageControlStyle)style {
    _pageControlStyle = style;
    [self setNeedsDisplay];
}


#pragma mark - UIPageControl
- (void)setCurrentPage:(int)page {
    _currentPage = page;
    [self setNeedsDisplay];
}


- (void)setNumberOfPages:(int)numOfPages {
    _numberOfPages = numOfPages;
    [self setNeedsDisplay];
}


#pragma mark - Thumb image
- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index {
    if (aThumbImage)
        (self.thumbImageForIndex)[@(index)] = aThumbImage;
    else
        [self.thumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}


- (UIImage *)thumbImageForIndex:(NSInteger)index {
    UIImage *aThumbImage = (self.thumbImageForIndex)[@(index)];
    if (! aThumbImage)
        aThumbImage = self.thumbImage;
    
    return aThumbImage;
}


#pragma mark - Selected thumb image
- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index {
    if (aSelectedThumbImage)
        (self.selectedThumbImageForIndex)[@(index)] = aSelectedThumbImage;
    else
        [self.selectedThumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}


- (UIImage *)selectedThumbImageForIndex:(NSInteger)index {
    UIImage *aSelectedThumbImage = (self.selectedThumbImageForIndex)[@(index)];
    if (! aSelectedThumbImage)
        aSelectedThumbImage = self.selectedThumbImage;
    
    return aSelectedThumbImage;
}


@end
