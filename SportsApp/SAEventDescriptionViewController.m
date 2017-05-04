//
//  SAEventDescriptionViewController.m
//  SportsApp
//
//  Created by Laura Corssac on 02/05/17.
//  Copyright © 2017 Bruno Scheltzke. All rights reserved.
//

#import "SAEventDescriptionViewController.h"
#import "SAPersonConnector.h"
#import "SAPerson.h"
#import "SAFriendCollectionViewCell.h"

@interface SAEventDescriptionViewController ()
@property NSMutableArray *arrayOfParticipants;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SAEventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.progressView.progress = (float)[self.currentEvent.participants count];
    self.eventNumberParticipants.text = [NSString stringWithFormat:@"%ld,%@", (long)[self.currentEvent.participants count], self.currentEvent.minPeople];
    
    _arrayOfParticipants = [NSMutableArray arrayWithArray:self.currentEvent.participants.allObjects];
    
    __block NSMutableArray *arrayToUpdate = [NSMutableArray new];
    for (SAPerson *person in self.arrayOfParticipants) {
        //if participant info is incomplete
        if ([person.name length] == 0) {
            
            
            //check if participant info is in userdefaults
            int isPersonInDefaults = 0;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayOfDic = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
            for (NSDictionary *dicPerson in arrayOfDic) {
                NSString *personInUDRecordName = dicPerson[@"personId"];
                if ([person.personId.recordName isEqualToString:personInUDRecordName]) {
                    NSData *personData = dicPerson[@"personData"];
                    SAPerson *personToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
                    
                    [arrayToUpdate addObject:personToAdd];
                    isPersonInDefaults = 1;
                }
            }
            
            //participant not in userdefaults
            if (isPersonInDefaults == 0) {
                [SAPersonConnector getPersonFromId:person.personId handler:^(SAPerson * _Nullable personFetched, NSError * _Nullable error) {
                    if (!error && personFetched) {
                        [arrayToUpdate addObject:personFetched];
                        //once all participantss info are complete update table view
                        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
                            [self updateCollectionViewWithParticipants:arrayToUpdate];
                        }
                    }else{
                        [arrayToUpdate addObject:person];
                        //once all participantss info are complete update table view
                        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
                            [self updateCollectionViewWithParticipants:arrayToUpdate];
                        }
                    }
                }];
            }
        }
        //participant info was already complete, just add to array
        else{
            [arrayToUpdate addObject:person];
        }
        
        //once all participantss info are complete update table view
        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
            [self updateCollectionViewWithParticipants:arrayToUpdate];
        }
        
    }
    
    
    
    _mainView.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
    
    _mainView.layer.borderWidth = 1.0;
    
    _mainView.layer.cornerRadius = 8.0;
    
    
    self.ownerPhoto.layer.cornerRadius = self.ownerPhoto.frame.size.height /2;
    self.ownerPhoto.layer.masksToBounds = YES;
    self.ownerPhoto.layer.borderWidth = 0;
    
    
    
    if (_currentEvent.owner.photo==nil) {
        self.ownerPhoto.image = [UIImage imageNamed:@"img_placeholder.png"];
    }else{
        self.ownerPhoto.image = [UIImage imageWithData:_currentEvent.owner.photo];
    }

    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *todayDate = [NSDate date];
  
    self.eventDate.text= [dateFormat stringFromDate:_currentEvent.date];
    
    _progressView.frame = CGRectMake(29, 235, 269, 7);
    _progressView.progressTintColor = [UIColor colorWithRed:50.0/255.0 green:226.0/255.0 blue:196.0/255.0 alpha:1.0];
    
    _ownerName.text = _currentEvent.owner.name;
    
    
    _eventName.text = _currentEvent.name;
    _eventImage.image = [UIImage imageWithData:_currentEvent.activity.picture];
    _eventGender.text = _currentEvent.sex;
    _eventNumberParticipants.text = [NSString stringWithFormat:@"%@/%@", [_currentEvent participants], _currentEvent.maxPeople];
    
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
        
        [SAEventConnector removeParticipant:currentUser ofEvent:_currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
            if (!error)
            {
        
                [_currentEvent removeParticipant:currentUser];
        
                UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 6"];
                [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
                
            }}];

    }
    else
    {
        
        
        [SAEventConnector registerParticipant:currentUser inEvent:_currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
            if (!error)
            {

                UIImage *backgroungImage = [UIImage imageNamed:@"Rectangle Copy 7"];
                [_joinButton setBackgroundImage:backgroungImage forState:UIControlStateNormal];
                 [_currentEvent addParticipant:currentUser];
            }}];
       
        
     }
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
    
    SAPerson *friend = self.arrayOfParticipants[indexPath.item];
    
    if (friend.photo) {
        cell.profileImageBruno.image = [UIImage imageWithData:friend.photo];
    }else{
        cell.profileImageBruno.image = [UIImage imageNamed:@"img_placeholder.png"];
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItems;
    switch (section) {
        case 0: numberOfItems = [self.arrayOfParticipants count]; break;
        default: numberOfItems = 0;
    }
    return numberOfItems;
}


- (void)updateCollectionViewWithParticipants:(NSArray *)participants{
    [self.currentEvent replaceParticipants:participants];
    self.arrayOfParticipants = [NSMutableArray arrayWithArray:participants];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    
    
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
