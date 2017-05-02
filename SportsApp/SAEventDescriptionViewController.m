//
//  SAEventDescriptionViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventDescriptionViewController.h"

@interface SAEventDescriptionViewController ()

@end

@implementation SAEventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *todayDate = [NSDate date];
  
    self.eventDate.text= [dateFormat stringFromDate:_currentEvent.date];
    
    
    
    
    _ownerName.text = _currentEvent.owner.name;
    _ownerPhoto.image = [UIImage imageWithData:_currentEvent.owner.photo];
    _eventImage.image = [UIImage imageWithData:_currentEvent.activity.picture];
    _eventGender.text = _currentEvent.sex;
    _eventNumberParticipants.text = [NSString stringWithFormat:@"%@/%d", [_currentEvent participants], _currentEvent.maxPeople];
    
    //_joinButton.image = [UIImage imageNamed:@];
    
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([[_currentEvent participants] containsObject:currentUser])
    {
        UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 7"];
        [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 6"];
        [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)jointButtonPressed:(UIButton *)sender {
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    SAPerson *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if ([[_currentEvent participants] containsObject:currentUser])
    {
        [_currentEvent removeParticipant:currentUser];
        
        UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 6"];
        [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
    }
    else
    {
        
        UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 7"];
        [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
        [_currentEvent addParticipant:currentUser withRole:nil];
        
     }
    
    
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
