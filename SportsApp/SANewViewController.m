//
//  SANewViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SANewViewController.h"
#import "SAIntro1ViewController.h"

@interface SANewViewController ()

@end

@implementation SANewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitles = @[@"Exercise your own way",@"Exercise in groups",@"Exercise wherever you are"];
    self.pageSubtitles = @[@"Find activities according to your interests and availability.",@"Connect with your friends and with anyone who motivates you.",@"Discover new events and activities available anywhere."];
    self.pageImages = @[@"imageIntro1.png", @"imageIntro2.png", @"imageIntro3.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"introView"];
    self.pageViewController.dataSource = self;
    
    SAIntro1ViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Page before
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((SAIntro1ViewController *)viewController).pageNumber;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

// Page after
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    NSUInteger index = ((SAIntro1ViewController *)viewController).pageNumber;
    
    if ((index == [self.pageTitles count]) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

// Logica do PageController (quase) todo, onde uma view nova é criada, com o mesmo "framework" da PageContentController
- (SAIntro1ViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    SAIntro1ViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"introView"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageNumber = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
