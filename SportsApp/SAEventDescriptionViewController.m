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
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "SAParty.h"

@interface SAEventDescriptionViewController ()
@property NSMutableArray *arrayOfParticipants;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SAPerson *currentUser;

@end

@implementation SAEventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.ownerName.text = self.currentEvent.owner.name;
    self.eventName.text = self.currentEvent.name;
    self.eventGender.text = self.currentEvent.sex;
    
    if ([self.currentEvent.sex isEqualToString:@"Female"]) {
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Female"];
    } else if([self.currentEvent.sex isEqualToString:@"Male"]){
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Male"];
    }else{
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Mixed"];
    }
    
    //make locationReadable
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currentEvent.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.eventLocation.text = [NSString stringWithFormat:@"%@, %@",placemark.subLocality ,placemark.locality];
        }
    }];
    
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
        
        //if all participantss info are complete update table view
        if ([arrayToUpdate count] == [self.arrayOfParticipants count]) {
            [self updateCollectionViewWithParticipants:arrayToUpdate];
        }
        
    }
    
    //add border and margin to main view
    self.mainView.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
    self.mainView.layer.borderWidth = 1.0;
    self.mainView.layer.cornerRadius = 8.0;
    
    [self updateParticipantStatus];
    
    self.ownerPhoto.layer.cornerRadius = self.ownerPhoto.frame.size.height /2;
    self.ownerPhoto.layer.masksToBounds = YES;
    self.ownerPhoto.layer.borderWidth = 0;
    
    
    
    if (self.currentEvent.owner.photo==nil) {
        self.ownerPhoto.image = [UIImage imageNamed:@"img_placeholder.png"];
    }else{
        self.ownerPhoto.image = [UIImage imageWithData:self.currentEvent.owner.photo];
    }

    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
  
    self.eventDate.text= [dateFormat stringFromDate:self.currentEvent.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)updateParticipantStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        //define value for progress bar
        self.progressView.progress = [self.currentEvent.participants count] / [self.currentEvent.minPeople floatValue];
        self.eventCapacity.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)[self.currentEvent.participants count], self.currentEvent.minPeople];
        
        //define border and margin of Join/Leave button
        self.buttonView.layer.borderColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0].CGColor;
        self.buttonView.layer.borderWidth = 1.0;
        self.buttonView.layer.cornerRadius = 8.0;
        self.modifyParticipantButton.userInteractionEnabled = YES;
        
        for (SAPerson *participant in self.currentEvent.participants) {
            if ([participant.personId.recordName isEqualToString:self.currentUser.personId.recordName]) {
                //current user is a participant of the event, show LEAVE button
                self.buttonView.backgroundColor = [UIColor whiteColor];
                [self.modifyParticipantButton setTitle:@"LEAVE" forState:UIControlStateNormal];
                [self.modifyParticipantButton setTitleColor:[UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0] forState:UIControlStateNormal];
                return;
            }
        }
        
        //current user is not a participant of the event, show JOIN button
        self.buttonView.backgroundColor = [UIColor colorWithRed:119/255.0 green:90/255.0 blue:218/255.0 alpha:1.0];
        [self.modifyParticipantButton setTitle:@"JOIN" forState:UIControlStateNormal];
        [self.modifyParticipantButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
}

- (IBAction)modifyParticipantsOfEvent:(UIButton *)sender {
    int toRegister = 1;
    for (SAPerson *person in self.currentEvent.participants) {
        if ([person.personId.recordName isEqualToString:self.currentUser.personId.recordName]) {
            toRegister = 0;
            self.modifyParticipantButton.userInteractionEnabled = NO;
            
            //leave event
            [SAEventConnector removeParticipant:self.currentUser ofEvent:self.currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
                if (!error) {
                    //update participants list
                    [self updateCollectionViewWithParticipants:[event.participants allObjects]];
                    
                    //update button content
                    [self updateParticipantStatus];
                }
            }];
        }
    }
    
    if (toRegister) {
        self.modifyParticipantButton.userInteractionEnabled = NO;
        
        //register in event
        [SAEventConnector registerParticipant:self.currentUser inEvent:self.currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
            if (!error) {
                //update participants list
                [self updateCollectionViewWithParticipants:[event.participants allObjects]];
                
                //update button content
                [self updateParticipantStatus];
            }
        }];
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
