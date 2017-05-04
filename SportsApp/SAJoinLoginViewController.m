//
//  SAJoinLoginViewController.m
//  SportsApp
//
//  Created by Bharbara Cechin on 24/04/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAJoinLoginViewController.h"

@interface SAJoinLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnJoinus;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property UIViewController *vc;
@property UIPageViewController *pageViewController;
@property NSArray *pages;

@end

@implementation SAJoinLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pages = @[@"Intro1ViewController", @"Intro2ViewController", @"Intro3ViewController"];
    
    self.vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPageViewController"];
    [self addChildViewController:self.vc];
    [self.view addSubview:self.vc.view];
    
    // Page view controller configurations
    self.pageViewController = (UIPageViewController *)self.vc;
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
    
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Page before and after

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    // id da pagina atual
    NSUInteger index = [self.pages indexOfObject:viewController.restorationIdentifier];
    
    // se a pagina atual não for a primeira, passa para a anterior
    if(index > 0){
        return [self viewControllerAtIndex:index - 1];
    }
    
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    // id da pagina atual
    NSUInteger index = [self.pages indexOfObject:viewController.restorationIdentifier];
    
    // se a pagina atual não for a ultima, passa para a proxima
    if(index < [self.pages count] -1){
        return [self viewControllerAtIndex:index + 1];
    }
    
    return nil;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    // pode ser nil ou ou uma uiviewcontroller
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:(self.pages[index])];
    
    return viewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
