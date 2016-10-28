//
//  LoginViewController.m
//  
//
//  Created by parry on 10/27/16.
//
//
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ChatViewController.h"


@interface LoginViewController ()

@property(strong,readwrite,nonatomic) UITextField *emailTextField;
@property(strong,readwrite,nonatomic) UITextField *passwordTextField;
@property(strong,readwrite,nonatomic) UIButton *signupButton;
@property(strong,readwrite,nonatomic) UIButton *loginButton;


@end

@implementation LoginViewController
#pragma mark - Initialize

- (instancetype)init
{
    self.emailTextField = [[UITextField alloc]init];
    self.passwordTextField = [[UITextField alloc] init];
    self.signupButton = [[UIButton alloc]init];
    self.loginButton = [[UIButton alloc]init];

    
    if (!(self = [super init]))
        return nil;
    
    
    return self;
}




#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    
    [self.signupButton addTarget:self
               action:@selector(signUpToParse)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton addTarget:self
                          action:@selector(loginToParse)
                forControlEvents:UIControlEventTouchUpInside];

    
    [self setConstraints];
    
}


- (void)loadView
{
    [super loadView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    [view addSubview:self.emailTextField];
    [view addSubview:self.passwordTextField];
    [view addSubview:self.signupButton];
    [view addSubview:self.loginButton];

    
}


-(void)setConstraints
{
    UILayoutGuide *margins = self.view.layoutMarginsGuide;
    
    self.emailTextField.translatesAutoresizingMaskIntoConstraints = false;
    [self.emailTextField.bottomAnchor constraintEqualToAnchor:self.passwordTextField.topAnchor constant:-70].active = YES;
    [self.emailTextField.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:20].active = YES;
    [self.emailTextField.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:-20].active = YES;
    
    self.emailTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.layer.borderWidth = 1;
    self.emailTextField.delegate = self;
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.emailTextField.layer setCornerRadius:14.0f];
    self.emailTextField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false;
    [self.passwordTextField.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:20].active = YES;
    [self.passwordTextField.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:-20].active = YES;
    [self.passwordTextField.centerXAnchor constraintEqualToAnchor:margins.centerXAnchor].active = YES;
    [self.passwordTextField.centerYAnchor constraintEqualToAnchor:margins.centerYAnchor].active = YES;
    
    self.passwordTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.passwordTextField.layer setCornerRadius:14.0f];
    self.passwordTextField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];


    self.signupButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.signupButton.topAnchor constraintEqualToAnchor:self.passwordTextField.bottomAnchor constant:30].active = YES;
    [self.signupButton.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:50].active = YES;
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    self.signupButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:13];


    
    self.loginButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.loginButton.centerYAnchor constraintEqualToAnchor:self.signupButton.centerYAnchor].active = YES;
    [self.loginButton.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:-50].active = YES;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:13];


}




-(void)signUpToParse
{
    PFUser *user = [PFUser user];
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    user.username = self.emailTextField.text;

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Signup failed :/"preferredStyle:UIAlertActionStyleCancel];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
}

-(void)loginToParse
{
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            ChatViewController *chatVC = [[ChatViewController alloc]init];
                                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatVC];
                                            
                                            [self presentViewController:nav animated:true completion:nil];
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Login failed :/"preferredStyle:UIAlertActionStyleCancel];
                                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                            [alert addAction:ok];
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }
                                    }];

    
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    

}



@end
