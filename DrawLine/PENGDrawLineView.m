//
//  MyDrawLineView.m
//  DemoOfDrawLine
//
//  Created by NONATO on 15/3/10.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "PENGDrawLineView.h"

@interface PENGDrawLineView ()

@property (nonatomic ,assign) CGMutablePathRef path;

/**
 *  线条（路径）数组，可对这个数组进行操作，用于界面改变 -- 这个数组里存放的为字典，字典有三个值，分别为宽度、颜色、路径
 */
@property (nonatomic ,strong) NSMutableArray *pathArray;

@property (nonatomic ,assign) BOOL isHavePath;

@end

@implementation PENGDrawLineView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = 10.0;
        self.lineColor = [UIColor redColor];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = 10.0;
        self.lineColor = [UIColor redColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}

-(UIImage *)viewImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [self drawView:context];
     _viewImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    return _viewImage;
}

-(void)drawView:(CGContextRef)context
{
    for (NSMutableDictionary *tpDic in self.pathArray)
    {
        //分别获取path、width、color
        UIBezierPath *path = [tpDic objectForKey:@"path"];
        UIColor *color = [tpDic objectForKey:@"color"];
        NSNumber *widthNumber = [tpDic objectForKey:@"width"];
        CGFloat width = [widthNumber floatValue];
        
        CGContextAddPath(context, path.CGPath);
        [color set];
        CGContextSetLineWidth(context, width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (self.isHavePath)
    {
        CGContextAddPath(context, self.path);
        [self.lineColor set];
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    self.path = CGPathCreateMutable();
    self.isHavePath = YES;
    CGPathMoveToPoint(self.path, NULL, location.x, location.y);

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, location.x, location.y);
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存路径
    if (self.pathArray == nil)
    {
        self.pathArray = [NSMutableArray array];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    NSMutableDictionary *tpDic = [NSMutableDictionary dictionary];
    [tpDic setObject:self.lineColor forKey:@"color"];
    [tpDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"width"];
    [tpDic setObject:path forKey:@"path"];
    
    [self.pathArray addObject:tpDic];

    CGPathRelease(self.path);
    self.isHavePath = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(PENGDrawLineView:PathArray:)]) {
        [self.delegate PENGDrawLineView:self PathArray:self.pathArray];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

/**
 *  清空所有线条
 */
-(void)clearLine
{
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PENGDrawLineView:PathArray:)]) {
        [self.delegate PENGDrawLineView:self PathArray:self.pathArray];
    }
}

/**
 *  撤销，回到上一层
 */
-(void)goBack
{
    if (self.pathArray.count > 0)
    {
        [self.pathArray removeLastObject];
        [self setNeedsDisplay];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(PENGDrawLineView:PathArray:)]){
        [self.delegate PENGDrawLineView:self PathArray:self.pathArray];
    }
}
 

@end
