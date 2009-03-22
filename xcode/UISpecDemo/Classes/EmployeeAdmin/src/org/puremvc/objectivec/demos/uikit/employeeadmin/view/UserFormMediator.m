//
//  UserFormMediator.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserFormMediator.h"

@implementation UserFormMediator

+(NSString *)NAME {
	return @"UserFormMediator";
}

-(UserForm *)viewComponent {
	return viewComponent;
}

-(void)initializeMediator {
	self.mediatorName = [UserFormMediator NAME];
}

-(void)onRegister {
	self.viewComponent.delegate = self;
}

-(NSArray *)listNotificationInterests {
	return [NSArray arrayWithObjects:ShowEditUser, ShowNewUser, nil];
}

-(void)createUserSelected:(UserVO *)userVO {
	[self sendNotification:CreateUser body:userVO];
}

-(void)updateUserSelected:(UserVO *)userVO {
	[self sendNotification:UpdateUser body:userVO];
}

-(void)userRolesSelected:(UserVO *)userVO {
	[self sendNotification:ShowUserRoles body:userVO.username];
}

-(void)handleNotification:(id<INotification>)notification {
	self.viewComponent.view = nil;
	if ([[notification name] isEqualToString:ShowEditUser]) {
		self.viewComponent.userVO = [notification body];
		self.viewComponent.mode = EDIT;
	} else if ([[notification name] isEqualToString:ShowNewUser]) {
		self.viewComponent.userVO = [[[UserVO alloc] init] autorelease];
		self.viewComponent.mode = NEW;
	}
	[self sendNotification:ShowUserForm body:self.viewComponent];
}

-(void)dealloc {
	[super dealloc];
}

@end
