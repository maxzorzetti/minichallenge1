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
@property NSMutableArray *arrayOfInvitees;
@property NSMutableArray *arrayOfNotGoingPeople;
@property NSMutableArray *arraOfNotConfirmedInvitees;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SAPerson *currentUser;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfNotConfirmedPeople;

@end

@implementation SAEventDescriptionViewController

- (void) setInitialValueOfFieldsInScreen{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionViewOfNotConfirmedPeople.delegate = self;
    self.collectionViewOfNotConfirmedPeople.dataSource = self;
    
    self.ownerName.text = self.currentEvent.owner.name;
    self.eventName.text = self.currentEvent.name;
    self.eventGender.text = self.currentEvent.sex;
    self.eventImage.image = [UIImage imageWithData:self.currentEvent.activity.picture];
    
    if ([self.currentEvent.sex isEqualToString:@"Female"]) {
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Female"];
    } else if([self.currentEvent.sex isEqualToString:@"Male"]){
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Male"];
    }else{
        self.genderIcon.image = [UIImage imageNamed:@"Icon_Mixed"];
    }

    _arrayOfParticipants = [NSMutableArray arrayWithArray:self.currentEvent.participants.allObjects];
    _arrayOfInvitees = [NSMutableArray arrayWithArray:self.currentEvent.invitees.allObjects];
    _arrayOfNotGoingPeople = [NSMutableArray arrayWithArray:self.currentEvent.notGoing.allObjects];
    _arraOfNotConfirmedInvitees = [NSMutableArray arrayWithArray:self.currentEvent.inviteesNotConfirmed.allObjects];
    
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
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    self.shiftLabel.text = [formatter stringFromDate:self.currentEvent.date];
    
}

- (void) updateCollectionViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionViewOfNotConfirmedPeople reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    [self setInitialValueOfFieldsInScreen];
    
    
    
    //make locationReadable
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currentEvent.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.eventLocation.text = [NSString stringWithFormat:@"%@, %@",placemark.subLocality ,placemark.locality];
            self.eventLocation.text = self.currentEvent.eventDescription;
        }
    }];
    
    self.eventLocation.text = self.currentEvent.eventDescription;
    
    //checks if parcitipants info is complete, if not, fetch from db
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
    
    
    
    
    
    
    
    __block NSMutableArray *arrayOfInviteesToUpdate = [NSMutableArray new];
    //checks if invitees info is complete, if not, fetch from db
    for (SAPerson *person in self.arrayOfInvitees) {
        //if invitee info is incomplete
        if ([person.name length] == 0) {
            
            
            //check if invitee info is in userdefaults
            int isPersonInDefaults = 0;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayOfDic = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
            for (NSDictionary *dicPerson in arrayOfDic) {
                NSString *personInUDRecordName = dicPerson[@"personId"];
                if ([person.personId.recordName isEqualToString:personInUDRecordName]) {
                    NSData *personData = dicPerson[@"personData"];
                    SAPerson *personToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
                    
                    [arrayOfInviteesToUpdate addObject:personToAdd];
                    isPersonInDefaults = 1;
                }
            }
            
            //invitee not in userdefaults
            if (isPersonInDefaults == 0) {
                [SAPersonConnector getPersonFromId:person.personId handler:^(SAPerson * _Nullable personFetched, NSError * _Nullable error) {
                    if (!error && personFetched) {
                        [arrayOfInviteesToUpdate addObject:personFetched];
                        //once all invitees info are complete, update table view
                        if ([arrayOfInviteesToUpdate count] == [self.arrayOfInvitees count]) {
                            self.arrayOfInvitees = arrayOfInviteesToUpdate;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }else{
                        [arrayOfInviteesToUpdate addObject:person];
                        //once all participantss info are complete update table view
                        if ([arrayOfInviteesToUpdate count] == [self.arrayOfInvitees count]) {
                            self.arrayOfInvitees = arrayOfInviteesToUpdate;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }
                }];
            }
        }
        //invitee info was already complete, just add to array
        else{
            [arrayOfInviteesToUpdate addObject:person];
        }
        
        //if all invitees info are complete update table view
        if ([arrayOfInviteesToUpdate count] == [self.arrayOfInvitees count]) {
            self.arrayOfInvitees = arrayOfInviteesToUpdate;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewOfNotConfirmedPeople reloadData];
            });
        }
        
    }
    
    
    
    __block NSMutableArray *arrayOfNotGoingPeopleToAdd = [NSMutableArray new];
    //checks if not going people info is complete, if not, fetch from db
    for (SAPerson *person in self.arrayOfNotGoingPeople) {
        //if not going person info is incomplete
        if ([person.name length] == 0) {
            
            
            //check if not going info is in userdefaults
            int isPersonInDefaults = 0;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayOfDic = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
            for (NSDictionary *dicPerson in arrayOfDic) {
                NSString *personInUDRecordName = dicPerson[@"personId"];
                if ([person.personId.recordName isEqualToString:personInUDRecordName]) {
                    NSData *personData = dicPerson[@"personData"];
                    SAPerson *personToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
                    
                    [arrayOfNotGoingPeopleToAdd addObject:personToAdd];
                    isPersonInDefaults = 1;
                }
            }
            
            //not going person not in userdefaults
            if (isPersonInDefaults == 0) {
                [SAPersonConnector getPersonFromId:person.personId handler:^(SAPerson * _Nullable personFetched, NSError * _Nullable error) {
                    if (!error && personFetched) {
                        [arrayOfNotGoingPeopleToAdd addObject:personFetched];
                        //once all not going people info are complete, update table view
                        if ([arrayOfNotGoingPeopleToAdd count] == [self.arrayOfNotGoingPeople count]) {
                            self.arrayOfNotGoingPeople = arrayOfNotGoingPeopleToAdd;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }else{
                        [arrayOfNotGoingPeopleToAdd addObject:person];
                        //once all not going people info are complete update table view
                        if ([arrayOfNotGoingPeopleToAdd count] == [self.arrayOfNotGoingPeople count]) {
                            self.arrayOfNotGoingPeople = arrayOfNotGoingPeopleToAdd;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }
                }];
            }
        }
        //not going people info was already complete, just add to array
        else{
            [arrayOfNotGoingPeopleToAdd addObject:person];
        }
        
        //if all not going people info are complete update table view
        if ([arrayOfNotGoingPeopleToAdd count] == [self.arrayOfNotGoingPeople count]) {
            self.arrayOfNotGoingPeople = arrayOfNotGoingPeopleToAdd;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewOfNotConfirmedPeople reloadData];
            });
        }
        
    }
    
    
    
    
    
    
    __block NSMutableArray *arrayOfInviteesNotConfirmedToUpdate = [NSMutableArray new];
    //checks if invitees not confirmed info is complete, if not, fetch from db
    for (SAPerson *person in self.arraOfNotConfirmedInvitees) {
        //if invitee not confirmed info is incomplete
        if ([person.name length] == 0) {
            
            
            //check if invitee not confimred info is in userdefaults
            int isPersonInDefaults = 0;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayOfDic = [userDefaults arrayForKey:@"ArrayOfDictionariesContainingPeople"];
            for (NSDictionary *dicPerson in arrayOfDic) {
                NSString *personInUDRecordName = dicPerson[@"personId"];
                if ([person.personId.recordName isEqualToString:personInUDRecordName]) {
                    NSData *personData = dicPerson[@"personData"];
                    SAPerson *personToAdd = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
                    
                    [arrayOfInviteesNotConfirmedToUpdate addObject:personToAdd];
                    isPersonInDefaults = 1;
                }
            }
            
            //invitee not confirmed not in userdefaults
            if (isPersonInDefaults == 0) {
                [SAPersonConnector getPersonFromId:person.personId handler:^(SAPerson * _Nullable personFetched, NSError * _Nullable error) {
                    if (!error && personFetched) {
                        [arrayOfInviteesNotConfirmedToUpdate addObject:personFetched];
                        //once all invitees not confirmed info are complete, update table view
                        if ([arrayOfInviteesNotConfirmedToUpdate count] == [self.arraOfNotConfirmedInvitees count]) {
                            self.arraOfNotConfirmedInvitees = arrayOfInviteesNotConfirmedToUpdate;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }else{
                        [arrayOfInviteesNotConfirmedToUpdate addObject:person];
                        //once all not confirmed invitees info are complete update table view
                        if ([arrayOfInviteesNotConfirmedToUpdate count] == [self.arraOfNotConfirmedInvitees count]) {
                            self.arraOfNotConfirmedInvitees = arrayOfInviteesNotConfirmedToUpdate;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.collectionViewOfNotConfirmedPeople reloadData];
                            });
                        }
                    }
                }];
            }
        }
        //invitee info was already complete, just add to array
        else{
            [arrayOfInviteesNotConfirmedToUpdate addObject:person];
        }
        
        //if all not confirmed invitees info are complete update table view
        if ([arrayOfInviteesNotConfirmedToUpdate count] == [self.arraOfNotConfirmedInvitees count]) {
            self.arraOfNotConfirmedInvitees = arrayOfInviteesNotConfirmedToUpdate;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewOfNotConfirmedPeople reloadData];
            });
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma collection view population methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAFriendCollectionViewCell *cell;
    
    SAPerson *friend;
    
    //checks what collection view to insert person
    //not confirmed(invitee)
    if (collectionView == self.collectionViewOfNotConfirmedPeople) {
        switch (indexPath.section) {
            case 0:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inviteeCell" forIndexPath:indexPath];
                friend = self.arrayOfInvitees[indexPath.item];
                if (friend.photo) {
                    cell.profileInvitee.image = [UIImage imageWithData:friend.photo];
                }else{
                    cell.profileInvitee.image = [UIImage imageNamed:@"img_placeholder.png"];
                }
                cell.profileInvitee.layer.borderColor = [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1.0].CGColor;
                break;
            case 1:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inviteeCell" forIndexPath:indexPath];
                friend = self.arrayOfNotGoingPeople[indexPath.item];
                if (friend.photo) {
                    cell.profileInvitee.image = [UIImage imageWithData:friend.photo];
                }else{
                    cell.profileInvitee.image = [UIImage imageNamed:@"img_placeholder.png"];
                }
                cell.profileInvitee.layer.borderColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
                break;
            case 2:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inviteeCell" forIndexPath:indexPath];
                friend = self.arraOfNotConfirmedInvitees[indexPath.item];
                if (friend.photo) {
                    cell.profileInvitee.image = [UIImage imageWithData:friend.photo];
                }else{
                    cell.profileInvitee.image = [UIImage imageNamed:@"img_placeholder.png"];
                }
                cell.profileInvitee.layer.borderColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0].CGColor;
                break;
            default:
                break;
        }
    }
    //confirmed person
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
        friend = self.arrayOfParticipants[indexPath.item];
        cell.profileImageBruno.layer.borderColor = [UIColor colorWithRed:50/255.0 green:226/255.0 blue:196/255.0 alpha:1.0].CGColor;
        if (friend.photo) {
            cell.profileImageBruno.image = [UIImage imageWithData:friend.photo];
        }else{
            cell.profileImageBruno.image = [UIImage imageNamed:@"img_placeholder.png"];
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    
    if (collectionView == self.collectionViewOfNotConfirmedPeople) {
        switch (section) {
            case 0:
                numberOfItems = [self.arrayOfInvitees count];
                break;
            case 1:
                numberOfItems = [self.arrayOfNotGoingPeople count];
                break;
            case 2:
                numberOfItems = [self.arraOfNotConfirmedInvitees count];
                break;
            default:
                break;
        }
        
    }else{
        numberOfItems = [self.arrayOfParticipants count];
    }
    
    return numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //checks what collection view
    //not confirmed(invitee)
    if (collectionView == self.collectionViewOfNotConfirmedPeople) {return 3;}else{return 1;};
}

#pragma methods to update participants

- (void)updateCollectionViewWithParticipants:(NSArray *)participants{
    [self.currentEvent replaceParticipants:participants];
    self.arrayOfParticipants = [NSMutableArray arrayWithArray:participants];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionViewOfNotConfirmedPeople reloadData];
    });
}


//this method also modifies button behaviour
- (void)updateParticipantStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        //define value for progress bar
		//NSLog(@"%lu %f", (unsigned long)self.currentEvent.participants.count, self.currentEvent.maxPeople.floatValue);
        self.progressView.progress = [self.currentEvent.participants count] / [self.currentEvent.maxPeople floatValue];
        self.eventCapacity.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)[self.currentEvent.participants count], self.currentEvent.maxPeople];
        
        
        
        NSComparisonResult result = [self.currentEvent.date compare:[NSDate date]];
        
        if([self.currentEvent.participants count] == [self.currentEvent.maxPeople integerValue] || result == NSOrderedAscending || [self.currentEvent.owner.personId.recordName isEqualToString:self.currentUser.personId.recordName]){
            self.buttonView.hidden = YES;
        }else{
            self.buttonView.hidden = NO;
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
        }
    });
}

- (IBAction)modifyParticipantsOfEvent:(UIButton *)sender {
    int toRegister = 1;
    //if current user already a participant
    for (SAPerson *person in self.currentEvent.participants) {
        if ([person.personId.recordName isEqualToString:self.currentUser.personId.recordName]) {
            toRegister = 0;
            self.modifyParticipantButton.userInteractionEnabled = NO;
            
            //leave event
            [SAEventConnector removeParticipant:self.currentUser ofEvent:self.currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
                if (!error) {
                    //update participants list
                    [self updateCollectionViewWithParticipants:[event.participants allObjects]];
                    
                    //update invitee list
                    self.arrayOfInvitees =  [NSMutableArray arrayWithArray:[event.invitees allObjects]];
                    
                    //update not going people list
                    self.arrayOfNotGoingPeople = [NSMutableArray arrayWithArray:[event.notGoing allObjects]];
                    
                    //update not confirmed people list
                    self.arraOfNotConfirmedInvitees = [NSMutableArray arrayWithArray:[event.inviteesNotConfirmed allObjects]];
                    
                    //update button content
                    [self updateParticipantStatus];
                }
            }];
        }
    }
    
    //if current user not a participant
    if (toRegister) {
        self.modifyParticipantButton.userInteractionEnabled = NO;
        
        //register in event
        [SAEventConnector registerParticipant:self.currentUser inEvent:self.currentEvent handler:^(SAEvent * _Nullable event, NSError * _Nullable error) {
            if (!error) {
                //update participants list
                [self updateCollectionViewWithParticipants:[event.participants allObjects]];
                
                //update invitee list
                self.arrayOfInvitees =  [NSMutableArray arrayWithArray:[event.invitees allObjects]];
                
                //update not going people list
                self.arrayOfNotGoingPeople = [NSMutableArray arrayWithArray:[event.notGoing allObjects]];
                
                //update not confirmed people list
                self.arraOfNotConfirmedInvitees = [NSMutableArray arrayWithArray:[event.inviteesNotConfirmed allObjects]];
                
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
