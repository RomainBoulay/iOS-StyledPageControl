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
	self=[super initWithCoder:aDecoder];
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
    
    // Defaults
    self.coreNormalColor = COLOR_GRAYISHBLUE;
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
	[self addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - Interactions
- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2) {
        // move left
        if (self.currentPage > 0) {
            if (touchPoint.x <= 22)
                self.currentPage = 0;
            else
                self.currentPage -= 1;
        }
    }
    else {
        // move right
        if (self.currentPage < self.numberOfPages-1) {
            if (touchPoint.x >= (CGRectGetWidth(self.bounds) - 22))
                self.currentPage = self.numberOfPages-1;
            else
                self.currentPage += 1;
        }
    }
    
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    UIColor *coreSelectedColor, *strokeNormalColor, *strokeSelectedColor;
    
    if (self.coreSelectedColor)
        coreSelectedColor = self.coreSelectedColor;
    else if (self.pageControlStyle==PageControlStyleStrokedSquare ||
             self.pageControlStyle==PageControlStyleStrokedCircle ||
             self.pageControlStyle==PageControlStyleWithPageNumber) {
        coreSelectedColor = COLOR_GRAYISHBLUE;
    }
    else {
        coreSelectedColor = COLOR_GRAY;
    }
    
    if (self.strokeNormalColor)
        strokeNormalColor = self.strokeNormalColor;
    else if (self.pageControlStyle==PageControlStyleDefault && self.coreNormalColor) {
        strokeNormalColor = self.coreNormalColor;
    }
    else {
        strokeNormalColor = COLOR_GRAYISHBLUE;
    }
    
    if (self.strokeSelectedColor)
        strokeSelectedColor = self.strokeSelectedColor;
    else if (self.pageControlStyle==PageControlStyleStrokedSquare ||
             self.pageControlStyle==PageControlStyleStrokedCircle ||
             self.pageControlStyle==PageControlStyleWithPageNumber) {
        strokeSelectedColor = COLOR_GRAYISHBLUE;
    }
    else if (self.pageControlStyle==PageControlStyleDefault && self.coreSelectedColor) {
        strokeSelectedColor = self.coreSelectedColor;
    }
    else {
        strokeSelectedColor = COLOR_GRAY;
    }
    
    // Drawing code
    if (self.hidesForSinglePage && self.numberOfPages==1) {
		return;
	}
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	NSInteger gap = self.gapWidth;
    float diameter = self.diameter - 2 * self.strokeWidth;
    
    if (self.pageControlStyle == PageControlStyleThumb && (self.thumbImage && self.selectedThumbImage)) {
        diameter = self.thumbImage.size.width;
    }
	
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
					totalWidth  = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
				}
			}
			
			if (diameter == 2) {
				break;
				totalWidth = self.numberOfPages * diameter + (self.numberOfPages-1) * gap;
			}
		}
	}
	
	NSInteger i;
	for (i = 0; i < self.numberOfPages; i++) {
		NSInteger x = (self.frame.size.width-totalWidth )/2 + i*(diameter+gap);
        
        if (self.pageControlStyle==PageControlStyleDefault) {
            if (i==self.currentPage) {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetFillColorWithColor(myContext, [self.coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedCircle) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i == self.currentPage) {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedSquare) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
                CGContextStrokeRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleWithPageNumber) {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            
            if (i == self.currentPage) {
                NSInteger _currentPageDiameter = diameter*1.6;
                x = (self.frame.size.width-totalWidth )/2 + i*(diameter+gap) - (_currentPageDiameter-diameter)/2;
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2,_currentPageDiameter,_currentPageDiameter));
                
                NSString *pageNumber = [NSString stringWithFormat:@"%i", i+1];
                CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);
                [pageNumber drawInRect:CGRectMake(x,(self.frame.size.height-_currentPageDiameter)/2-1,_currentPageDiameter,_currentPageDiameter) withFont:[UIFont systemFontOfSize:_currentPageDiameter-2] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            }
            else {
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
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
                CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
            else {
                CGContextSetFillColorWithColor(myContext, [self.coreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
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


- (void)setCurrentPage:(int)page {
    _currentPage = page;
    [self setNeedsDisplay];
}


- (void)setNumberOfPages:(int)numOfPages {
    _numberOfPages = numOfPages;
    [self setNeedsDisplay];
}


- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index {
    if (self.thumbImageForIndex == nil) {
        [self setThumbImageForIndex:[NSMutableDictionary dictionary]];
    }
    
    if ((aThumbImage != nil))
        (self.thumbImageForIndex)[@(index)] = aThumbImage;
    else
        [self.thumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}


- (UIImage *)thumbImageForIndex:(NSInteger)index {
    UIImage* aThumbImage = (self.thumbImageForIndex)[@(index)];
    if (aThumbImage == nil)
        aThumbImage = self.thumbImage;
    
    return aThumbImage;
}


- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index {
    if (self.selectedThumbImageForIndex == nil) {
        [self setSelectedThumbImageForIndex:[NSMutableDictionary dictionary]];
    }
    
    if ((aSelectedThumbImage != nil))
        (self.selectedThumbImageForIndex)[@(index)] = aSelectedThumbImage;
    else
        [self.selectedThumbImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}


- (UIImage *)selectedThumbImageForIndex:(NSInteger)index {
    UIImage* aSelectedThumbImage = (self.selectedThumbImageForIndex)[@(index)];
    if (aSelectedThumbImage == nil)
        aSelectedThumbImage = self.selectedThumbImage;
    
    return aSelectedThumbImage;
}


@end
