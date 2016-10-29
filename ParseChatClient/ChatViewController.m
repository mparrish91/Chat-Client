
//
//  ChatViewController.m
//  
//
//  Created by parry on 10/28/16.
//
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import <Parse/Parse.h>


@interface ChatViewController ()

@property(strong,readwrite,nonatomic) UITextField *chatTextField;
@property(strong,readwrite,nonatomic) UIButton *sendButton;
@property(nonatomic,strong) UITableView *chatsTableView;

@property(strong,readwrite,nonatomic) NSArray *messages;


@end

@implementation ChatViewController

#pragma mark - Initialize

- (instancetype)init
{
    self.chatTextField = [[UITextField alloc]init];
    self.sendButton = [[UIButton alloc]init];
    self.chatsTableView = [[UITableView alloc]init];

    
    
    if (!(self = [super init]))
        return nil;
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Chat";
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.chatsTableView.estimatedRowHeight = 100;
    self.chatsTableView.rowHeight = UITableViewAutomaticDimension;
    NSString *cellIdentifier = @"cell";
    [self.chatsTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.chatsTableView.delegate = self;
    self.chatsTableView.dataSource = self;


    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    
    [self.sendButton addTarget:self
                          action:@selector(onSendButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];


    [self setConstraints];
    
}


#pragma mark - TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return 100;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    return cell;
}

//This function is where all the magic happens
-(void) tableView:(UITableView *) tableView willDisplayCell:(MessageTableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *messageText = message[@"text"];
    cell.textLabel.text = messageText;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



- (void)loadView
{
    [super loadView];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    [view addSubview:self.chatTextField];
    [view addSubview:self.sendButton];
    [view addSubview:self.chatsTableView];

    
}


-(void)setConstraints
{
    UILayoutGuide *margins = self.view.layoutMarginsGuide;
    
    self.chatTextField.translatesAutoresizingMaskIntoConstraints = false;
    [self.chatTextField.topAnchor constraintEqualToAnchor:margins.topAnchor].active = YES;
    [self.chatTextField.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:10].active = YES;
    [self.chatTextField.trailingAnchor constraintEqualToAnchor:self.sendButton.leadingAnchor constant:2].active = YES;
    
    self.chatTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
    self.chatTextField.textAlignment = NSTextAlignmentCenter;
    self.chatTextField.layer.borderWidth = 1;
    self.chatTextField.delegate = self;
    self.chatTextField.layer.borderWidth = 1.0f;
    self.chatTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.chatTextField.layer setCornerRadius:14.0f];
    self.chatTextField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    self.chatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say Something" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    
    
    self.sendButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.sendButton.widthAnchor constraintEqualToConstant:80].active = YES;

    [self.sendButton.topAnchor constraintEqualToAnchor:margins.topAnchor].active = YES;
    [self.sendButton.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:13];
    
    
    
    self.chatsTableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.chatsTableView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
    [self.chatsTableView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
    [self.chatsTableView.topAnchor constraintEqualToAnchor:self.chatTextField.bottomAnchor].active = YES;
    [self.chatsTableView.bottomAnchor constraintEqualToAnchor:margins.bottomAnchor].active = YES;
    

}

- (void)onSendButtonPressed
{
    PFObject *message = [PFObject objectWithClassName:@"Messages"];
    message[@"text"] = self.chatTextField.text;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"The object has been saved.");

        } else {
            // There was a problem, check error.description
        }
    }];

}

- (void)refreshTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query setLimit: 1000];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            self.messages = objects;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatsTableView reloadData];
            });

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
