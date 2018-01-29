//
//  DTMHeatmap.m
//  HeatMapTest
//
//  Created by Bryan Oltman on 1/6/15.
//  Copyright (c) 2015 Dataminr. All rights reserved.
//

#import "DTMHeatmap.h"
#import "DTMColorProvider.h"

@interface DTMHeatmap ()
@property double maxValue;
@property double zoomedOutMax;
@property NSDictionary *pointsWithHeat;
@property CLLocationCoordinate2D center;
@property MKMapRect boundingRect;
@end

@implementation DTMHeatmap

@synthesize maxValue, pointsWithHeat = _pointsWithHeat;
@synthesize zoomedOutMax;
@synthesize center, boundingRect;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colorProvider = [DTMColorProvider new];
    }
    [self setupHeatmaps];
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.center;
}

- (MKMapRect)boundingMapRect
{
    return self.boundingRect;
}

- (NSDictionary *)parseLatLonFile:(NSString *)fileName
{
    NSMutableDictionary *ret = [NSMutableDictionary new];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *parts = [line componentsSeparatedByString:@","];
        NSString *latStr = parts[0];
        NSString *lonStr = parts[1];
        CLLocationDegrees latitude = [latStr doubleValue];
        CLLocationDegrees longitude = [lonStr doubleValue];
        //NSLog(@"WH %@", lonStr);
        
        // For this example, each location is weighted equally
        double weight = 1;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
        NSValue *pointValue = [NSValue value:&point
                                withObjCType:@encode(MKMapPoint)];
        ret[pointValue] = @(weight);
    }
    
    return ret;
}

- (void)setupHeatmaps
{
    [self setData:[self parseLatLonFile:@"mcdonalds"]];
}

- (void)setData:(NSDictionary *)newHeatMapData
{
    MKMapPoint upperLeftPoint, lowerRightPoint;
    [[[newHeatMapData allKeys] lastObject] getValue:&upperLeftPoint];
    lowerRightPoint = upperLeftPoint;
    
    NSEnumerator *enumerator = [newHeatMapData keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        NSLog(@"key:%@",key);
    }
    
    float *buckets = calloc(kSBZoomZeroDimension * kSBZoomZeroDimension, sizeof(float));
    for (NSValue *mapPointValue in newHeatMapData) {
        MKMapPoint point;
        [mapPointValue getValue:&point];
        double value = [[newHeatMapData objectForKey:mapPointValue] doubleValue];
        
        if (point.x < upperLeftPoint.x) upperLeftPoint.x = point.x;
        if (point.y < upperLeftPoint.y) upperLeftPoint.y = point.y;
        if (point.x > lowerRightPoint.x) lowerRightPoint.x = point.x;
        if (point.y > lowerRightPoint.y) lowerRightPoint.y = point.y;
        
        double abs = ABS(value);
        if (abs > self.maxValue) {
            self.maxValue = abs;
        }
        
        //bucket the map point:
        int col = point.x / (kSBMapKitPoints / kSBZoomZeroDimension);
        int row = point.y / (kSBMapKitPoints / kSBZoomZeroDimension);
        
        int offset = kSBZoomZeroDimension * row + col;
        
        buckets[offset] += value;
    }
    
    for (int i = 0; i < kSBZoomZeroDimension * kSBZoomZeroDimension; i++) {
        double abs = ABS(buckets[i]);
        if (abs > self.zoomedOutMax) {
            self.zoomedOutMax = abs;
        }
    }
    
    free(buckets);
    
    double width = lowerRightPoint.x - upperLeftPoint.x + kSBMapRectPadding;
    double height = lowerRightPoint.y - upperLeftPoint.y + kSBMapRectPadding;
    
    self.boundingRect = MKMapRectMake(upperLeftPoint.x - kSBMapRectPadding / 2,
                                      upperLeftPoint.y - kSBMapRectPadding / 2,
                                      width, height);
    self.center = MKCoordinateForMapPoint(MKMapPointMake(upperLeftPoint.x + width / 2,
                                                         upperLeftPoint.y + height / 2));
    self.pointsWithHeat = newHeatMapData;
}

- (NSDictionary *)mapPointsWithHeatInMapRect:(MKMapRect)rect
                                     atScale:(MKZoomScale)scale
{
    NSMutableDictionary *toReturn = [[NSMutableDictionary alloc] init];
    int bucketDelta = kSBScreenPointsPerBucket / scale;
    
    double zoomScale = log2(1/scale);
    double slope = (self.zoomedOutMax - self.maxValue) / (kSBZoomLevels - 1);
    double x = pow(zoomScale, kSBScalePower) / pow(kSBZoomLevels, kSBScalePower - 1);
    double scaleFactor = (x - 1) * slope + self.maxValue;
   
    if (scaleFactor < self.maxValue) {
        scaleFactor = self.maxValue;
    }
    
    for (NSValue *key in self.pointsWithHeat) {
        MKMapPoint point;
        [key getValue:&point];
        
        if (!MKMapRectContainsPoint(rect, point)) {
            continue;
        }
        
        // Scale the value down by the max and add it to the return dictionary
        NSNumber *value = [self.pointsWithHeat objectForKey:key];
        double unscaled = [value doubleValue];
        double scaled = unscaled / scaleFactor;
        
        MKMapPoint bucketPoint;
        int originalX = point.x;
        int originalY = point.y;
        bucketPoint.x = originalX - originalX % bucketDelta + bucketDelta / 2;
        bucketPoint.y = originalY - originalY % bucketDelta + bucketDelta / 2;
        NSValue *bucketKey = [NSValue value:&bucketPoint withObjCType:@encode(MKMapPoint)];
        
        NSNumber *existingValue = toReturn[bucketKey];
        if (existingValue) {
            scaled += [existingValue doubleValue];
        }
        
        [toReturn setObject:[NSNumber numberWithDouble:scaled] forKey:bucketKey];
    }
    
    return toReturn;
}

@end
