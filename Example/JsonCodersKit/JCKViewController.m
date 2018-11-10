//
//  JCKViewController.m
//  JsonCodersKit
//
//  Created by Sergey Starukhin on 02/02/2017.
//  Copyright (c) 2017 Sergey Starukhin. All rights reserved.
//

#import "JCKViewController.h"
#import "JCKVCModel.h"

@import JsonCodersKit;

JCKSynthesizeTransformer(JCKVCModel)

@interface JCKViewController ()

@end

@implementation JCKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *fileURL = [self.nibBundle URLForResource: NSStringFromClass(self.class) withExtension: @"json"];
    NSData *data = [NSData dataWithContentsOfURL: fileURL options: kNilOptions error: NULL];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: NULL];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName: JCKVCModelTransformerName];
    JCKVCModel *model = [transformer transformedValue: json];
    NSLog(@"%@", model);
    JCKJsonEncoder *coder = [[JCKJsonEncoder alloc] init];
    [coder encodeRootObject: model];
    NSDictionary *encodedJson = coder.encodedJSONObject;
    NSLog(@"%@", encodedJson);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
